//
//  PMPaymentParams.h
//  PayMillSDK
//
//  Created by PayMill on 3/1/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
/**
 Object representing the parameters needed to create new Transactions and Preauthorizations. Never extend this interface yourself, instead use the static methods in PMFactory.
 */
#import <Foundation/Foundation.h>
#import "PMError.h"

@interface PMPaymentParams : NSObject
/**
 Three character ISO 4217 formatted currency code.
 */
@property(nonatomic, strong) NSString *currency;
/**
 amount (in cents) which will be charged
 */
@property(nonatomic) int amount;
/**
 a short description for the transaction (e.g. shopping cart ID) or empty string or null.
 */
@property(nonatomic, strong) NSString *description;
/**
 Use this method to generate the PaymentParams object, needed for creating transactions, preauthorizations and tokens.
 @param currency Three character ISO 4217 formatted currency code.
 @param amount amount (in cents) which will be charged
 @param description	a short description for the transaction (e.g. shopping cart ID) or empty string or null.
 Note: You don't need to supply a description parameter when generating a token
 @param error PMError object
 @return PMPaymentParams successfully created object
 */
+ (PMPaymentParams*)paymentParamsWithCurrency:(NSString*)currency amount:(int)amount description:(NSString*)description error:(NSError **)error;

@end
