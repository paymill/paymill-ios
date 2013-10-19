//
//  PMBuyChildCustomCell.h
//  VoucherMill
//
//  Created by Oleg Ivanov on 8/8/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMBuyChildCustomCellDelegate;

@interface PMBuyChildCustomCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *customValue;
@property (nonatomic, strong) NSString *customValueLabelTitle;
@property (nonatomic, weak) NSObject <PMBuyChildCustomCellDelegate>* delegate;

@end

@protocol PMBuyChildCustomCellDelegate <NSObject>

@optional

- (void)buyChildCustomCell:(PMBuyChildCustomCell*)buyChildCustomCell
     doneButtonWasSelected:(UIBarButtonItem*)button;

@end