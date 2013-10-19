//
//  PMBuyDetailsErrorMessageCell.h
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/15/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMBuyDetailsErrorMessageCell : UITableViewCell

@property (nonatomic, strong) NSString* cellText;
@property (nonatomic, strong) NSString* titleText;
@property (nonatomic, strong) UIFont* font;


+ (CGSize)labelSizeForText:(NSString*)text
                  maxWidth:(CGFloat)width;
@end
