//
//  PMListViewController.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/13/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PMVoucher.h"
#import "DetailsViewController.h"

@interface PMListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PMDetailsViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *boughtItems;
@property (nonatomic, strong) NSMutableArray *reservedItems;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSMutableArray *segments;
@property (nonatomic) VoucherStateType voucherState;

@end
