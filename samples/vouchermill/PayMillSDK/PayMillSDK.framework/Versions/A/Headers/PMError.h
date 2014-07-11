//
//  PMError.h
//  PayMillSDK
//
//  Created by PayMill on 2/20/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 NSError object is returned in every unsuccessful asynchronous callback by the SDK. There are several types of this error.
 A detail message may also exist.
 All enums and constants below are related to how-to use the NSError message returned from the PAYMILL SDK.
 */


/**
 PAYMILL error domain
 */
FOUNDATION_EXPORT NSString * const PMErrorDomain;

/**
 Error type
 */

typedef enum PMErrorType : NSInteger
{
    UNKNOWN          = 0, /*Initial value*/
	WRONG_PARMETERS  = 1, /*You have supplied wrong parameters. You use message for details.*/
	HTTP_CONNECTION  = 2, /*There was an error while connecting to the PayMill Service.*/
	API              = 3, /*The PAYMILL API returned an unexpected result.*/
    SAFESTORE        = 4, /*The PAYMILL safe store returned an error. Check the PMSafeStoreErrorCodeKey in the user info dictionary for the specific error. */
	BRIDGE           = 5, /*The PAYMILL JS-Bridge returned an a payment method related error code. Check the PMBridgeErrorCodeKey in the user info dictionary for the specific error. */
	NOT_INIT         = 6, /*You did not initialize the SDK.*/
	INTERNAL         = 7, /*This should never happen. If you encounter it, please send email support@paymill.com .*/
}PMErrorType;


/*
PAYMILL API developers message
 */
FOUNDATION_EXPORT NSString * const PMErrorMessageKey;

/*
 PAYMILL SAFESTORE will have an PMSafeStoreErrorCodeKey in the userInfo dictionary.  This gives more information about the error type and could be handled to create user messages.
 */
FOUNDATION_EXPORT NSString * const PMSafeStoreErrorCodeKey;
/*
 PAYMILL BRIDGE will have an PMBridgeErrorCodeKey in the userInfo dictionary.  This gives more information about the error type and could be handled to create user messages.
 */
FOUNDATION_EXPORT NSString * const PMBridgeErrorCodeKey;

/*
 These are possible values for the PMBridgeErrorCodeKey in the userInfo dictionary
 of an NSError returned by this library. These error keys might be returned after an unsuccessfull try to generate a token from the PAYMILL BRIDGE  */

/**
For credit cards: invalid card number. For direct debit: invalid account number.
*/
FOUNDATION_EXPORT NSString * const PMInvalidNumber;
/**
 For credit cards: invalid cardholder. For direct debit: invalid account holder
 */
FOUNDATION_EXPORT NSString * const PMInvalidHolder;

/**
 These values will be returned for invalid credit card relevant fields 
 */
FOUNDATION_EXPORT NSString * const PMCCInvalidCVC;
FOUNDATION_EXPORT NSString * const PMCCInvalidExp;
FOUNDATION_EXPORT NSString * const PMCCInvalidExpYear;
FOUNDATION_EXPORT NSString * const PMCCInvalidExpMonth;
FOUNDATION_EXPORT NSString * const PMUnknownError;


/*
 These are possible values for the PMSafeStoreErrorCodeKey in the userInfo dictionary
 of an NSError returned by this library. These error keys might be returned when user entered his password incorrectly */
FOUNDATION_EXPORT NSString * const PMSafeStoreIncorrectPassword;
FOUNDATION_EXPORT NSString * const PMSafeStoreBlocked;
