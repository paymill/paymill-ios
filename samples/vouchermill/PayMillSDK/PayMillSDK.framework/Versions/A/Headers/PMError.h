//
//  PMError.h
//  PayMillSDK
//
//  Created by PayMill on 2/20/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 PAYMILL error domain
 */
FOUNDATION_EXPORT NSString * const PMErrorDomain;

/**
 Error type
 */
typedef enum PMErrorType{
	WRONG_PARMETERS, /*You have supplied wrong parameters. You use message for details.*/
	HTTP_CONNECTION, /*There was an error while connecting to the PayMill Service.*/
	API, /*The PAYMILL API returned an unexpected result.*/
	BRIDGE, /*The PAYMILL JS-Bridge returned an a payment method related error code. For further code explanations, check */
	NOT_INIT, /*You did not initialize the SDK.*/
	INTERNAL, /*This should never happen. If you encounter it, please send email support@paymill.com .*/
}PMErrorType;


/*
PAYMILL API developers message
 */
FOUNDATION_EXPORT NSString * const PMErrorMessageKey;

/*
 PAYTMILL BRIDGE will have an PMBridgeErrorCodeKey
 in the userInfo dictionary.  This gives more information about the error type and could be handled to create user messages.
 */
FOUNDATION_EXPORT NSString * const PMBridgeErrorCodeKey;

/**
 This is the error object that is returned in every unsuccessful asynchronous callback. There are several types of this error. A detail message may also exist.
 */



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