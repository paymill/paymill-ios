//
//  PMDirectDebitView.m
//  VoucherMill
//
//  Created by gabi on 2/23/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMDirectDebitView.h"
#import "PMTextField.h"

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMDirectDebitView ()

@property (weak, nonatomic) IBOutlet PMTextField *accountHolderTextField;
@property (weak, nonatomic) IBOutlet PMTextField *ibanTextField;
@property (weak, nonatomic) IBOutlet PMTextField *bicTextField;

@property (weak, nonatomic) IBOutlet UILabel *accountHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibanLabel;
@property (weak, nonatomic) IBOutlet UILabel *bicLabel;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMDirectDebitView

/**************************************/
#pragma mark - Class methods
/**************************************/
+ (id)directDebitView
{
    PMDirectDebitView* directDebitView = [[[NSBundle mainBundle] loadNibNamed:@"PMDirectDebitView" owner:nil options:nil] lastObject];
    
    if ([directDebitView isKindOfClass:[PMDirectDebitView class]]) {
        return directDebitView;
    }
    else {
        return nil;
    }
}

/**************************************/
#pragma mark - View Lifecycle Methods
/**************************************/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureView];
    
    if ( nil != self.style ) {
        [self customizeControls];
    }
    else {
        [self setDefaultStyle];
    }
}

/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)customizeControls
{
    [self customizeTextField:self.accountHolderTextField];
    [self customizeTextField:self.ibanTextField];
    [self customizeTextField:self.bicTextField];
    
    [self customizeLabel:self.accountHolderLabel];
    [self customizeLabel:self.ibanLabel];
    [self customizeLabel:self.bicLabel];
}

- (void)configureView
{
    self.accountHolderTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.ibanTextField.keyboardType          = UIKeyboardTypeNamePhonePad;
    self.bicTextField.keyboardType           = UIKeyboardTypeNamePhonePad;
    
    self.accountHolderTextField.tag = PMTextFieldTypeAccountHolder;
    self.ibanTextField.tag          = PMTextFieldTypeIBANNumber;
    self.bicTextField.tag           = PMTextFieldTypeBIC;
}

/**************************************/
#pragma mark - Virtual Methods
/**************************************/
- (void)setTextFieldsDelegate:(id<UITextFieldDelegate>)delegate
{
    self.accountHolderTextField.delegate = delegate;
    self.ibanTextField.delegate = delegate;
    self.bicTextField.delegate = delegate;
}

- (void)setDefaultStyle
{
    [self setTextFieldDefaultStyle:self.accountHolderTextField];
    [self setTextFieldDefaultStyle:self.ibanTextField];
    [self setTextFieldDefaultStyle:self.bicTextField];
}

- (void)setStyle:(PMStyle *)style
{
    [super setStyle:style];
    
    [self customizeControls];
}

- (void)clearData
{
    [self.accountHolderTextField setText:@""];
    [self.ibanTextField setText:@""];
    [self.bicTextField setText:@""];
}

- (void)setUIEnabled:(BOOL)enabled
{
    self.accountHolderTextField.enabled = enabled;
    self.bicTextField.enabled = enabled;
    self.ibanTextField.enabled = enabled;
}

- (CGSize)viewContentSize
{
    return CGSizeMake(CGRectGetWidth(self.bounds),CGRectGetMaxY(self.bicTextField.frame) + 20.0);
}

- (void)updateData
{
    [self.accountHolderTextField setText:((PMPaymentDataValidator*)self.accountHolderTextField.delegate).accountHolderStr];
    [self.ibanTextField setText:((PMPaymentDataValidator*)self.accountHolderTextField.delegate).ibanStr];
    [self.bicTextField setText:((PMPaymentDataValidator*)self.accountHolderTextField.delegate).bicStr];
}

@end
