//
//  PMPaymentViewController.h
//  VoucherMill
//
//  Created by PayMill on 3/26/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayMillSDK/PMSDK.h>
#import "PMPaymentView.h"

typedef NS_ENUM(NSInteger, PMPaymentType)
{
    TOKEN,
    TRANSACTION,
    PREAUTHORIZATION,
    TOKEN_WO_INIT   //GenetareTokenWithPublicKey
};

//Block callbacks
typedef void(^OnCompletionSuccess)(id);
typedef void(^OnCompletionFailure)(NSError *);


/**
 This class is used to set different settings for screen according to payment requirements
 */
@interface PMSettings : NSObject

/**
 paymentType
 */
@property(nonatomic) PMPaymentType paymentType;

/**
 All credit cards are allowed.
 */
+ (id)settingsWithPaymentType:(PMPaymentType)type directDebitCountry:(NSString*)ddCountry testMode:(BOOL)testMode safeStoreEnabled:(BOOL)enabled andConsumable:(BOOL)consumable;

/**
 Disables all credit card types
 */
- (void)disableAllCreditCards;
/**
 Enables all credit card types
 */
- (void)enableAllCreditCards;
/**
 Enables a specific credit card type.
 */
- (void)enableCreditCardType:(NSString*)cardType;
/**
 Disables a credit card type
 */
- (void)disableCreditCardType:(NSString*)cardType;
/**
 Convenience method for pre-filling the payment screens. This is usefull for integrating card scanning services.
 @param accHolder account holder.
 @param cardNumber credit card number.
 @param expiryMonth expiration month.
 @param expiryYear expiration year.
 @param verification credit card verification code.
 */
-(void)prefillCreditCardDataWithAccHolder:(NSString*)accHolder cardNumber:(NSString*)cardNumber expiryMonth:(NSString*) expiryMonth expiryYear:(NSString*)expiryYear verification:(NSString*)verification;
@end


/**************************************/
#pragma mark -
/**************************************/
@interface PMPaymentViewController : UIViewController <UITextFieldDelegate, PMPaymentDataValidatorUIRepresentationDelegate, UIAlertViewDelegate>

/**
 Designated initializers for creating PMPaymentViewController.
 @param params PMPaymentParams created with PMFactory.
 @param publicKey Paymill merchant public key.
 @param settings Style settings.
 @param success a block callback that is executed when the requested Paymill operation returns success.
 @param failure a block callback that is executed when the requested Paymill operation returns error.
 */
- (PMPaymentViewController *)initWithParams:(PMPaymentParams*)pmParams publicKey:(NSString *)pubKey settings:(PMSettings *)pmSettings style:(PMStyle *)pmStyle success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (PMPaymentViewController *)initWithParams:(PMPaymentParams*)pmParams publicKey:(NSString *)pubKey settings:(PMSettings *)pmSettings success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end

