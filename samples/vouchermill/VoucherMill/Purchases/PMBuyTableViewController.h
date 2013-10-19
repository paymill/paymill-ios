//
//  PMBuyTableViewController.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/5/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBuyChildCustomCell.h"
#import "PMPaymentViewController.h"
#import "PMBuyChildCustomCell.h"

@interface PMBuyTableViewController : UITableViewController <UITextFieldDelegate, PMBuyChildCustomCellDelegate>

@property (nonatomic) NSUInteger index;
@property (nonatomic) PMPaymentType PMAction;
@property (nonatomic) BOOL isVisible;

@end
