//
//  PMBuyDetailsViewController.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/15/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMBuyDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PMBuyDetailsErrorMessageCell.h"
#define kLabelFontSize 14
#define darkOrangeColor [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0]
#define lightOrangeColor [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0]

@interface PMBuyDetailsViewController ()
@property (nonatomic, strong) NSString *detailLabelTxt;
@end

@implementation PMBuyDetailsViewController

@synthesize buyError, buyVoucher, detailsTable, detailsList, resultLabel, detailLabelTxt, token;

-(PMVoucher*)buyVoucher
{
	if(!buyVoucher){
		buyVoucher = [[PMVoucher alloc] init];
	}
	return buyVoucher;
}

- (void)viewDidLoad
{
    NSMutableArray *arrayOfSections;
    [super viewDidLoad];
    [self setTitle:@"Voucher Details"];
	
	[detailsTable setBackgroundView:nil];
	
    if (buyError != nil) {
		
		switch (buyError.type) {
			case 0:
				detailLabelTxt = @"WRONG_PARMETERS";
				break;
			case 1:
				detailLabelTxt = @"HTTP_CONNECTION";
				break;
			case 2:
				detailLabelTxt = @"API";
				break;
			case 3:
				detailLabelTxt = @"NOT_INIT";
				break;
			case 4:
				detailLabelTxt = @"INTERNAL";
				break;
			default:
				break;
		}
		
        [resultLabel setBackgroundColor:[UIColor redColor]];
        [resultLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        resultLabel.lineBreakMode = NSLineBreakByWordWrapping;
        resultLabel.numberOfLines = 0;
        [resultLabel setText:@"An error occured while trying to process the transaction!"];
        [resultLabel setTextColor:[UIColor whiteColor]];
        [resultLabel.layer setMasksToBounds:YES];
        [resultLabel.layer setBorderWidth:0.0f];
        [resultLabel.layer setCornerRadius:10.0f];
		
    } else if(buyVoucher || token) {
		
		[detailsTable setBackgroundColor:[UIColor clearColor]];
		UIColor *color = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
		[detailsTable setSeparatorColor:color];
		
		[resultLabel setBackgroundColor:[UIColor greenColor]];
        [resultLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [resultLabel setText:@"Payment successful!"];
        [resultLabel setTextColor:[UIColor whiteColor]];
        [resultLabel.layer setMasksToBounds:YES];
        [resultLabel.layer setBorderWidth:0.0f];
        [resultLabel.layer setCornerRadius:10.0f];
		
		if(token) {
			[resultLabel setText:@"Secure Payment Token Generated!"];
		}
		
		else if(buyVoucher) {
		
			NSString *amountCurrency = [NSString stringWithFormat:@"%@%@", buyVoucher.voucherAmount, buyVoucher.voucherCurrency];
			NSArray *firstSection = [NSArray arrayWithObjects:amountCurrency, buyVoucher.voucherCreationDate, buyVoucher.voucherDescrpition, buyVoucher.voucherStatus, nil];
			NSArray *secondSection = [NSArray arrayWithObjects:buyVoucher.voucherCreditCardNumber, buyVoucher.voucherCreditCardType, nil];
			NSArray *thirdSection = [NSArray arrayWithObjects:buyVoucher.voucherAccount, buyVoucher.voucherBankCode, nil];
			if (buyVoucher.isCreditCard) {
				arrayOfSections = [[NSMutableArray alloc] initWithObjects:firstSection, secondSection, nil];
			} else {
				arrayOfSections = [[NSMutableArray alloc] initWithObjects:firstSection, thirdSection, nil];
			}
			[self setDetailsList:arrayOfSections];
			
		}
		
		
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (buyError !=nil) {
        return 1;
    } else {
        return [self.detailsList count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (buyError !=nil) {
        return 2;
    } else {
    NSArray *sectionContents = [self.detailsList objectAtIndex:section];
    return [sectionContents count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (buyError != nil) {
        switch (indexPath.row) {
            case 0:
                return 44.0f;
                break;
            case 1:
                return [PMBuyDetailsErrorMessageCell labelSizeForText:buyError.message
                                                           maxWidth:123].height + 10.0;
                break;
            default:
                return 44.0f;
                break;
        }
    } else {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"DetailsCell";
    
    UITableViewCell *cell;
    PMBuyDetailsErrorMessageCell *firstCell;
    if (buyError != nil) {
        switch (indexPath.row) {
            case 0:
                cell = [detailsTable dequeueReusableCellWithIdentifier:@"DetailsCell"
                                                                 forIndexPath:indexPath];
                cell.backgroundColor = lightOrangeColor;
                cell.textLabel.text = @"Type";
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.detailTextLabel.text = detailLabelTxt;
                cell.detailTextLabel.textColor = darkOrangeColor;
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                break;
            case 1:
                firstCell = [detailsTable dequeueReusableCellWithIdentifier:@"ErrorTextCell" forIndexPath:indexPath];
                [firstCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                firstCell.backgroundColor = lightOrangeColor;
                firstCell.titleText = @"Message";
                firstCell.cellText = buyError.message;
                cell = firstCell;
                break;
            default:
                break;
        }
        return cell;
    } else {
            cell = [detailsTable dequeueReusableCellWithIdentifier:@"DetailsCell"
                                                  forIndexPath:indexPath];
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
                                if (buyVoucher.isCreditCard) {
                                    cell.textLabel.text = @"Credit Card:";
                                } else {
                                    cell.textLabel.text = @"Account:";
                                }
                                break;
                            case 1:
                                if (buyVoucher.isCreditCard) {
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
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
