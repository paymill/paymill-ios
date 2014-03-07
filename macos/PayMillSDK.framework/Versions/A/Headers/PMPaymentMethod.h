//
//  PMPaymentMethod.h
//  PayMillSDK
//
//  Created by PayMill on 1/25/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
/**
Object representing the payment method needed to create new Transactions and Preauthorizations. Never extend this interface yourself, instead use the static methods in PMFactory .
 */

#import <Foundation/Foundation.h>

@protocol PMPaymentMethod <NSObject>
- (NSString *) toUrlParams;
- (NSDictionary*)newDictionaryParams;
@end
