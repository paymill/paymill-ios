//
//  PMTextField.m
//  VoucherMill
//
//  Created by gabi on 2/24/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMTextField.h"
#import <QuartzCore/QuartzCore.h>

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMTextField

/**************************************/
#pragma mark - Init
/**************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( nil != self ) {
        [self defaultInitialization];
    }
    
    return self;
}

/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)defaultInitialization
{
    self.textAlignment            = NSTextAlignmentLeft;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.adjustsFontSizeToFitWidth = YES;
    
    self.textColor       = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    
    self.borderStyle            = UITextBorderStyleRoundedRect;
    
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType     = UITextAutocorrectionTypeNo;
    self.clearButtonMode        = UITextFieldViewModeNever;
}

/**************************************/
#pragma mark - Setters
/**************************************/
- (void)setInputBorderColor:(UIColor *)inputBorderColor
{
    self.layer.borderColor = inputBorderColor.CGColor;
}

- (void)setInputTextAlignment:(NSTextAlignment)inputTextAlignment
{
    self.textAlignment = inputTextAlignment;
}

- (void)setInputContentVerticalAlignment:(UIControlContentVerticalAlignment)inputContentVerticalAlignment
{
    self.contentVerticalAlignment = inputContentVerticalAlignment;
}

- (void)setInputFieldTextColor:(UIColor *)inputFieldTextColor
{
    self.textColor = inputFieldTextColor;
}

- (void)setInputFieldBackgroundColor:(UIColor *)inputFieldBackgroundColor
{
    self.backgroundColor = inputFieldBackgroundColor;
}

- (void)setInputFieldBorderStyle:(UITextBorderStyle)inputFieldBorderStyle
{
    self.borderStyle = inputFieldBorderStyle;
}

- (void)setInputFieldBorderColor:(UIColor *)inputFieldBorderColor
{
    self.layer.borderColor = inputFieldBorderColor.CGColor;
}

- (void)setInputFieldBorderWidth:(CGFloat)inputFieldBorderWidth
{
    self.layer.borderWidth = inputFieldBorderWidth;
}

- (void)setInputFieldCornerRadius:(CGFloat)inputFieldCornerRadius
{
    self.layer.cornerRadius = inputFieldCornerRadius;
}

- (void)setInputFieldAutocapitalizationType:(UITextAutocapitalizationType)inputFieldAutocapitalizationType
{
    self.autocapitalizationType = inputFieldAutocapitalizationType;
}

- (void)setInputFieldAutocorrectionType:(UITextAutocorrectionType)inputFieldAutocorrectionType
{
    self.autocorrectionType = inputFieldAutocorrectionType;
}

- (void)setInputFieldClearButtonMode:(UITextFieldViewMode)inputFieldClearButtonMode
{
    self.clearButtonMode = inputFieldClearButtonMode;
}

@end
