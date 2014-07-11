//
//  PMPaymentMethodsListCell.m
//  VoucherMill
//
//  Created by gabi on 3/14/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMPaymentMethodsListCell.h"
/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMPaymentMethodsListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMPaymentMethodsListCell

/**************************************/
#pragma mark - View Lifecycle Methods
/**************************************/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logoImgView.image = self.logoImage;
    self.cardNumberLabel.text = self.numberStr;
}

@end
