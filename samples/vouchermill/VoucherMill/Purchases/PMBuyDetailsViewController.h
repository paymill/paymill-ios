//
//  PMBuyDetailsViewController.h
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/15/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMVoucher.h"
#import <PayMillSDK/PMSDK.h>

@interface PMBuyDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PMError *buyError;
@property (nonatomic, strong) PMVoucher *buyVoucher;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, weak) IBOutlet UITableView *detailsTable;
@property (strong, nonatomic) NSMutableArray *detailsList;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)donePressed:(UIBarButtonItem *)sender;

@end
