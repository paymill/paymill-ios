//
//  PMPaymentViewController.h
//  VoucherMill
//
//  Created by PayMill on 3/26/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayMillSDK/PMSDK.h>

/**
 * The type of credit card that is supported.
 */
typedef NS_ENUM(NSInteger, PMCardTypes) {
    ALL,
    CC_AMEX,
    CC_DISCOVER,
    CC_UNIONPAY,
    CC_DINERSCLUB,
    CC_INSTAPAYMENT,
    CC_JCB,
    CC_LASER,
    CC_MAESTRO,
    CC_MASTERCARD,    
    CC_VISA,
    CC_INVALID,
	DD_DE,
};
/**
 * The type of payment that should be triggered.
 */
typedef NS_ENUM(NSInteger, PMPaymentType)
{
    TOKEN,
    TRANSACTION,
    PREAUTHORIZATION,
    TOKEN_WO_INIT   //GenetareTokenWithPublicKey
};

typedef NS_ENUM(NSInteger, PMInputFields)
{
    NONE,
    ACCOUNT_HOLDER,
    ACCOUNT_NUMBER,
    BANK_CODE,
    CARD_ACCOUNT_HOLDER,
    CARD_NUMBER,
    EXP_DATE,
    CVV
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
 directDebitCountry
 */
@property(nonatomic, strong) NSString *directDebitCountry;
/**
 isTestMode
 */
@property (nonatomic) BOOL isTestMode;
/**
 consumable
 */
@property (nonatomic) BOOL consumable;
/**
 cardTypes
 */
@property NSArray *cardTypes;
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

@end

/**
 This is PayMill Payment Screen view controller
 */
@interface PMPaymentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

/**
 Designated initializer for creating PMPaymentViewController.
 @param params PMPaymentParams created with PMFactory.
 @param publicKey Paymill merchant public key.
 @param settings Style settings.
 @param success a block callback that is executed when the requested Paymill operation returns success.
 @param failure a block callback that is executed when the requested Paymill operation returns error.
 */
-(PMPaymentViewController *)initWithParams:(PMPaymentParams*)pmParams publicKey:(NSString *)pubKey settings:(PMSettings *)pmSettings style:(PMStyle *)pmStyle success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
