//
//  PMPaymentMethodsListViewController.m
//  VoucherMill
//
//  Created by gabi on 3/14/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMPaymentMethodsListViewController.h"
#import "PMPaymentMethodsListCell.h"
#import <PayMillSDK/PMSDK.h>
#import "PMUISupport.h"
#import "MBProgressHUD.h"

static OnPaymentListSuccess OnSuccessBlock;
static OnPaymentListFailure OnFailureBlock;

static NSString* paymentsCellId = @"paymensListCellId";

@interface PMPaymentMethodsListViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *topToolbar;
@property (weak, nonatomic) IBOutlet UITableView *paymentsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPaymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) PMPaymentParams* paymentParams;
@property (nonatomic, strong) NSMutableArray* paymentsArr;
@property (nonatomic, strong) PMSettings* pmSettings;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString* password;

- (IBAction)useNewPayment:(id)sender;
- (IBAction)back:(id)sender;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMPaymentMethodsListViewController

/**************************************/
#pragma mark - Init
/**************************************/
- (PMPaymentMethodsListViewController *)initWithParams:(PMPaymentParams*)pmParams
                                     paymentsArr:(NSMutableArray *)payments
                                      pmSettings:(PMSettings *)settings
                                    successBlock:(void (^)(id))success
                                 andFailureBlock:(void (^)(NSError *))failure;
{
    self = [super init];
    
    if ( nil != self ) {
        self.paymentParams = pmParams;
		self.paymentsArr = payments;
        self.pmSettings = settings;
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
    
    self.index = -1;
    
    [self.backButton setTitle:kPMStringBack forState:UIControlStateNormal];
    [self regiserNibs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)regiserNibs
{
    [self.paymentsTableView registerNib:[UINib nibWithNibName:@"PMPaymentMethodsListCell" bundle:nil] forCellReuseIdentifier:paymentsCellId];
}

- (void)setButtonsEnabled:(BOOL)enabled
{
    self.backButton.enabled = enabled;
    self.addPaymentBtn.enabled = enabled;
}

- (NSString*)imageNameForCardType:(NSString*)cardType
{
    NSString* imageName = nil;
    
    if ( [cardType isEqualToString:kPMCardTypeVisa]) {
        imageName = @"visa";
    }
    else if ( [cardType isEqualToString:kPMCardTypeMasterCard]) {
        imageName = @"masterCard";
    }
    else if ( [cardType isEqualToString:kPMCardTypeMaestro]) {
        imageName = @"maestro";
    }
    else if ( [cardType isEqualToString:kPMCardTypeAmExp]) {
        imageName = @"americanExpress";
    }
    else if ( [cardType isEqualToString:kPMCardTypeJCB]) {
        imageName = @"jcb";
    }
    else if ( [cardType isEqualToString:kPMCardTypeDiners]) {
        imageName = @"dinersClub";
    }
    else if ( [cardType isEqualToString:kPMCardTypeDiscover]) {
        imageName = @"discover";
    }
    else if ( [cardType isEqualToString:kPMCardTypeUnionPay]) {
        imageName = @"unionPay";
    }
    else {
        imageName = @"placeholder";
    }
    
    return imageName;
}

- (void)deletePaymentForIndexPath:(NSIndexPath*)indexPath
{
    if ( nil != self.password ) {
        [PMUISupport showYesNOAlertWithMessage:kPMDeletePaymentMessage
                                           tag:PMAlertTypeDeletePayment
                                   andDelegate:self];
    }
}

- (void)deletePayment
{
    PMPayment* paymemt = [self.paymentsArr objectAtIndex:self.index];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setButtonsEnabled:NO];
    
    [PMManager deletePayment:paymemt withPassword:self.password successBlock:^(PMPayment* payment) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self setButtonsEnabled:YES];
        
        [self.paymentsArr removeObjectAtIndex:self.index];
        NSIndexPath* ip = [NSIndexPath indexPathForRow:self.index inSection:0];
        [self.paymentsTableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
        self.index = -1;
    } andFailureBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self setButtonsEnabled:YES];
        if ( [error code] == SAFESTORE ) {
            NSString* safeStoreError = [[error userInfo] valueForKey:PMSafeStoreErrorCodeKey];
            NSString* errormessage = nil;
            if ([safeStoreError isEqualToString:PMSafeStoreIncorrectPassword]) {
                errormessage = kPMPaymentNotDeletedMessage;
                [PMUISupport showAlertWithMessage:errormessage];
            }
            else {
                [self resetSafeStore];
            }
        }
        else {
            [PMUISupport showAlertWithMessage:[error localizedDescription]];
        }
    }];
}

/**************************************/
#pragma mark - SafeStore Methods
/**************************************/
- (void)setSafestorePassword:(NSString *)password
{
    self.password = password;
}

- (void)resetSafeStore
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setButtonsEnabled:NO];
    
    [PMManager resetPaymentsWithWithSuccessBlock:^(BOOL success) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self setButtonsEnabled:YES];
        [PMUISupport showAlertWithMessage:kPMSafeStoreResetMessage];
    } andFailureBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self setButtonsEnabled:YES];
        [PMUISupport showAlertWithMessage:[error localizedDescription]];
    }];
}

/*********************************************/
#pragma mark - UITableViewDataSource Methods
/*********************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.paymentsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMPaymentMethodsListCell* cell = [tableView dequeueReusableCellWithIdentifier:paymentsCellId forIndexPath:indexPath];
    
    PMPayment* payment = [self.paymentsArr objectAtIndex:indexPath.row];
    
    if ( [payment.type isEqualToString:kPMPaymentTypeCreditCard]) {
        cell.logoImage = [UIImage imageNamed:[self imageNameForCardType:payment.card_type]];
        cell.numberStr = [NSString stringWithFormat:@"*****%@", payment.last4];
    }
    else {
        cell.logoImage = nil;
        cell.numberStr = payment.account;
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.index = indexPath.row;
        [self deletePaymentForIndexPath:indexPath];
    }
}

/*********************************************/
#pragma mark - UITableViewDelegate Methods
/*********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMPayment* payment = [self.paymentsArr objectAtIndex:indexPath.row];
    
    switch ( self.pmSettings.paymentType )
    {
        case TRANSACTION:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self setButtonsEnabled:NO];
            
            [PMManager transactionWithPayment:payment
                                   parameters:self.paymentParams
                                   consumable:NO
                                      success:^(PMTransaction *transaction) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          [self setButtonsEnabled:YES];
                                          [self dismissViewControllerAnimated:YES completion:^{
                                              OnSuccessBlock(transaction);
                                          }];
                                      }
                                      failure:^(NSError *error) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          [self setButtonsEnabled:YES];
                                          [self dismissViewControllerAnimated:YES completion:^{
                                              OnFailureBlock(error);
                                          }];
                                      }];
            
            break;
        }
            
        case PREAUTHORIZATION:
        {
            //Create preauthorization:
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self setButtonsEnabled:NO];
            
            [PMManager preauthorizationWithPayment:payment
                                        parameters:self.paymentParams
                                        consumable:NO
                                           success:^(PMTransaction *transaction) {
                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                               [self setButtonsEnabled:YES];
                                               [self dismissViewControllerAnimated:YES completion:^{
                                                   OnSuccessBlock(transaction);
                                               }];
                                               
                                           } failure:^(NSError *error) {
                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                               [self setButtonsEnabled:YES];
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
#pragma mark - Btn Actions
/**************************************/
- (IBAction)useNewPayment:(id)sender
{
    [self.paymentsTableView setEditing:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender
{
    [self.paymentsTableView setEditing:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/******************************************/
#pragma mark - UIAlertViewDelegate Methods
/******************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 && self.index != -1 ) {
        [self deletePayment];
    }
    else {
        [self.paymentsTableView setEditing:NO];
    }
}

@end
