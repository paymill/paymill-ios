//
//  PMDebitView.m
//  VoucherMill
//
//  Created by gabi on 2/24/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMPaymentView.h"

/**************************************/
#pragma mark - PMStyle Implementation
/**************************************/
@implementation PMStyle : NSObject

@end

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMPaymentView ()

@property (nonatomic, strong) UIToolbar *keyBar;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMPaymentView

/**************************************/
#pragma mark - Class Method
/**************************************/
+ (id)debitView
{
    NSAssert(0, @"This is a virtual method. Override me!!!");
    
    return nil;
}

/**************************************/
#pragma mark - View Lifecycle Methods
/**************************************/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self createKeyBoardToolbar];
}


/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)createKeyBoardToolbar
{
	//Create Prev/Next+Done tab bar to keyboard
    self.keyBar = [[UIToolbar alloc] init];
    [self.keyBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.keyBar sizeToFit];
	
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:kPMStringPrevious, kPMStringNext, nil]];
    [segControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segControl.selectedSegmentIndex = -1;
    [segControl addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventValueChanged];
	
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    
    NSArray *itemArray = [NSArray arrayWithObjects:segButton, flexButton, doneButton, nil];
	
    [self.keyBar setItems:itemArray];
}

/**************************************/
#pragma mark - Virtual Methods
/**************************************/
- (void)customizeTextField:(PMTextField*)textField
{
    textField.inputFieldBorderWidth  = self.style.inputFieldBorderWidth;
    textField.inputFieldCornerRadius = self.style.inputFieldCornerRadius;
    
    textField.inputFieldTextColor = self.style.inputFieldTextColor;
    textField.inputFieldBackgroundColor = self.style.inputFieldBackgroundColor;
    textField.inputFieldBorderColor = self.style.inputFieldBorderColor;
    textField.inputFieldConfirmColor = self.style.inputFieldConfirmColor;
    textField.inputFieldNonConfirmColor = self.style.inputFieldNonConfirmColor;
    textField.inputFieldWrongColor = self.style.inputFieldWrongColor;
    
    [textField setInputAccessoryView:self.keyBar];
}

- (void)customizeLabel:(UILabel *)label
{
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.style.inputFieldTitleColor;
}

- (void)setTextFieldDefaultStyle:(UITextField*)textField
{
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setInputAccessoryView:self.keyBar];
}

- (void)setStyle:(PMStyle *)style
{
    _style = style;
}

- (CGSize)viewContentSize
{
    NSAssert(0, @"This is a virtual method. Override me!!!");
    
    return CGSizeMake(0,0);
}

- (void)clearData
{
    NSAssert(0, @"This is a virtual method. Override me!!!");
}

- (void)updateData
{
    NSAssert(0, @"This is a virtual method. Override me!!!");
}

- (void)setTextFieldsDelegate:(id<UITextFieldDelegate>)delegate
{
    NSAssert(0, @"This is a virtual method. Override me!!!");
}

- (void)setUIEnabled:(BOOL)enabled
{
    NSAssert(0, @"This is a virtual method. Override me!!!");
}

/****************************************/
#pragma mark - UISegmentedControl Action
/****************************************/
- (void)segSelected:(UISegmentedControl*)segmentedCtrl
{
    if ( nil != self.activeTextField ) {
        int newTag = (int)self.activeTextField.tag;
        
        if( [segmentedCtrl selectedSegmentIndex] ) {
            newTag += 1;
        }
        else {
            if ( newTag > 0 ) {
                newTag -= 1;
            }
        }
        
        PMTextField* textField = (PMTextField*)[self viewWithTag:newTag];
		
        if ( [textField isKindOfClass:[PMTextField class]] ) {
            self.activeTextField = textField;
            [self.activeTextField becomeFirstResponder];
        }
        else {
            [self resignKeyboard];
        }
    }
    
    segmentedCtrl.selectedSegmentIndex = -1;
}

/**************************************/
#pragma mark - UIBarButtonItem Actions
/**************************************/
- (void)resignKeyboard
{
    [self.activeTextField resignFirstResponder];
}

/*********************************************************************/
#pragma mark - PMPaymentDataValidatorUIRepresentationDelegate Methods
/*********************************************************************/
- (void)paymentDataValidator:(PMPaymentDataValidator *)paymentDataValidator didChangeActiveTextField:(UITextField *)textField
{
    self.activeTextField = textField;
}

@end
