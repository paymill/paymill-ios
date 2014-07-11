//
//  PMTextField.h
//  VoucherMill
//
//  Created by gabi on 2/24/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMTextField : UITextField

/**
 inputFieldBackgroundColor
 */
@property (nonatomic, strong) UIColor *inputFieldBackgroundColor;
/**
 inputFieldTextColor
 */
@property (nonatomic, strong) UIColor *inputFieldTextColor;
/**
 inputFieldBorderColor
 */
@property (nonatomic, strong) UIColor *inputFieldBorderColor;
/**
 inputFieldConfirmColor
 */
@property (nonatomic, strong) UIColor *inputFieldConfirmColor;
/**
 inputFieldNonConfirmColor
 */
@property (nonatomic, strong) UIColor *inputFieldNonConfirmColor;
/**
 inputFieldWrongColor
 */
@property (nonatomic, strong) UIColor *inputFieldWrongColor;

/**
 inputFieldTextAlignment
 */
@property(nonatomic) NSTextAlignment inputFieldTextAlignment;

/**
 inputFieldContentVerticalAlignment
 */
@property(nonatomic) UIControlContentVerticalAlignment inputFieldContentVerticalAlignment;

/**
 inputFieldBorderStyle
 */
@property(nonatomic) UITextBorderStyle inputFieldBorderStyle;

/**
 inputAutocapitalizationType
 */
@property(nonatomic) UITextAutocapitalizationType inputFieldAutocapitalizationType;

/**
 inputFieldAutocorrectionType
 */
@property(nonatomic) UITextAutocorrectionType inputFieldAutocorrectionType;

/**
 inputFieldClearButtonMode
 */
@property(nonatomic) UITextFieldViewMode inputFieldClearButtonMode;

/**
 inputFieldCornerRadius
 */
@property(nonatomic) CGFloat inputFieldCornerRadius;

/**
 inputFieldBorderWidth
 */
@property(nonatomic) CGFloat inputFieldBorderWidth;


@end
