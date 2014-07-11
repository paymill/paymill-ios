//
//  PMPaymentDataValidator.h
//  VoucherMill
//
//  Created by gabi on 2/25/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PMPaymentDataType : NSInteger
{
    PMPaymentDataTypeNone           = 0,
    PMPaymentDataTypeCreditCard     = 1,
    PMPaymentDataTypeDirectDebit    = 2,
}PMPaymentDataType;

typedef enum PMTextFieldType : NSInteger
{
    PMTextFieldTypeNone               = 0,
    PMTextFieldTypeCardAccountHolder  = 1,
    PMTextFieldTypeCardNumber         = 2,
    PMTextFieldTypeExpDate            = 3,
    PMTextFieldTypeCVC                = 4,
    PMTextFieldTypeAccountHolder      = 5,
    PMTextFieldTypeIBANNumber         = 6,
    PMTextFieldTypeBIC                = 7,
}PMTextFieldType;

/**************************************/
#pragma mark -
/**************************************/
@protocol PMPaymentDataValidatorUIRepresentationDelegate;

/**************************************/
#pragma mark - Class Interface
/**************************************/
@interface PMPaymentDataValidator:NSObject <UITextFieldDelegate>

@property (nonatomic, assign) PMPaymentDataType paymentDataType;

@property (nonatomic, strong, readonly) NSString* accountHolderStr;
@property (nonatomic, strong, readonly) NSString* ibanStr;
@property (nonatomic, strong, readonly) NSString* cardNumberStr;
@property (nonatomic, strong, readonly) NSString* bicStr;
@property (nonatomic, strong, readonly) NSString* cvcStr;
@property (nonatomic, strong, readonly) NSString* expiryMonth;
@property (nonatomic, strong, readonly) NSString* expiryYear;


- (void)registerDelegate:(id<PMPaymentDataValidatorUIRepresentationDelegate>)delegate;
- (void)unregisterDelegate:(id<PMPaymentDataValidatorUIRepresentationDelegate>)delegate;
- (void)validateObject;
- (NSString*)dateString;

@end

/*************************************************************/
#pragma mark - PMPaymentDataValidatorUIRepresentationDelegate
/*************************************************************/
@protocol PMPaymentDataValidatorUIRepresentationDelegate <NSObject>

@optional
- (void)paymentDataValidator:(PMPaymentDataValidator*)paymentDataValidator didRecognizeCCNumberWithImageName:(NSString*)imageName;
- (void)paymentDataValidator:(PMPaymentDataValidator*)paymentDataValidator didChangeActiveTextField:(UITextField*)textField;
- (void)paymentDataValidator:(PMPaymentDataValidator*)paymentDataValidator didCheckDateExpiration:(BOOL)isExpired;
- (void)paymentDataValidator:(PMPaymentDataValidator*)paymentDataValidator didValidateObjectWithError:(NSError*)error;
- (NSString*)paymentDataValidator:(PMPaymentDataValidator*)paymentDataValidator didChangeDateExpiratioTextFieldValue:(UITextField*)textField;

@end