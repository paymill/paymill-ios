//
//  PMPaymentViewController.m
//  VoucherMill
//
//  Created by PayMill on 3/26/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMPaymentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PMCreditCardTypeParser.h"
#define kPickerAnimationDuration 0.40

/**
 On success completion of the payment operation block
 */
static OnCompletionSuccess OnSuccessBlock;
/**
 On failure completion of the payment operation block
 */
static OnCompletionFailure OnFailureBlock;

@interface PMSettings ()
//prefill data
@property (nonatomic, strong) NSString *accountHolder;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expiryMonth;
@property (nonatomic, strong) NSString *expiryYear;
@property (nonatomic, strong) NSString *verification;
@end
@implementation PMSettings : NSObject
@synthesize paymentType, isTestMode, consumable, accountHolder, cardNumber, cardTypes, directDebitCountry, expiryMonth, expiryYear, verification;

-(void)prefillCreditCardDataWithAccHolder:(NSString*)accHolder cardNumber:(NSString*)aCardNumber expiryMonth:(NSString*)anExpiryMonth expiryYear:(NSString*)anExpiryYear verification:(NSString *)aVerification
{
	self.accountHolder = accountHolder;
	self.cardNumber = aCardNumber;
	self.expiryMonth = anExpiryMonth;
	self.expiryYear  = anExpiryYear;
	self.verification = aVerification;
}
@end

@implementation PMStyle : NSObject
@synthesize backgroundColor, navbarColor, inputFieldTextColor, inputFieldBackgroundColor, inputFieldTitleColor, inputFieldBorderColor, inputFieldConfirmColor, inputFieldNonConfirmColor, inputFieldWrongColor, buttonBackgroundColor, buttonTitleColor, segmentColor, modalTransitonStyle;
@end

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMPaymentViewController ()

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *ddNameStr;
@property (nonatomic, strong) NSString *accountStr;
@property (nonatomic, strong) NSString *codeStr;
@property (nonatomic, strong) NSString *expMonthStr;
@property (nonatomic, strong) NSString *expYearStr;
@property (nonatomic, strong) NSString *ddAccountStr;
@property (nonatomic, strong) NSString *ddCodeStr;
@property (nonatomic, strong)UITextField *editedField;
@property (nonatomic, strong) UIActivityIndicatorView *progress;
@property (nonatomic) bool isDirectDebitSelected;
@property (nonatomic, strong) UIToolbar *keyBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIPickerView *expPickerView;
@property (nonatomic, strong) UIBarButtonItem *submitButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, retain) NSArray *pickerMonthArray;
@property (nonatomic, retain) NSArray *pickerYearArray;
@property (nonatomic, strong) PMCreditCardCheck *recognizedCC;
@property (nonatomic, strong) UIImageView *sectionCC;
@property (nonatomic, strong) PMStyle *style;
@property (nonatomic, strong) UITextField* activeTextField;
@property (nonatomic, strong) PMSettings *settings;
@property (nonatomic, strong) PMPaymentParams *paymentParams;
@property (nonatomic, strong) NSString *publicKey;
@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMPaymentViewController

@synthesize tableView;
@synthesize navigationBar;
@synthesize progress;
@synthesize paymentParams;
@synthesize publicKey, accountStr, cancelButton, codeStr, dataArray, ddAccountStr, ddCodeStr, definesPresentationContext, editedField, expMonthStr, expPickerView, expYearStr, isDirectDebitSelected, keyBar, modalPresentationStyle, modalTransitionStyle, modalViewController, nameStr, style, settings, recognizedCC, sectionCC, activeTextField, ddNameStr;


/**************************************/
#pragma mark - Initialization methods
/**************************************/

-(PMPaymentViewController *)initWithParams:(PMPaymentParams*)pmParams publicKey:(NSString *)pubKey settings:(PMSettings *)pmSettings style:(PMStyle *)pmStyle success:(void (^)(id))success failure:(void (^)(PMError *))failure
{
    self = [super init];
    if (self) {
        self.paymentParams = pmParams;
		self.publicKey = pubKey;
		self.settings = pmSettings;
		self.style = pmStyle;
		OnSuccessBlock = success;
		OnFailureBlock = failure;
    }
    return self;
}

-(void)loadView
{
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	self.view = view;
	
    //Uncomment to set default Paymill style:
    [self defaultStyle];
    
	[self createNavBar];
	[self createNavBarButtons];
    [self createTable];
	[self createPicker];
	[self createProgressIndicator];
	[self createKeyBoardToolbar];
}

-(void)createNavBar
{
    CGRect frame = CGRectMake(0.0,
                              0.0,
                              CGRectGetWidth(self.view.bounds),
                              44.0);
    
	UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:frame];
	bar.tintColor = style.navbarColor;
	bar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[bar setBarStyle:UIBarStyleBlackOpaque];
	[bar setItems:[NSArray arrayWithObject:self.navigationItem]];
	[self.view addSubview:bar];
	self.navigationBar = bar;
}

-(void)createTable
{	
    CGRect frame = CGRectMake(0.0,
                              CGRectGetMaxY(self.navigationBar.frame),
                              CGRectGetWidth(self.view.bounds),
                              CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationBar.bounds));
    

    tableView  = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, self.navigationBar.frame.size.height, 0.0)];
    
	//To set white background:
    if (style.backgroundColor)
    {
        UIColor* color = style.backgroundColor;
        NSString* version = [[UIDevice currentDevice] systemVersion];
        if([version floatValue] < 6.0) {
            self.tableView.backgroundColor = color;
        }
        else {        //workaround for background color in ver. 6.0
            self.tableView.backgroundView = nil;
            UIView* bv = [[UIView alloc] init];
            bv.backgroundColor = color;
            self.tableView.backgroundView = bv;
        }
    }
	
    self.tableView.separatorColor = [UIColor clearColor];
    
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
    
	[self.view addSubview:self.tableView];
}

-(void)createProgressIndicator
{
	progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    progress.hidden = YES;
    progress.frame = screenRect;
    
    [self.view addSubview:progress];
}

-(void)createNavBarButtons
{
	self.submitButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", @"")
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(submitAction:)];
    self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                         style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(cancelAction:)];

	
	self.navigationItem.rightBarButtonItem = self.submitButton;
    self.navigationItem.leftBarButtonItem  = self.cancelButton;
}

-(void)createKeyBoardToolbar
{
	//Create Prev/Next+Done tab bar to keyboard
    keyBar = [[UIToolbar alloc] init];
    [keyBar setBarStyle:UIBarStyleBlackTranslucent];
    [keyBar sizeToFit];
	
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    [segControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segControl.selectedSegmentIndex = -1;
    [segControl addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventValueChanged];
	
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    
    NSArray *itemArray = [NSArray arrayWithObjects:segButton, flexButton, doneButton, nil];
	
    [keyBar setItems:itemArray];
}

- (void)createPicker
{
    //Months must be in 2 digit [MM] format mandatory!
	self.pickerMonthArray = [NSArray arrayWithObjects: @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
	self.pickerYearArray = [NSArray arrayWithObjects: @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", nil];
    
	self.expPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    
	self.expPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
   
	self.expPickerView.showsSelectionIndicator = YES;	// note this is default to NO

	// this view controller is the data source and delegate
	self.expPickerView.delegate = self;
	self.expPickerView.dataSource = self;
	
	self.expPickerView.hidden = YES;
}



- (void)defaultStyle
{
	UIColor *mainColor = [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0];
	
	style = [[PMStyle alloc]init];
    style.backgroundColor = [UIColor whiteColor];
    style.navbarColor = [UIColor whiteColor];
    style.inputFieldTextColor = [UIColor darkTextColor];
    style.inputFieldBackgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    style.inputFieldTitleColor = mainColor;
    style.inputFieldBorderColor = [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0];
    style.inputFieldConfirmColor = [UIColor darkTextColor];
    style.inputFieldWrongColor = [UIColor redColor];
    style.buttonBackgroundColor = mainColor;
    style.buttonTitleColor = [UIColor whiteColor];
    style.segmentColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Uncomment to set default Paymill styling:
    //[self defaultStyle];
    
    [self registerForKeyboardNotifications];
    
    self.dataArray = [NSArray arrayWithObjects:\
                     [NSArray arrayWithObjects:NSLocalizedString(@"Card Number", @"Card Number"), NSLocalizedString(@"Security Code", @"Security Code"), nil], \
                     [NSArray arrayWithObjects:NSLocalizedString(@"Name", @"Name"), nil], \
                     [NSArray arrayWithObjects:NSLocalizedString(@"Month/Year", @"Month/Year"), nil], nil];
    
    [self addSegmentedControl];
	((PMCreditCardTypeParser *)[PMCreditCardTypeParser instance]).cardTypes = self.settings.cardTypes;
	
	//Copying pre-fill data from pm settings
	nameStr = settings.accountHolder;
	accountStr = settings.cardNumber;
	codeStr = settings.verification;
	expMonthStr = settings.expiryMonth;
	expYearStr = settings.expiryYear;
	
    [self.expPickerView selectRow:11 inComponent:0 animated:YES];
    [self.expPickerView selectRow:1 inComponent:1 animated:YES];
}

- (void)addSegmentedControl
{
    NSArray *segmentTextContent;
    
    if(settings.cardTypes.count > 0 && settings.directDebitCountry) {
        segmentTextContent = [NSArray arrayWithObjects:
                              NSLocalizedString(@"Credit Card", @""),
                              NSLocalizedString(@"Direct Debit", @""), nil];
    }
    else if (settings.directDebitCountry) {
        segmentTextContent = [NSArray arrayWithObjects: NSLocalizedString(@"Direct Debit", @""), nil];
    }
    else if (settings.cardTypes.count > 0) {
        segmentTextContent = [NSArray arrayWithObjects: NSLocalizedString(@"Credit Card",  @""), nil];
    }
    
    UIView* navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400, 44.0)];
    navTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.frame = CGRectMake(0.0, 7.0, 400, 30.0);
    
    UIBarMetrics barMetrics = UIBarMetricsDefault;    
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal barMetrics:barMetrics];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateSelected barMetrics:barMetrics];
    [segmentedControl setDividerImage:[UIImage imageNamed:@"divider_selected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:barMetrics];
    
    if(style.segmentColor) {
        UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, style.segmentColor, UITextAttributeTextColor,nil];
        [segmentedControl setTitleTextAttributes:attrs forState:UIControlStateNormal];
        
        [segmentedControl.layer setMasksToBounds:YES];
        [segmentedControl.layer setBorderWidth:2.0f];
        [segmentedControl.layer setBorderColor:style.inputFieldBorderColor.CGColor];
        [segmentedControl.layer setCornerRadius:6.0f];
    }
    
    [segmentedControl addTarget:self action:@selector(paymentTypeSegSelected:) forControlEvents:UIControlEventValueChanged];
    
    [navTitleView addSubview:segmentedControl];
    self.navigationItem.titleView = navTitleView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)showMessage:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:text
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (UITextField*)textFieldWithFrame:(CGRect)frame
{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    textField.delegate = self;
    
    textField.textAlignment            = NSTextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = style.inputFieldTextColor;
    
    if(style.inputFieldBackgroundColor)
        textField.backgroundColor = style.inputFieldBackgroundColor;
    
    if(style.inputFieldBorderColor) {
        textField.layer.borderColor = style.inputFieldBorderColor.CGColor;
        textField.layer.masksToBounds=YES;
        textField.layer.cornerRadius=8.0f;
        textField.layer.borderWidth= 2.0f;
    }
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setInputAccessoryView:keyBar];
    
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    textField.autocorrectionType     = UITextAutocorrectionTypeNo; // no auto correction support
    textField.clearButtonMode        = UITextFieldViewModeNever;
    
    return textField;
}

/*********************************************/
#pragma mark - UITableViewDataSource methods
/*********************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections depends of direct debit or credit card payment type
    return isDirectDebitSelected ? 3 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    if(isDirectDebitSelected)
    {
        switch (section)
        {
            case 0:
                sectionName = NSLocalizedString(@"Account Holder", @"Account Holder");
                break;
            case 1:
                sectionName = NSLocalizedString(@"Account Number", @"Account Number");
                break;
            case 2:
                sectionName = NSLocalizedString(@"Bank Code", @"Bank Code");
                break;
                
            default:
                sectionName = @"";
                break;
        }
    }
    else
    {
        switch (section)
        {
            case /*0*/1:
            {
                sectionName = NSLocalizedString(@"Card Number", @"Card Number");
                break;
            }
            case /*1*/0:
                sectionName = NSLocalizedString(@"Account Holder", @"Account Holder");
                break;
            case 2:
                sectionName = NSLocalizedString(@"Expiration Date", @"Expiration Date");
                break;
            case 3:
                sectionName = NSLocalizedString(@"CVV", @"CVV");
                break;
                
            default:
                sectionName = @"";
                break;
        }
    }
    return sectionName;
}

-(UIImageView *)sectionCC
{
	CGSize logoSize = {64, 40};
	
	if (!sectionCC) {
        sectionCC = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 2.0, logoSize.width, logoSize.height)];
		sectionCC.image = [UIImage imageNamed:@"placeholder"];
    }
	
	return sectionCC;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 30.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat offset = 10.0;
    
    UIView *customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                       0.0,
                                                                       self.tableView.bounds.size.width,
                                                                       30.0)];
    UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(offset,
                                                                     offset,
                                                                     self.tableView.frame.size.width - 2*offset,
                                                                     2*offset)];
    titleLabel.backgroundColor = [UIColor blueColor];
    titleLabel.text = [self tableView:self.tableView titleForHeaderInSection:section];
    
    if(style.inputFieldTitleColor) {
        titleLabel.textColor = style.inputFieldTitleColor;
	}
    else {
        return nil;
	}
    
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        UITextField* textField = [self textFieldWithFrame:CGRectMake(0.0,
                                                                     0.0,
                                                                     CGRectGetWidth(cell.contentView.bounds),
                                                                     CGRectGetHeight(cell.bounds))];
        [cell.contentView addSubview:textField];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UITextField *textField = [cell.contentView.subviews objectAtIndex:0];
    
    //Holder Name:
    if( [indexPath section] == 0 ) {
        textField.placeholder = isDirectDebitSelected ? NSLocalizedString(@"account holder", @"account holder") : NSLocalizedString(@"credit card holder", @"credit card holder");
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        
		if(!isDirectDebitSelected) {
			textField.text = nameStr;
		}
		else {
			textField.text = ddNameStr;
		}
			
		textField.tag = isDirectDebitSelected ? ACCOUNT_HOLDER : CARD_ACCOUNT_HOLDER ;
    }
    
    //Account Number / Credit Card Number
    if( [indexPath section] == 1 ) {        
        textField.placeholder = isDirectDebitSelected ? NSLocalizedString(@"account number", @"account number")
                                                      : NSLocalizedString(@"credit card number", @"credit card number");
        
		textField.keyboardType = UIKeyboardTypeNumberPad;
				
		if (isDirectDebitSelected) {
			cell.accessoryView = nil;
			textField.text = ddAccountStr;
		}
		else {
			
			recognizedCC = [[PMCreditCardTypeParser instance] checkExpression:accountStr];
			
			if(recognizedCC.result == VALID) {
				[self didRecognizeCCNumber:accountStr inTextField:textField];
				self.sectionCC.hidden = NO;
				cell.accessoryView = sectionCC;
			}
			else if(recognizedCC.result == INVALID) {
				textField.textColor = style.inputFieldWrongColor;
				self.sectionCC.hidden = NO;
				cell.accessoryView = sectionCC;
			}
			else if(recognizedCC.result == NOT_YET_KNOWN) {
				textField.textColor = style.inputFieldNonConfirmColor;
				self.sectionCC.hidden = NO;
				cell.accessoryView = sectionCC;
			}

			textField.text = [self stringByGrouping:accountStr By:recognizedCC];
			NSLog(@"CC text: %@",textField.text);
		}
		
		textField.tag = isDirectDebitSelected ? ACCOUNT_NUMBER : CARD_NUMBER;
	}
    // Bank Code / CVV
    if((isDirectDebitSelected && [indexPath section] == 2) || (!isDirectDebitSelected && [indexPath section] == 3)) {
        textField.placeholder = isDirectDebitSelected ? NSLocalizedString(@"bank code", @"bank code")
                                                      : NSLocalizedString(@"CVC", @"CVC");
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        if(!isDirectDebitSelected){
            textField.text = codeStr;
        }
		else if(isDirectDebitSelected) {
			textField.text = ddCodeStr;
		}

        textField.tag = isDirectDebitSelected ? BANK_CODE : CVV;
    }
    
    //Expiration Date - optional, only for credit cards
    if(!isDirectDebitSelected && [indexPath section] == 2) {
        textField.placeholder = NSLocalizedString( @"Select a month/year", @"Select a month/year");
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        if(expMonthStr && ![expMonthStr isEqualToString:@""]){
            textField.text = [NSString stringWithFormat:@"%@/%@", expMonthStr, expYearStr];
        }
		else {
			textField.text = @"";
		}
        textField.tag = EXP_DATE;
    }
	
            
    return cell;
}

/**************************************/
#pragma mark - UI helper methods
/**************************************/
- (UIView *)findFirstResponder:(UIView*)baseView
{
	if ([baseView isFirstResponder]) {
		return baseView;
	}
	
	for (UIView *subview in [baseView subviews]) {
		UIView *firstResponder = [self findFirstResponder:subview];
		if (nil != firstResponder) {
			return firstResponder;
		}
	}
	
	return nil;
}

- (void)didRecognizeCCNumber:(NSString *)ccnumberStr inTextField:(UITextField *)textField
{
    sectionCC.image = [UIImage imageNamed:recognizedCC.imageName];
	
	sectionCC.hidden = NO;
	
    textField.textColor = style.inputFieldNonConfirmColor;
    
    for (NSNumber *ln in recognizedCC.numLength)
    {
        if(ccnumberStr.length == ln.integerValue)
        {
            if([self luhnCheck:ccnumberStr]){
                textField.textColor = style.inputFieldConfirmColor;
			}
            else {
                textField.textColor = style.inputFieldWrongColor;
			}
            
            break;
        }
    }
}

/**************************************/
#pragma mark - Btn actions
/**************************************/
- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitAction:(id)sender
{
    //Update data from last edited text field
    [self textFieldDidEndEditing:editedField];
    
    //Input verification
    if(!self.inputVerification) {
        return;
    }
	
    PMError *error;
    
    //Create payment parameters
    PMPaymentParams *params = paymentParams;
    
    id paymentMethod;
    
    if(!error)
    {
 		if(isDirectDebitSelected) {
			paymentMethod = [PMFactory genNationalPaymentWithAccNumber:ddAccountStr accBank:ddCodeStr accHolder:nameStr accCountry:settings.directDebitCountry error:&error];
		}
		else {
			paymentMethod = [PMFactory genCardPaymentWithAccHolder:nameStr cardNumber:accountStr expiryMonth:expMonthStr expiryYear:[NSString stringWithFormat:@"20%@", expYearStr] verification:codeStr error:&error];
		}
                
        if(error)
        {
            [self showMessage:[NSString stringWithFormat: @"Create payment method error: %d", error.type] text:error.message];
            return;
        }
        
    }
    else
    {
        [self showMessage:@"Create payment parameters error: %d" text:error.message];
        return;
    }
    
    [progress startAnimating];
    
    switch (settings.paymentType)
    {
        case TOKEN:
        {
            //Generate token:
            [PMManager generateTokenWithMethod:(paymentMethod)
                                    parameters:params
                                       success:^(NSString *token){
										   [self dismissViewControllerAnimated:YES completion:^{
											   OnSuccessBlock(token);
										   }];
                                       }
                                       failure:^(PMError *error) {
                                           [self dismissViewControllerAnimated:YES completion:^{
											   OnFailureBlock(error);
										   }];
                                       }];
            break;
        }
           
        case TOKEN_WO_INIT:
        {
            //Generate token without init:
            [PMManager generateTokenWithPublicKey:self.publicKey testMode:settings.isTestMode method:paymentMethod parameters:paymentParams success:^(NSString *token) {
				[self dismissViewControllerAnimated:YES completion:^{
					OnSuccessBlock(token);
				}];
				
			} failure:^(PMError *error) {
				[self dismissViewControllerAnimated:YES completion:^{
					OnFailureBlock(error);
				}];
				
			}];
            break;
        };
            
        case TRANSACTION:
        {
			[PMManager transactionWithMethod:paymentMethod parameters:params consumable:settings.consumable
									success:^(PMTransaction *transaction) {
										[self dismissViewControllerAnimated:YES completion:^{
											OnSuccessBlock(transaction);
										}];
                                        
                                     }
                                     failure:^(PMError *error) {
										[self dismissViewControllerAnimated:YES completion:^{
											OnFailureBlock(error);
										}];
										
			}];
            break;
        }
            
        case PREAUTHORIZATION:
        {
            //Create preauthorization:
			
            [PMManager preauthorizationWithMethod:paymentMethod parameters:params consumable:settings.consumable
                                          success:^(PMTransaction *transaction) {
											  [self dismissViewControllerAnimated:YES completion:^{
												  OnSuccessBlock(transaction);
											  }];
                                          }
                                          failure:^(PMError *error) {
											[self dismissViewControllerAnimated:YES completion:^{
												OnFailureBlock(error);

											}];
										  }];
            break;
        }
            
        default:
            break;
    }
}

/**************************************/
#pragma mark - Segment controls actions
/**************************************/
-(void)segSelected:(id)sender
{
    UITextField *textfield = (UITextField *)[self findFirstResponder:self.tableView];
    
    if ( nil != textfield ) {
        int newtag = textfield.tag;
        
        if([(UISegmentedControl *)sender selectedSegmentIndex]) {
            newtag += 1;
        }
        else {
            if ( newtag > 0 ) {
                newtag -= 1;
            }
        }
        
        UITextField* tf = (UITextField*)[self.tableView viewWithTag:newtag];
		
        if ( [tf isKindOfClass:[UITextField class]] ) {
            self.activeTextField = tf;
            [tf becomeFirstResponder];
            
            if (self.tableView.frame.size.height > self.tableView.frame.size.width) {
                [self.tableView setContentOffset:CGPointMake(0.0, 260 - (tableView.frame.size.height - editedField.superview.superview.frame.origin.y - 90)) animated:YES];
            }
            else {
                [self.tableView setContentOffset:CGPointMake(0.0, editedField.superview.superview.frame.origin.y) animated:YES];
            }
        }
        else {
            [self resignKeyboard];
        }
		
    }
    else {
        [self.activeTextField becomeFirstResponder];
        [self resignKeyboard];
    }
    
    ((UISegmentedControl *)sender).selectedSegmentIndex = -1;
}

-(void)paymentTypeSegSelected:(id)sender
{
	if([sender isKindOfClass:[UISegmentedControl class]]){
		if([(UISegmentedControl *)sender selectedSegmentIndex]) {
			isDirectDebitSelected = YES;
		}
		else {
			isDirectDebitSelected = NO;
		}
		
		if(sectionCC) {
			sectionCC.hidden = isDirectDebitSelected;
		}
		
		[self.tableView reloadData];
	}
}

/**************************************/
#pragma mark - UITextFieldDelegate
/**************************************/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    editedField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case ACCOUNT_HOLDER:
			ddAccountStr = textField.text;
			break;
        case CARD_ACCOUNT_HOLDER:
            nameStr = textField.text;
            break;
        case ACCOUNT_NUMBER:
            ddAccountStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
        case CARD_NUMBER:
            accountStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
        case BANK_CODE:
            ddCodeStr = textField.text;
            break;
        case CVV:
            codeStr = textField.text;
            break;
        case EXP_DATE:
            expMonthStr = [self.pickerMonthArray objectAtIndex:[self.expPickerView selectedRowInComponent:0]];
            expYearStr  = [self.pickerYearArray objectAtIndex:[self.expPickerView selectedRowInComponent:1]];
            textField.textColor =  self.isDateExpired ? [UIColor redColor] : [UIColor darkTextColor];
            break;
            
        default:
            break;
    }
	editedField = nil;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == EXP_DATE)
    {
        textField.inputView = self.expPickerView;
    }
    else if(textField.tag == BANK_CODE)
	{
		textField.inputView = nil;
	}
    textField.inputView.hidden = false;
    
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == EXP_DATE) {
        textField.text = [NSString stringWithFormat:@"%@/%@", [self.pickerMonthArray objectAtIndex:[self.expPickerView selectedRowInComponent:0]], [self.pickerYearArray objectAtIndex:[self.expPickerView selectedRowInComponent:1]]];
	}
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""]) {
		sectionCC.image = [UIImage imageNamed:@"placeholder"];
        return YES;
    }
    
    NSString *_newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet* numberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSCharacterSet* nonNumberSet = [NSCharacterSet decimalDigitCharacterSet];
    
    if(textField.tag == EXP_DATE) {
        return [self validateInputWithString:_newStr];
        textField.textColor =  self.isDateExpired ? style.inputFieldWrongColor : style.inputFieldConfirmColor;
    }
    else if(textField.tag == ACCOUNT_NUMBER || textField.tag == BANK_CODE) {
        [sectionCC removeFromSuperview];
        return ([string stringByTrimmingCharactersInSet:numberSet].length > 0);
    }
    else if (textField.tag == ACCOUNT_HOLDER || textField.tag == CARD_ACCOUNT_HOLDER) {
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0);
    }
    else if (textField.tag == CARD_NUMBER)
    {
        if ( ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) ) {
            return NO;
        }
        
        if (range.location > 256)
        {
            range.location = 0;
        }
        
        NSString *newStr = [_newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        recognizedCC = [[PMCreditCardTypeParser instance] checkExpression:newStr];
        
        
        if(recognizedCC.result == VALID)
        {
            int lastLength = [(NSNumber *)[recognizedCC.numLength lastObject] intValue];
            if(newStr.length > lastLength)
            {
                textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (range.location < 6)
                {
                    NSString *msg = [NSString stringWithFormat:@"Credit card number is too long for recognized credit card type %@", recognizedCC.type];
                    
                    [self showMessage:@"Credit card number alert"
                                 text:msg];
                }
                return NO;
            }
            
            [self didRecognizeCCNumber:newStr inTextField:textField];
        }
        else if(recognizedCC.result == INVALID)
        {
            textField.textColor = style.inputFieldWrongColor;
            
            if (sectionCC) {
                sectionCC.hidden = YES;
			}
        }
        else if(recognizedCC.result == NOT_YET_KNOWN)
        {
            textField.textColor = style.inputFieldNonConfirmColor;
            
            if (sectionCC) {
                sectionCC.hidden = YES;
			}
        }
        
        // Get the selected text range
        UITextRange *selectedRange = [textField selectedTextRange];
        
        // Calculate the existing position, relative to the end of the field (will be a - number)
        int pos = [textField offsetFromPosition:textField.endOfDocument toPosition:selectedRange.start];
        
		int spaceNumberBefore = textField.text.length - [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length;
        textField.text = [self stringByGrouping:_newStr By:recognizedCC];
        
        int spaceNumberAfter = textField.text.length - [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length;
        int spaceNumberCorrection = spaceNumberBefore - spaceNumberAfter;
        if (spaceNumberCorrection && pos)// && -pos >= textField.text.length)
        {
            pos += spaceNumberCorrection;
        }
        
        if (range.length > string.length/* && string.length > */ && range.length > 1)
            pos += range.length;
        
        if((range.location + string.length) < textField.text.length && string.length > 0)
        {
            NSString *sstr = [textField.text substringWithRange:(NSRange){range.location, string.length}];
            int spnum = sstr.length - [sstr stringByReplacingOccurrencesOfString:@" " withString:@""].length;
            pos += spnum;
        }
        
        if (pos >= 0)
            pos = 0;
        if (-pos >= textField.text.length)
            pos = -textField.text.length;
        
        if ((range.location + range.length) < textField.text.length)
            if([[textField.text substringWithRange:range] isEqualToString:@" "])
                pos --;
        
        UITextPosition *newPos = [textField positionFromPosition:textField.endOfDocument offset:pos];
        
        // Reselect the range, to move the cursor to that position
        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        
        return NO;
    }
    else if(textField.tag == CVV && recognizedCC.result == VALID)
    {
        NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(newStr.length > recognizedCC.cvcMaxLength)
            return NO;
        NSCharacterSet* numberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return ([string stringByTrimmingCharactersInSet:numberSet].length > 0 || [string isEqualToString:@""]);
        
        if(newStr.length < recognizedCC.cvcMinLength)
            textField.textColor = style.inputFieldNonConfirmColor;
        else
            textField.textColor = style.inputFieldConfirmColor;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

/**************************************/
#pragma mark - UI validation methods
/**************************************/
- (bool)inputVerification
{
    BOOL segueShouldOccur = YES|NO;
    NSString *msg = @"Please enter:";
    
    if([(isDirectDebitSelected ? ddAccountStr : accountStr) isEqualToString:@""])
    {
        msg = [msg stringByAppendingString:isDirectDebitSelected ? @"account number," : @" credit card number,"];
        segueShouldOccur = NO;
    }
    else {
		if(!isDirectDebitSelected && recognizedCC.result == INVALID) {
			msg = [msg stringByAppendingString:@" supported credit card type,"];
            segueShouldOccur = NO;
		}
		else  if(!isDirectDebitSelected && [self luhnCheck:(isDirectDebitSelected ? ddAccountStr : accountStr)] == 0) // && != @"0"
        {
            msg = [msg stringByAppendingString:@" correct credit card number,"];
            segueShouldOccur = NO;
        }
    }
    if([(isDirectDebitSelected ? ddCodeStr : codeStr) isEqualToString:@""])
    {
        msg = [msg stringByAppendingString:isDirectDebitSelected ? @" bank code," : @" CVC,"];
        segueShouldOccur = NO;
    }
    
    if([nameStr isEqualToString:@""])
    {
        msg = [msg stringByAppendingString:@" name,"];
        segueShouldOccur = NO;
    }
    
    if(!isDirectDebitSelected && ([expMonthStr isEqualToString:@""] || [expYearStr isEqualToString:@""]))
    {
        msg = [msg stringByAppendingString:@" expiration date,"];
        segueShouldOccur = NO;
        
    }
    
    NSDate *date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    
    if (!isDirectDebitSelected && (expMonthStr.length > 2 || expYearStr.length > 2))
    {
        segueShouldOccur = NO;
        msg = @"Incorrect expiration date!";
    }
    
    NSString *expYear2000Str = [NSString stringWithFormat:@"20%@", expYearStr];
    
    //Verification for expiration date of the credit card
    if(!isDirectDebitSelected && ![expYear2000Str isEqualToString:@""] && ![expMonthStr isEqualToString:@""] && (expYear2000Str.intValue < year ||
                                                                                                                 (expYear2000Str.intValue == year && expMonthStr.intValue < month)))
    {
        segueShouldOccur = NO;
        msg = NSLocalizedString(@"The credit card has expired!", @"The credit card has expired!");
    }
	
    if (!segueShouldOccur)
    {
        msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
        msg = [msg stringByAppendingString:@"!"];
        
        [self showMessage:@"Alert" text:msg];
    }
	
    return segueShouldOccur;
}

-(BOOL)isDateExpired
{
    NSDate *date = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
	
    NSString *expYear2000Str = [NSString stringWithFormat:@"20%@", expYearStr];
    
    //Verification for expiration date of the credit card
    if((expYear2000Str.intValue < year || (expYear2000Str.intValue == year && expMonthStr.intValue < month))){
        return YES;
	}
    else {
        return NO;
	}
}


-(BOOL)luhnCheck:(NSString*)stringToTest
{
	BOOL isOdd = YES;
	int oddSum = 0;
	int evenSum = 0;
    
	for (int i = [stringToTest length] - 1; i >= 0; i--)
    {
        NSRange r = {i, 1};
        int digit = [[stringToTest substringWithRange:r] intValue];
		
		if (isOdd)
			oddSum += digit;
		else
			evenSum += digit/5 + (2*digit) % 10;
        
		isOdd = !isOdd;
	}
    
	return ((oddSum + evenSum) % 10 == 0);
}

-(NSString *)stringByGrouping:(NSString *)string By:(PMCreditCardCheck *)ccCheck
{
    NSString *resstr = @"";
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(string.length <=4)
        return string;
        
    int i = 0;
    int step = 4;
    for (i = 0; i+step < string.length; i += step)
    {
        ///
        if (recognizedCC.result == VALID && (((NSNumber *)[recognizedCC.numLength objectAtIndex:0]).intValue == 15 || ((NSNumber *)[recognizedCC.numLength objectAtIndex:0]).intValue == 14))
        {
            if(i == 4)
                step = ((string.length - i) < 6) ? string.length - i : 6;
            if(i == 10)
                step = string.length - i;
        }
        ///

        NSRange r = {i, step};
        
        resstr = [resstr stringByAppendingString:[string substringWithRange:r]];
        
        resstr = [resstr stringByAppendingString:@" "];
    
    }
 
    NSRange r = {i, string.length-i};
    resstr = [resstr stringByAppendingString:[string substringWithRange:r]];
    
    resstr = [resstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return resstr;
}

- (BOOL)validateInputWithString:(NSString *)aString
{
    NSString* const regularExpression = @"^([0-1][0-9]/[0-9][0-9])$";
    NSError* error = NULL;
	NSUInteger numberOfMatches = 0;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if(!error) {
		numberOfMatches = [regex numberOfMatchesInString:aString
												 options:0
												   range:NSMakeRange(0, [aString length])];
	}
	
    return numberOfMatches > 0;
}

/**************************************/
#pragma mark - UIPickerViewDataSource
/**************************************/
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return (component)?[self.pickerYearArray count] : [self.pickerMonthArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *returnStr = @"";
	
	if (component)
	{
        returnStr = [self.pickerYearArray objectAtIndex:row];
	}
    else
    {
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

/**************************************/
#pragma mark - UIKeyboard Notifications
/**************************************/
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShown:)
												 name:UIKeyboardWillShowNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidHide:)
												 name:UIKeyboardDidHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification *)note
{
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
   
    [tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, kbSize.height + navigationBar.frame.size.height, 0.0)];

    if ((editedField.superview.superview.frame.origin.y + editedField.superview.superview.frame.size.height) < (tableView.frame.size.height - kbSize.height - keyBar.frame.size.height))
    {
        return;
    }

    if (self.tableView.frame.size.height > self.tableView.frame.size.width)
    {
        [self.tableView setContentOffset:CGPointMake(0.0, kbSize.height - (tableView.frame.size.height - editedField.superview.superview.frame.origin.y - 90)) animated:YES];
    }
    else
    {
        [self.tableView setContentOffset:CGPointMake(0.0, editedField.superview.superview.frame.origin.y) animated:YES];
    }
}


-(void)keyboardDidHide:(NSNotification *)note
{
    [tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, navigationBar.frame.size.height, 0.0)];
}

-(void)resignKeyboard
{
    [self textFieldShouldReturn:(UITextField *)[self findFirstResponder:self.view]];
    [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

/**************************************/
#pragma mark - UIInterfaceOrientation
/**************************************/

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self resignKeyboard];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [tableView reloadData];
    
    [self resignKeyboard];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //Deprecated!
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


@end
