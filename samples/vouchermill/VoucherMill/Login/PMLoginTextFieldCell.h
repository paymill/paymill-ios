//
//  PMLoginTextFieidCell.h
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/3/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PMLoginTextFieldCellDelegate

-(void)loginText:(NSString *)text;

@end

@interface PMLoginTextFieldCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong) id<PMLoginTextFieldCellDelegate> delegate;
@end
