//
//  PMLoginViewController.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/5/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMLoginTextFieldCell.h"
#import "PMLoginSegmentedControlCell.h"

@interface PMLoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PMLoginTextFieldCellDelegate>

@end