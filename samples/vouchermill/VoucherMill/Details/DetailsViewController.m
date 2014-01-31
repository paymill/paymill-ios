//
//  DetailsViewController.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 6/27/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "DetailsViewController.h"
#import <PayMillSDK/PMSDK.h>
#define kLabelFontSize 14
#define darkOrangeColor [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0]
#define lightOrangeColor [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0]

@interface DetailsViewController ()
-(IBAction)consumeAction:(id)sender;
@end

@implementation DetailsViewController

@synthesize theVoucher, detailsTable, detailsList, voucherImage, delegate;


- (void)viewDidLoad
{
    NSMutableArray *arrayOfSections;
    [super viewDidLoad];
    if (theVoucher.voucherType == Online) {
        self.title = @"Online Details";
    } else {
        self.title = @"NC Details";
    }
	if(theVoucher.voucherType == NotConsumed) {
		UIBarButtonItem *consumeButton =  [[UIBarButtonItem alloc]initWithTitle:@"Consume" style:UIBarButtonItemStyleDone target:self action:@selector(consumeAction:)];
		self.navigationItem.rightBarButtonItem = consumeButton;
	}
    voucherImage.image = theVoucher.voucherBigImage;
    [detailsTable setBackgroundView:nil];
    [detailsTable setBackgroundColor:[UIColor clearColor]];
    UIColor *color = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    [detailsTable setSeparatorColor:color];
    NSString *amountCurrency = [NSString stringWithFormat:@"%@%@", theVoucher.voucherAmount, theVoucher.voucherCurrency];
    NSArray *firstSection = [NSArray arrayWithObjects:amountCurrency, theVoucher.voucherCreationDate, theVoucher.voucherDescrpition, theVoucher.voucherStatus, nil];
    NSArray *secondSection = [NSArray arrayWithObjects:theVoucher.voucherCreditCardNumber, theVoucher.voucherCreditCardType, nil];
    NSArray *thirdSection = [NSArray arrayWithObjects:theVoucher.voucherAccount, theVoucher.voucherBankCode, nil];
    if (theVoucher.isCreditCard) {
        arrayOfSections = [[NSMutableArray alloc] initWithObjects:firstSection, secondSection, nil];
    } else {
        arrayOfSections = [[NSMutableArray alloc] initWithObjects:firstSection, thirdSection, nil];
    }
     [self setDetailsList:arrayOfSections];
    
}

-(IBAction)consumeAction:(id)sender
{
	[PMManager consumeTransactionForId:theVoucher.transactionId success:^(NSString *id) {
		[delegate reloadTable];
	} failure:^(NSError *error) {
	}];
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.detailsList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionContents = [self.detailsList objectAtIndex:section];
    return [sectionContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = lightOrangeColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *sectionContents = [self.detailsList objectAtIndex:[indexPath section]];
    cell.detailTextLabel.text = [sectionContents objectAtIndex:[indexPath row]];
    cell.detailTextLabel.textColor = darkOrangeColor;
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
    // check number of objects to determine the section, then set correct title for every row
    if (sectionContents.count > 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Amount:";
                break;
            case 1:
                cell.textLabel.text = @"Created at:";
                break;
            case 2:
                cell.textLabel.text = @"Description:";
                break;
            case 3:
                cell.textLabel.text = @"Status:";
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                if (theVoucher.isCreditCard) {
                    cell.textLabel.text = @"Credit Card:";
                } else {
                    cell.textLabel.text = @"Account:";
                }
                break;
            case 1:
                if (theVoucher.isCreditCard) {
                    cell.textLabel.text = @"Type:";
                } else {
                    cell.textLabel.text = @"Bank code:";
                }
                break;
        }
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
	return cell;
}

@end