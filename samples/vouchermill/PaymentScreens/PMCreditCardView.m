//
//  PMDebitCardView.m
//  VoucherMill
//
//  Created by gabi on 2/23/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMCreditCardView.h"
#import "PMTextField.h"

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMCreditCardView ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (weak, nonatomic) IBOutlet UILabel *accountHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *expDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cvcLabel;

@property (weak, nonatomic) IBOutlet PMTextField *cvcTextField;
@property (weak, nonatomic) IBOutlet PMTextField *expDateTextField;
@property (weak, nonatomic) IBOutlet PMTextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet PMTextField *accountHolderTextField;

@property (nonatomic, retain) NSArray* pickerMonthArray;
@property (nonatomic, retain) NSArray* pickerYearArray;
@property (nonatomic, retain) UIPickerView* expPickerView;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMCreditCardView

/**************************************/
#pragma mark - Class Methods
/**************************************/
+ (id)creditCardView
{
    PMCreditCardView* creditCardView = [[[NSBundle mainBundle] loadNibNamed:@"PMCreditCardView" owner:nil options:nil] lastObject];
    
    if ([creditCardView isKindOfClass:[PMCreditCardView class]]) {
        return creditCardView;
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
    
    //Months must be in 2 digit [MM] format mandatory!
	self.pickerMonthArray = [NSArray arrayWithObjects: @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
	self.pickerYearArray = [NSArray arrayWithObjects: @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", nil];
    
    [self configureView];
    
    if ( nil != self.style ) {
        [self customizeControls];
    }
    else {
        [self setDefaultStyle];
    }
}

/**************************************/
#pragma mark - UIBarButtonItem Actions
/**************************************/
- (void)resignKeyboard
{
    if( self.activeTextField.tag == PMTextFieldTypeExpDate ) {
        self.expDateTextField.text = [NSString stringWithFormat:@"%@/%@",
                                      [self.pickerMonthArray objectAtIndex:[self.expPickerView selectedRowInComponent:0]],
                                      [self.pickerYearArray objectAtIndex:[self.expPickerView selectedRowInComponent:1]]];
    }
    
    [super resignKeyboard];
}

/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)configureView
{
    self.cardImageView.image = [UIImage imageNamed:@"placeholder"];
    
    self.accountHolderTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.cardNumberTextField.keyboardType    = UIKeyboardTypeNumberPad;
    self.expDateTextField.keyboardType       = UIKeyboardTypeNumberPad;
    self.cvcTextField.keyboardType           = UIKeyboardTypeNumberPad;
    
    self.accountHolderTextField.tag = PMTextFieldTypeCardAccountHolder;
    self.expDateTextField.tag       = PMTextFieldTypeExpDate;
    self.cardNumberTextField.tag    = PMTextFieldTypeCardNumber;
    self.cvcTextField.tag           = PMTextFieldTypeCVC;
    
    self.expPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
	self.expPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
	self.expPickerView.showsSelectionIndicator = YES;	// note this is default to NO
    
    self.expPickerView.dataSource   = self;
    self.expPickerView.delegate     = self;
    
    self.expDateTextField.inputView = self.expPickerView;
}

- (void)customizeControls
{
    [self customizeTextField:self.accountHolderTextField];
    [self customizeTextField:self.expDateTextField];
    [self customizeTextField:self.cardNumberTextField];
    [self customizeTextField:self.cvcTextField];
    
    [self customizeLabel:self.accountHolderLabel];
    [self customizeLabel:self.cardNumberLabel];
    [self customizeLabel:self.expDateLabel];
    [self customizeLabel:self.cvcLabel];
}

- (void)setDefaultStyle
{
    [self setTextFieldDefaultStyle:self.accountHolderTextField];
    [self setTextFieldDefaultStyle:self.expDateTextField];
    [self setTextFieldDefaultStyle:self.cardNumberTextField];
    [self setTextFieldDefaultStyle:self.cvcTextField];
}


/**************************************/
#pragma mark - Virtual Methods
/**************************************/
- (void)setStyle:(PMStyle *)style
{
    [super setStyle:style];
    
    [self customizeControls];
}

- (void)setTextFieldsDelegate:(id<UITextFieldDelegate>)delegate
{
    self.accountHolderTextField.delegate = delegate;
    self.cardNumberTextField.delegate = delegate;
    self.expDateTextField.delegate = delegate;
    self.cvcTextField.delegate = delegate;
}

- (void)clearData
{
    [self.accountHolderTextField setText:@""];
    [self.cardNumberTextField setText:@""];
    [self.expDateTextField setText:@""];
    [self.cvcTextField setText:@""];
}

- (void)updateData
{
    [self.accountHolderTextField setText:((PMPaymentDataValidator*)self.accountHolderTextField.delegate).accountHolderStr];
    [self.cardNumberTextField setText:((PMPaymentDataValidator*)self.accountHolderTextField.delegate).cardNumberStr];
    [self.expDateTextField setText:[(PMPaymentDataValidator*)self.accountHolderTextField.delegate dateString]];
    [self.cvcTextField setText:((PMPaymentDataValidator*)self.accountHolderTextField.delegate).cvcStr];
}

- (void)setUIEnabled:(BOOL)enabled
{
    self.accountHolderTextField.enabled = enabled;
    self.cardNumberTextField.enabled = enabled;
    self.expDateTextField.enabled = enabled;
    self.cvcTextField.enabled = enabled;
}

- (CGSize)viewContentSize
{
    return CGSizeMake(CGRectGetWidth(self.bounds),CGRectGetMaxY(self.cvcTextField.frame) + 20.0);
}

/**********************************************************************/
#pragma mark - PMPaymentDataValidatorUIRepresentationDelegate Methods
/**********************************************************************/
- (void)paymentDataValidator:(PMPaymentDataValidator *)paymentDataValidator didRecognizeCCNumberWithImageName:(NSString *)imageName
{
    self.cardImageView.image = [UIImage imageNamed:imageName];
}

- (void)paymentDataValidator:(PMPaymentDataValidator *)paymentDataValidator didCheckDateExpiration:(BOOL)isExpired
{
    self.expDateTextField.textColor = isExpired ? [UIColor redColor] : [UIColor darkTextColor];
}

/*********************************************/
#pragma mark - UIPickerViewDataSource methods
/*********************************************/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return (component) ? [self.pickerYearArray count] : [self.pickerMonthArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
	
	if (component) {
        returnStr = [self.pickerYearArray objectAtIndex:row];
	}
    else {
        returnStr = [self.pickerMonthArray objectAtIndex:row];
    }
	
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	
    return (screenRect.size.width-20) / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 40.0;
}

/*********************************************************************/
#pragma mark - PMPaymentDataValidatorUIRepresentationDelegate Methods
/*********************************************************************/
- (NSString*)paymentDataValidator:(PMPaymentDataValidator *)paymentDataValidator didChangeDateExpiratioTextFieldValue:(UITextField *)textField
{
    self.expDateTextField.text = [NSString stringWithFormat:@"%@/%@",
                                  [self.pickerMonthArray objectAtIndex:[self.expPickerView selectedRowInComponent:0]],
                                  [self.pickerYearArray objectAtIndex:[self.expPickerView selectedRowInComponent:1]]];
    
    return self.expDateTextField.text;
}

@end
