//
//  PMDebitView.h
//  VoucherMill
//
//  Created by gabi on 2/24/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMTextField.h"
#import "PMPaymentDataValidator.h"

/**************************************/
#pragma mark - PMStyle interface
/**************************************/

/**
 This class is intended for set style properties to the payment screen.
 */
@interface PMStyle : NSObject
/**
 backgroundColor
 */
@property (nonatomic) UIColor *backgroundColor;
/**
 navbarColor
 */
@property (nonatomic) UIColor *navbarColor;
/**
 inputFieldBackgroundColor
 */
@property (nonatomic) UIColor *inputFieldBackgroundColor;
/**
 inputFieldTextColor
 */
@property (nonatomic) UIColor *inputFieldTextColor;
/**
 inputFieldTitleColor
 */
@property (nonatomic) UIColor *inputFieldTitleColor;
/**
 inputFieldBorderColor
 */
@property (nonatomic) UIColor *inputFieldBorderColor;
/**
 inputFieldConfirmColor
 */
@property (nonatomic) UIColor *inputFieldConfirmColor;
/**
 inputFieldNonConfirmColor
 */
@property (nonatomic) UIColor *inputFieldNonConfirmColor;
/**
 inputFieldWrongColor
 */
@property (nonatomic) UIColor *inputFieldWrongColor;
/**
 buttonBackgroundColor
 */
@property (nonatomic) UIColor *buttonBackgroundColor;
/**
 buttonTitleColor
 */
@property (nonatomic) UIColor *buttonTitleColor;
/**
 segmentColor
 */
@property (nonatomic) UIColor *segmentColor;
/**
 modalTransitonStyle
 */
@property (nonatomic) UIModalTransitionStyle modalTransitonStyle;
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

/**************************************/
#pragma mark - PMDebitView interface
/**************************************/
@interface PMPaymentView : UIView <PMPaymentDataValidatorUIRepresentationDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField* activeTextField;
@property (nonatomic, strong) PMStyle* style;

- (void)setTextFieldsDelegate:(id<UITextFieldDelegate>)delegate;
- (void)customizeTextField:(PMTextField*)textField;
- (void)customizeLabel:(UILabel*)label;
- (void)setTextFieldDefaultStyle:(UITextField*)textField;
- (void)resignKeyboard;
- (void)clearData;
- (void)updateData;
- (void)setUIEnabled:(BOOL)enabled;
- (CGSize)viewContentSize;

@end
