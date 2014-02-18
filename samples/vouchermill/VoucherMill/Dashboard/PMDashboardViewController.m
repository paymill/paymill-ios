//
//  PMDashboardViewController.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/8/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMDashboardViewController.h"
#import "PMDashboardViewCell.h"
#import "PMListViewController.h"
#import "PMBuyContainerController.h"
#import "PMAppDelegate.h"
#import <PayMillSDK/PMSDK.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSManagedObjectContext.h>
#import <CoreData/NSManagedObjectModel.h>
#import "PMVoucher.h"
#import "PMPaymentViewController.h"
#import "Constants.h"
#import "PMVoucherParams.h"
#import "PMVoucherUtils.h"
#import "PMDataBaseManager.h"
#import "OfflineVoucher.h"

@interface PMDashboardViewController ()
@property (nonatomic, strong) NSMutableArray *voucherList;
@property (nonatomic, strong) NSMutableArray *transList;
@property (nonatomic, strong) NSArray *boardIcons;
@property (nonatomic, strong) NSArray *boardIconsHighlighted;
@property (nonatomic, strong) NSArray *boardLabels;
@property (nonatomic) NSInteger dashboardOrientation;       
@end

@implementation PMDashboardViewController
@synthesize transList, voucherList, boardIcons, boardLabels, dashboardOrientation, boardIconsHighlighted;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Dashboard";
	// Do any additional setup after loading the view.
    boardIcons = [[NSArray alloc] initWithObjects:@"buy_voucher", @"online_vouchers", @"offline_vouchers", @"not_consumed",nil];
    boardIconsHighlighted = [[NSArray alloc] initWithObjects:@"buy_voucher_pressed", @"online_vouchers_pressed", @"offline_vouchers_pressed", @"not_consumed_pressed",nil];
    boardLabels = [[NSArray alloc] initWithObjects:@"Buy voucher", @"Online Vouchers", @"Offline Vouchers", @"Not Consumed", nil];
    voucherList = [[NSMutableArray alloc] init];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.dashboardOrientation = toInterfaceOrientation;
    [self.collectionView.collectionViewLayout invalidateLayout];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.dashboardOrientation = self.interfaceOrientation;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.boardIcons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DashboardCell";
    PMDashboardViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:[boardIcons objectAtIndex:indexPath.item]];
    cell.imageView.highlightedImage = [UIImage imageNamed:[boardIconsHighlighted objectAtIndex:indexPath.item]];
    cell.cellLabel.text = [boardLabels objectAtIndex:indexPath.item];
    cell.cellLabel.textColor = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    cell.cellLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [cell.cellLabel setAdjustsFontSizeToFitWidth:YES];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
            [self performSegueWithIdentifier:kBUYVOUCHER sender:collectionView];
            break;
        case 1:
			[self getTransactionsList];
            break;
        case 2:
			[self getOfflineList];
            break;
        case 3:
			[self getNotConsumedList];
            //[self performSegueWithIdentifier:kNOTCONSUMED sender:collectionView];
            break;
    }
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *photo = [UIImage imageNamed:[boardIcons objectAtIndex:indexPath.item]];
    CGSize retval = photo.size.width > 0 ? photo.size : CGSizeMake(140, 140);
    retval.height += 20;
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (dashboardOrientation == 1 || dashboardOrientation == 2) {
        if (self.view.frame.size.height == 416) {
            return UIEdgeInsetsMake(45, 10, 0, 10);
        } else {
            return UIEdgeInsetsMake(105, 10, 0, 10);
        }
    } else if (dashboardOrientation == 3 || dashboardOrientation == 4) {
        return UIEdgeInsetsMake(10, self.view.frame.size.width * 0.17, 0, self.view.frame.size.width * 0.17);
    }
    return UIEdgeInsetsZero;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
	if([segue.identifier isEqualToString:kONLINEVOUCHERS] || [segue.identifier isEqualToString:kNOTCONSUMED] || [segue.identifier isEqualToString:kOFFLINEVOUCHERS]) {
		
		PMListViewController *destViewController = segue.destinationViewController;
		destViewController.items = voucherList;
		if([segue.identifier isEqualToString:kONLINEVOUCHERS]) {
			destViewController.segments = [NSMutableArray arrayWithObjects:kBOUGHT, kRESERVED, nil];
			destViewController.voucherState = Online;
		}   else if ([segue.identifier isEqualToString:kNOTCONSUMED]) {
            destViewController.segments = [NSMutableArray arrayWithObjects:kBOUGHT, nil];
            destViewController.voucherState = NotConsumed;
		}   else if ([segue.identifier isEqualToString:kOFFLINEVOUCHERS]) {
            destViewController.segments = [NSMutableArray arrayWithObjects:kBOUGHT, nil];
            destViewController.voucherState = Offline;
		}
		
	}
    else if ([segue.identifier isEqualToString:kBUYVOUCHER]) {
		PMVoucherParams *params = [PMVoucherParams instance];
		//we set pm action to transaction as default one
		params.action = TRANSACTION;
		//PMBuyContainerController *destViewController = segue.destinationViewController;
    }

}

- (void)getTransactionsList
{
    [PMManager getTransactionsList:^(NSArray *transactions) {
		[voucherList removeAllObjects];
        transList = [NSMutableArray arrayWithArray:transactions];
        
	   	for (PMTransaction *transaction in transactions) {
			PMVoucher *voucher = [PMVoucherUtils voucherFromPMObject:transaction];
			voucher.voucherType = Online;
			[voucherList addObject:voucher];
		}
		[self performSegueWithIdentifier:kONLINEVOUCHERS sender:self];
        
    } failure:^(NSError *error) {
		[PMVoucherUtils showErrorAlertWithTitle:@"Get transactions failure:" errorType:error.code errorMessage:error.localizedDescription];
    }];
}

-(void)getOfflineList {
	[voucherList removeAllObjects];
	NSArray* offlineList = [[PMDataBaseManager instance] allOfflineVouchersWithCompletionHandler:^(NSError *err) {
		if(err) {
			[PMVoucherUtils showErrorAlertWithTitle:@"Error reading offline vouchers" errorType:INTERNAL errorMessage:err.description];
		}
	}];
	
	for (OfflineVoucher* offlineVoucher in offlineList) {
		 PMVoucher *voucher = [PMVoucherUtils voucherFromOfflineVoucher:offlineVoucher];
		 voucher.voucherType = Offline;
		[voucherList addObject:voucher];
	}
	
	[self performSegueWithIdentifier:kOFFLINEVOUCHERS sender:self];
}

-(void)getNotConsumedList
{
    [PMManager getNonConsumedTransactionsList:^(NSArray *notConsumedTransactions) {
        [voucherList removeAllObjects];
		transList = [NSMutableArray arrayWithArray:notConsumedTransactions];
        
	   	for (PMTransaction *transaction in notConsumedTransactions) {
			PMVoucher *voucher = [PMVoucherUtils voucherFromPMObject:transaction];
			voucher.voucherType = NotConsumed;
			[voucherList addObject:voucher];
		}
		[self performSegueWithIdentifier:kNOTCONSUMED sender:self];
        
    } failure:^(NSError *error) {
		[PMVoucherUtils showErrorAlertWithTitle:@"Get transactions failure:" errorType:error.code errorMessage:error.localizedDescription];
    }];
}

@end
