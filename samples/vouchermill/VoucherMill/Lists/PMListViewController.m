//
//  PMListViewController.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/13/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <PayMillSDK/PMSDK.h>
#import "PMVoucher.h"
#import "Constants.h"
#import "PMVoucherUtils.h"

@interface PMListViewController ()

@end

@implementation PMListViewController
@synthesize segments, theTableView, items, boughtItems, reservedItems, voucherState;

- (void)viewDidLoad
{
    [super viewDidLoad];
    boughtItems = [[NSMutableArray alloc] init];
    switch (voucherState) {
        case Online:
            self.title = @"Online Vouchers";
            break;
        case Offline:
            self.title = @"Offline Vouchers";
            break;
        case NotConsumed:
            self.title = @"Not Consumed";
            break;            
        default:
            break;
    }

	if(self.segments.count >= 1)
	{
        UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
        UIColor *color = [UIColor whiteColor];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, color, UITextAttributeTextColor,nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segments];
		[segmentedControl setTitleTextAttributes:attrs forState:UIControlStateNormal];
		
		segmentedControl.selectedSegmentIndex = 0;
		segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		segmentedControl.frame = CGRectMake
		(
		 self.view.center.x -  (segmentedControl.frame.size.width+20)/2,
         segmentedControl.frame.size.height,
		 segmentedControl.frame.size.width + 20,
		 segmentedControl.frame.size.height + 10
		 );
        [segmentedControl setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [segmentedControl setDividerImage:[UIImage imageNamed:@"divider_selected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segmentedControl.layer setMasksToBounds:YES];
        [segmentedControl.layer setBorderWidth:2.0f];
        [segmentedControl.layer setBorderColor:darkOrangeColor.CGColor];
        [segmentedControl.layer setCornerRadius:10.0f];
		
		[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
		
		[self.view addSubview:segmentedControl];
		
        //set tableview separator color
		[theTableView setSeparatorColor:lightOrangeColor];
        
        boughtItems = items;
	}
	else
	{
		
	}

    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"VoucherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[[UIColor alloc]initWithRed:255/255.0f green:218/255.0f  blue:202/255.0f alpha:1 ]];
    [cell setSelectedBackgroundView:bgColorView];

	if (voucherState == Offline) {
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		[cell setAccessoryType:NO];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	}
		
	PMVoucher *vouch = items[indexPath.row];
	cell.imageView.image = vouch.voucherImage;
	cell.textLabel.text = vouch.voucherDescrpition;
	cell.textLabel.textColor = darkOrangeColor;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", vouch.voucherAmount, vouch.voucherCurrency];
	cell.detailTextLabel.textColor = darkOrangeColor;
	
    
	return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // this method is not called    
}

#pragma mark - segue data

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailsPush"]) {
        DetailsViewController *detailsView = segue.destinationViewController;
		detailsView.delegate = self;
        PMVoucher *voucherWannaBe = [self.items objectAtIndex:theTableView.indexPathForSelectedRow.row ];
        detailsView.theVoucher = voucherWannaBe;
        [theTableView deselectRowAtIndexPath:theTableView.indexPathForSelectedRow animated:YES];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (voucherState == Offline) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - actions

-(void)segmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        items = boughtItems;
		[theTableView reloadData];
    } else {
		if(!reservedItems){
			reservedItems = [NSMutableArray array];
			//items = reservedItems;
			[PMManager getPreauthorizationsList:^(NSArray *preauthorizations) {
				for (PMPreauthorization *preauthorization in preauthorizations) {
					[reservedItems addObject:[PMVoucherUtils voucherFromPMObject:preauthorization]];
				}
				items = reservedItems;
				[theTableView reloadData];
			} onFailure:^(NSError *error) {
				[PMVoucherUtils showErrorAlertWithTitle:@"Get Preauthorization failure" errorType:error.code errorMessage:error.localizedDescription];
			}];

		}
		else {
			items = reservedItems;
			[theTableView reloadData];
		}
	}
}
#pragma mark - PMDetailsViewDelegate
-(void)reloadTable
{
	[items removeAllObjects];
	[PMManager getNonConsumedTransactionsList:^(NSArray *notConsumedTransactions) {
		for (PMTransaction *transaction in notConsumedTransactions) {
				PMVoucher *voucher = [PMVoucherUtils voucherFromPMObject:transaction];
				voucher.voucherType = NotConsumed;
				[items addObject:voucher];
		}
		[theTableView reloadData];
		
	} failure:^(NSError *error) {
		[PMVoucherUtils showErrorAlertWithTitle:@"Get transactions failure:" errorType:error.code errorMessage:error.localizedDescription];
	}];
}
@end
