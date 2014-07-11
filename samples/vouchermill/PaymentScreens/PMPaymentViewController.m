//
//  PMPaymentViewController.m
//  VoucherMill
//
//  Created by PayMill on 3/26/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMPaymentViewController.h"
#import "PMCreditCardView.h"
#import "PMDirectDebitView.h"
#import "PMCreditCardTypeParser.h"
#import "PMUserDefaultsManager.h"
#import "PMPaymentDataValidator.h"
#import "PMVoucherParams.h"
#import <QuartzCore/QuartzCore.h>
#import "PMUISupport.h"
#import "PMBuyDetailsViewController.h"
#import "PMPaymentMethodsListViewController.h"
#import "MBProgressHUD.h"

/**
 On success completion of the payment operation block
 */
static OnCompletionSuccess OnSuccessBlock;
/**
 On failure completion of the payment operation block
 */
static OnCompletionFailure OnFailureBlock;


/**************************************/
#pragma mark - PMSettings interface
/**************************************/
@interface PMSettings ()
/**
 directDebitCountry
 */
@property(nonatomic, strong) NSString *directDebitCountry;
/**
 isTestMode
 */
@property (nonatomic) BOOL isTestMode;
/**
 safeStoreEnabled
 */
@property (nonatomic) BOOL safeStoreEnabled;
/**
 consumable
 */
@property (nonatomic) BOOL isConsumable;
/**
 cardTypes
 */
@property NSMutableArray *cardTypes;

/**
 prefill data
 */
@property (nonatomic, strong) NSString *accountHolder;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expiryMonth;
@property (nonatomic, strong) NSString *expiryYear;
@property (nonatomic, strong) NSString *verification;

@end

/****************************************/
#pragma mark - PMSettings implementation
/****************************************/
@implementation PMSettings : NSObject

+ (id)settingsWithPaymentType:(PMPaymentType)type directDebitCountry:(NSString*)ddCountry testMode:(BOOL)testMode safeStoreEnabled:(BOOL)enabled andConsumable:(BOOL)consumable
{
    PMSettings* settings = [PMSettings new];
    settings.paymentType = type;
    settings.directDebitCountry = ddCountry;
    settings.isTestMode = testMode;
    settings.isConsumable = consumable;
    settings.safeStoreEnabled = enabled;
    settings.cardTypes = [NSMutableArray arrayWithArray:[[PMUserDefaultsManager instance] getActiveCards]];
    
    return settings;
}

- (void)enableAllCreditCards
{
    self.cardTypes = [NSMutableArray arrayWithArray:[[PMUserDefaultsManager instance] getActiveCards]];
}

- (void)disableAllCreditCards
{
    [self.cardTypes removeAllObjects];
}

- (void)enableCreditCardType:(NSString *)cardType
{
    if ( ![self.cardTypes containsObject:cardType] ) {
        [self.cardTypes addObject:cardType];
    }
}

- (void)disableCreditCardType:(NSString *)cardType
{
    if ( [self.cardTypes containsObject:cardType] ) {
        [self.cardTypes removeObject:cardType];
    }
}

-(void)prefillCreditCardDataWithAccHolder:(NSString*)accHolder cardNumber:(NSString*)aCardNumber expiryMonth:(NSString*)anExpiryMonth expiryYear:(NSString*)anExpiryYear verification:(NSString *)aVerification
{
	self.accountHolder = accHolder;
	self.cardNumber = aCardNumber;
	self.expiryMonth = anExpiryMonth;
	self.expiryYear  = anExpiryYear;
	self.verification = aVerification;
}

@end

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMPaymentViewController ()

@property (nonatomic, strong) PMCreditCardView* creditCardView;
@property (nonatomic, strong) PMDirectDebitView* directDebitView;
@property (nonatomic, strong) PMPaymentView* paymentView;

@property (nonatomic, strong) PMPaymentDataValidator* paymentDataValidator;

@property (nonatomic, assign) BOOL keyboardIsShown;
@property (nonatomic, assign) BOOL isDirectDebitSelected;
@property (nonatomic, assign) BOOL existingMethodsMessageShown;

@property (nonatomic, strong) PMSettings *settings;
@property (nonatomic, strong) PMPaymentParams *paymentParams;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) PMStyle *style;
@property (nonatomic, strong) id createdObject;
@property (nonatomic, strong) NSString* password;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMPaymentViewController

/**************************************/
#pragma mark - Init
/**************************************/
- (PMPaymentViewController *)initWithParams:(PMPaymentParams*)pmParams publicKey:(NSString *)pubKey settings:(PMSettings *)pmSettings style:(PMStyle *)pmStyle success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    self = [super init];
    
    if ( nil != self ) {
        self.paymentParams = pmParams;
		self.publicKey = pubKey;
		self.settings = pmSettings;
		self.style = pmStyle;
		OnSuccessBlock = success;
		OnFailureBlock = failure;
    }
    
    return self;
}

- (PMPaymentViewController *)initWithParams:(PMPaymentParams*)pmParams publicKey:(NSString *)pubKey settings:(PMSettings *)pmSettings success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    self = [super init];
    
    if ( nil != self ) {
        self.paymentParams = pmParams;
		self.publicKey = pubKey;
		self.settings = pmSettings;
		OnSuccessBlock = success;
		OnFailureBlock = failure;
    }
    
    return self;
}

/**************************************/
#pragma mark - View Lifecycle Methods
/**************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyboardIsShown = NO;
    [self customiseSegmentedControl];
    [self createNavBarButtons];
    [self registerForKeyBoardNotifications];
    [self registerForApplicationNotifications];
    
    self.paymentDataValidator = [PMPaymentDataValidator new];
    [self.paymentDataValidator registerDelegate:self];
    
    if ( [self.settings.cardTypes count] > 0 ) {
        [self createDebitCardView];
    }
    if ( nil != self.settings.directDebitCountry ) {
        [self createDirectDebitView];
    }
    
    ((PMCreditCardTypeParser *)[PMCreditCardTypeParser instance]).cardTypes = [[PMUserDefaultsManager instance] getActiveCards];
    //[self createProgressIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setPaymentViewSize];
    
    BOOL shouldShowExistingPaymentsMessage = (!self.existingMethodsMessageShown && ( self.settings.paymentType == PREAUTHORIZATION || self.settings.paymentType == TRANSACTION));
    
    if ( shouldShowExistingPaymentsMessage ) {
        [self setUIEnabled:NO];
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        [PMManager arePaymentsAvailableWithSuccessBlock:^(BOOL success) {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            if ( self.settings.safeStoreEnabled && success ) {
                [PMUISupport showYesNOAlertWithMessage:kPMUseExistingPaymentMessage
                                                   tag:PMAlertTypeExistingPayment
                                           andDelegate:self];
            }
            
            [self setUIEnabled:YES];
            
        } andFailureBlock:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            [self setUIEnabled:YES];
        }];
        
        self.existingMethodsMessageShown = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.paymentDataValidator unregisterDelegate:self.creditCardView];
    [self.paymentDataValidator unregisterDelegate:self.directDebitView];
    [self.paymentDataValidator unregisterDelegate:self];
}

/*****************************************/
#pragma mark - Register For Notifications
/*****************************************/
- (void)registerForKeyBoardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)registerForApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)createDebitCardView
{
    self.creditCardView = [PMCreditCardView creditCardView];
    self.creditCardView.style = self.style;
    self.creditCardView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.creditCardView setTextFieldsDelegate:self.paymentDataValidator];
    [self.paymentDataValidator registerDelegate:self.creditCardView];
    self.paymentView = self.creditCardView;
    [self.view addSubview:self.paymentView];
    self.paymentDataValidator.paymentDataType = PMPaymentDataTypeCreditCard;
}

- (void)createDirectDebitView
{
    self.directDebitView = [PMDirectDebitView directDebitView];
    self.directDebitView.style = self.style;
    self.directDebitView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.paymentDataValidator registerDelegate:self.directDebitView];
    [self.directDebitView setTextFieldsDelegate:self.paymentDataValidator];
    
    if ( [self.settings.cardTypes count] == 0 ) {
        self.paymentView = self.directDebitView;
        [self.view addSubview:self.paymentView];
        self.isDirectDebitSelected = YES;
        self.paymentDataValidator.paymentDataType = PMPaymentDataTypeDirectDebit;
    }
}

- (void)customiseSegmentedControl
{
    if(self.settings.cardTypes.count > 0 && self.settings.directDebitCountry) {
        [self.segmentedControl setTitle:kPMTitleCreditCard forSegmentAtIndex:0];
        [self.segmentedControl setTitle:kPMTitleDirectDebit forSegmentAtIndex:1];
    }
    else if (self.settings.directDebitCountry) {
        [self.segmentedControl setTitle:kPMTitleCreditCard forSegmentAtIndex:0];
    }
    else if (self.settings.cardTypes.count > 0) {
        [self.segmentedControl setTitle:kPMTitleDirectDebit forSegmentAtIndex:0];
    }
    
    self.segmentedControl.selectedSegmentIndex = 0;
    CGRect frame = self.segmentedControl.frame;
    frame.size.height = 40.0;
    self.segmentedControl.frame = frame;
    
    UIBarMetrics barMetrics = UIBarMetricsDefault;
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal barMetrics:barMetrics];
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateSelected barMetrics:barMetrics];
    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"divider_selected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:barMetrics];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor,nil];
    [self.segmentedControl setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    [self.segmentedControl.layer setMasksToBounds:YES];
    [self.segmentedControl.layer setBorderWidth:2.0f];
    [self.segmentedControl.layer setBorderColor:[UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0].CGColor];
    [self.segmentedControl.layer setCornerRadius:6.0f];
    
    [self.segmentedControl addTarget:self action:@selector(paymentTypeSegSelected:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl];
}

- (void)setUIEnabled:(BOOL)enabled
{
    self.segmentedControl.enabled = enabled;
    self.navigationItem.rightBarButtonItem.enabled = enabled;
    self.navigationItem.leftBarButtonItem.enabled  = enabled;
    [self.paymentView setUIEnabled:enabled];
}

- (void)setPaymentViewSize
{
    self.paymentView.frame = CGRectMake(0.0,
                                        CGRectGetMaxY(self.segmentedControl.frame),
                                        CGRectGetWidth(self.view.bounds),
                                        CGRectGetHeight(self.view.bounds) - (CGRectGetMaxY(self.segmentedControl.frame)));
    
    self.paymentView.scrollView.contentSize = [self.paymentView viewContentSize];
}

-(void)createNavBarButtons
{
	UIBarButtonItem* submitButton = [[UIBarButtonItem alloc] initWithTitle:kPMStringSubmit
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(submitAction:)];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:kPMStringCancel
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(cancelAction:)];
    
	
	self.navigationItem.rightBarButtonItem = submitButton;
    self.navigationItem.leftBarButtonItem  = cancelButton;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor =[UIColor orangeColor];
}

- (void)setSafestorePassword:(NSString *)password
{
    self.password = password;
}

- (void)savePaymentWithPassword:(NSString*)password
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [PMManager savePayment:((PMTransaction*)self.createdObject).payment
              withPassword:password
              successBlock:^(PMPayment* payment) {
                  [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                  [PMUISupport showAlertWithMessage:kPMPaymentSavedMessage];
                  [self close];
              }
           andFailureBlock:^(NSError *error) {
               [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
               
               if ( [error code] == SAFESTORE ) {
                   NSString* safeStoreError = [[error userInfo] valueForKey:PMSafeStoreErrorCodeKey];
                   if ([safeStoreError isEqualToString:PMSafeStoreIncorrectPassword]) {
                       [PMUISupport showPasswordAlertWithMessage:kPMIncorrectPasswordMessage
                                                             tag:PMAlertTypeEnterPassword
                                                     andDelegate:self];
                   }
                   else {
                       [self resetSafeStoreAndDismissWithCompletionIfNeeded:YES];
                   }
               }
               else {
                   [PMUISupport showAlertWithMessage:[error localizedDescription]];
                   [self dismissViewControllerAnimated:YES completion:nil];
               }
    }];
}

- (void)showPaymentsListControllerWithPassword:(NSString*)password
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [PMManager getPaymentsListWithPassword:password
                              successBlock:^(NSArray *payments) {
                                  [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                  NSError* error = nil;
                                  
                                  PMPaymentMethodsListViewController* paymentsListCtrl = [[PMPaymentMethodsListViewController alloc] initWithParams:self.paymentParams paymentsArr:[NSMutableArray arrayWithArray:payments] pmSettings:self.settings successBlock:^(id resObject) {
                                      [self dismissViewControllerAnimated:YES completion:^{
                                          OnSuccessBlock(resObject);
                                      }];
                                      
                                    } andFailureBlock:^(NSError * err) {
                                      [self dismissViewControllerAnimated:YES completion:^{
                                          OnFailureBlock(error);
                                      }];
                                  }];
                                  
                                  if ( self.settings.safeStoreEnabled && self.password ) {
                                      [paymentsListCtrl setSafestorePassword:self.password];
                                  }
                                  
                                  [self.navigationController presentViewController:paymentsListCtrl animated:YES completion:nil];
                              } andFailureBlock:^(NSError *error) {
                                  [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                  if ( [error code] == SAFESTORE ) {
                                      NSString* safeStoreError = [[error userInfo] valueForKey:PMSafeStoreErrorCodeKey];
                                      if ([safeStoreError isEqualToString:PMSafeStoreIncorrectPassword]) {
                                          [PMUISupport showPasswordAlertWithMessage:kPMIncorrectPasswordMessage
                                                                                tag:PMAlertTypeEnterPasswordForMethosList
                                                                        andDelegate:self];
                                      }
                                      else {
                                          [self resetSafeStoreAndDismissWithCompletionIfNeeded:NO];
                                      }
                                  }
                                  else {
                                      [PMUISupport showAlertWithMessage:[error localizedDescription]];
                                  }
                              }];
}

- (void)resetSafeStoreAndDismissWithCompletionIfNeeded:(BOOL)bNeeded
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [PMManager resetPaymentsWithWithSuccessBlock:^(BOOL success) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [PMUISupport showAlertWithMessage:kPMSafeStoreResetMessage];
        if ( bNeeded ) {
            [self close];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } andFailureBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        [PMUISupport showAlertWithMessage:[error localizedDescription]];
        if ( bNeeded ) {
            [self close];
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:^{
        OnSuccessBlock(self.createdObject);
    }];
}

/***********************************************/
#pragma mark - UIKeyboard Notifications Methods
/***********************************************/
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.paymentView.frame = CGRectMake(0.0,
                                            CGRectGetMaxY(self.segmentedControl.frame),
                                            CGRectGetWidth(self.view.bounds),
                                            CGRectGetHeight(self.view.bounds) - (CGRectGetMaxY(self.segmentedControl.frame)));
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    CGPoint scrollPoint = CGPointMake(0.0, 0.0);
    [self.paymentView.scrollView setContentOffset:scrollPoint animated:YES];
    self.keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if ( self.keyboardIsShown ) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat height = 0.0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown ) {
        height = keyboardSize.height;
    }
    else {
        height = keyboardSize.width;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.paymentView.frame = CGRectMake(0.0,
                                            0.0,
                                            CGRectGetWidth(self.paymentView.bounds),
                                            CGRectGetHeight(self.view.bounds) - height);
        
    }];
    
    if (!CGRectContainsPoint(self.paymentView.scrollView.frame, self.paymentView.activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, CGRectGetMinY(self.paymentView.activeTextField.frame));
        [self.paymentView.scrollView setContentOffset:scrollPoint animated:YES];
    }
    
    self.keyboardIsShown = YES;
}

/**************************************/
#pragma mark - Message Alert
/**************************************/
-(void)showMessage:(NSString *)title text:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:text
                                                   delegate:nil
                                          cancelButtonTitle:kPMStringOk
                                          otherButtonTitles:nil];
    [alert show];
}

/**************************************/
#pragma mark - Btn Actions
/**************************************/
-(void)paymentTypeSegSelected:(UISegmentedControl*)sender
{
    [self.paymentView removeFromSuperview];
    
    NSInteger index = [sender selectedSegmentIndex];
    if( index == 0 ) {
        self.isDirectDebitSelected = NO;
        self.paymentDataValidator.paymentDataType = PMPaymentDataTypeCreditCard;
        self.paymentView = self.creditCardView;
    }
    else {
        self.isDirectDebitSelected = YES;
        self.paymentDataValidator.paymentDataType = PMPaymentDataTypeDirectDebit;
        self.paymentView = self.directDebitView;
    }
    
    [self setPaymentViewSize];
    
    [self.view addSubview:self.paymentView];
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitAction:(id)sender
{
    [self.paymentView.activeTextField resignFirstResponder];
    [self setUIEnabled:NO];
    [self.paymentDataValidator validateObject];
}

/*********************************************************************/
#pragma mark - PMPaymentDataValidatorUIRepresentationDelegate Methods
/*********************************************************************/
- (void)paymentDataValidator:(PMPaymentDataValidator *)paymentDataValidator didValidateObjectWithError:(NSError *)error
{
    if ( nil != error ) {
        [PMUISupport showErrorAlertWithMessage:error.localizedDescription];
        [self setUIEnabled:YES];
    }
    else {
        NSError *error;
        
        //Create payment parameters
        PMPaymentParams *params = self.paymentParams;
        
        id paymentMethod;
        
        if( !error ) {
            if( self.isDirectDebitSelected ) {
                paymentMethod = [PMFactory genNationalPaymentWithIban:self.paymentDataValidator.ibanStr
                                                               andBic:self.paymentDataValidator.bicStr
                                                            accHolder:self.paymentDataValidator.accountHolderStr
                                                                error:&error];
            }
            else {
                paymentMethod = [PMFactory genCardPaymentWithAccHolder:self.paymentDataValidator.accountHolderStr
                                                            cardNumber:self.paymentDataValidator.cardNumberStr
                                                           expiryMonth:self.paymentDataValidator.expiryMonth
                                                            expiryYear:[NSString stringWithFormat:@"20%@", self.paymentDataValidator.expiryYear]
                                                          verification:self.paymentDataValidator.cvcStr
                                                                 error:&error];
            }
            
            if(error) {
                [self showMessage:[NSString stringWithFormat: @"Create payment method error: %d", (int)error.code] text:error.localizedDescription];
                return;
            }
        }
        else {
            [self showMessage:@"Create payment parameters error: %d" text:error.localizedDescription];
            return;
        }
        
        switch (self.settings.paymentType)
        {
            case TOKEN:
            {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                //Generate token:
                [PMManager generateTokenWithMethod:(paymentMethod)
                                        parameters:params
                                           success:^(NSString *token){
                                               [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                               [self dismissViewControllerAnimated:YES completion:^{
                                                   OnSuccessBlock(token);
                                               }];
                                           }
                                           failure:^(NSError *error) {
                                               [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                               [self dismissViewControllerAnimated:YES completion:^{
                                                   OnFailureBlock(error);
                                               }];
                                           }];
                break;
            }
                
            case TOKEN_WO_INIT:
            {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                //Generate token without init:
                [PMManager generateTokenWithPublicKey:self.publicKey testMode:self.settings.isTestMode method:paymentMethod parameters:self.paymentParams success:^(NSString *token) {
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        OnSuccessBlock(token);
                    }];
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        OnFailureBlock(error);
                    }];
                    
                }];
                break;
            };
                
            case TRANSACTION:
            {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                [PMManager transactionWithMethod:paymentMethod parameters:params consumable:self.settings.isConsumable
                                         success:^(PMTransaction *transaction) {
                                             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                             if ( nil!= transaction && self.settings.safeStoreEnabled ) {
                                                 self.createdObject = transaction;
                                                 [PMUISupport showYesNOAlertWithMessage:kPMSavePaymentMessage
                                                                                    tag:PMAlertTypeSavePayment
                                                                            andDelegate:self];
                                                 
                                             }
                                             else {
                                                 [self dismissViewControllerAnimated:YES completion:^{
                                                     OnSuccessBlock(transaction);
                                                 }];
                                             }
                                         }
                                         failure:^(NSError *error) {
                                             [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                             [self dismissViewControllerAnimated:YES completion:^{
                                                 OnFailureBlock(error);
                                             }];
                                             
                                         }];
                break;
            }
                
            case PREAUTHORIZATION:
            {
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                //Create preauthorization:
                [PMManager preauthorizationWithMethod:paymentMethod parameters:params consumable:self.settings.isConsumable
                                              success:^(PMTransaction *transaction) {
                                                  [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
                                                  if ( nil!= transaction && self.settings.safeStoreEnabled ) {
                                                      self.createdObject = transaction;
                                                      [PMUISupport showYesNOAlertWithMessage:kPMSavePaymentMessage
                                                                                         tag:PMAlertTypeSavePayment
                                                                                 andDelegate:self];
                                                  }
                                                  else {
                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                          OnSuccessBlock(transaction);
                                                      }];
                                                  }
                                              }
                                              failure:^(NSError *error) {
                                                  [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
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
}

/**************************************/
#pragma mark - UIInterfaceOrientation
/**************************************/
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.paymentView.activeTextField resignFirstResponder];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setPaymentViewSize];
}

/**************************************************/
#pragma mark - UIApplication Notifications Methods
/**************************************************/
- (void)willResignActive:(NSNotification*)notification
{
    [self.paymentView.activeTextField resignFirstResponder];
    
    [self.paymentView clearData];
}

- (void)didBecomeActive:(NSNotification*)notification
{
    [self.paymentView updateData];
}

/******************************************/
#pragma mark - UIAlertViewDelegate Methods
/******************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStyleSecureTextInput ) {
        if ( buttonIndex == 1 ) {
            NSString* password = [alertView textFieldAtIndex:0].text;
            
            if ( [password length] > 0 ) {
                if ( alertView.tag == PMAlertTypeEnterPasswordForMethosList) {
                    self.password = password;
                    [self showPaymentsListControllerWithPassword:self.password];
                }
                else {
                    [self savePaymentWithPassword:password];
                }
            }
            else {
                [PMUISupport showAlertWithMessage:kPMInvalidPasswordMessage];
                
                if ( alertView.tag == PMAlertTypeEnterPasswordForMethosList) {
                    self.password = nil;
                }
                else {
                    [self close];
                }
            }
        }
        else {
            [self resetSafeStoreAndDismissWithCompletionIfNeeded:NO];
        }
    }
    else {
        if ( alertView.tag == PMAlertTypeExistingPayment ) {
            if ( buttonIndex == 1 ) {
                [PMUISupport showPasswordAlertWithMessage:kPMEnterPasswordMessage
                                                      tag:PMAlertTypeEnterPasswordForMethosList
                                              andDelegate:self];
            }
        }
        else {
            if ( buttonIndex == 0 ) {
                [self close];
            }
            else {
                [PMUISupport showPasswordAlertWithMessage:kPMEnterPasswordMessage
                                                      tag:PMAlertTypeEnterPassword
                                              andDelegate:self];
            }
        }
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    self.keyboardIsShown = YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.keyboardIsShown = NO;
}

@end
