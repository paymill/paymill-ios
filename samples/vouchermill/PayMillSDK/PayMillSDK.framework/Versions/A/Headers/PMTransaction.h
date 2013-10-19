//
//  PMTransaction.h
//  PayMillSDK
//
//  Created by PayMill on 2/5/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
#import "PMPreauthorization.h"
/**
 This object represents Transaction PayMill API Object.
 */
@interface PMTransaction : NSObject
/**
 id
 */
@property(nonatomic, strong)    NSString *id;
/**
 amount
 */
@property(nonatomic, strong)    NSString *amount;
/**
 origin_amount
 */
@property(nonatomic)            int origin_amount;
/**
 currency
 */
@property(nonatomic, strong)    NSString *currency;
/**
 status
 */
@property(nonatomic, strong)    NSString *status;
/**
 description
 */
@property(nonatomic, strong)    NSString *description;
/**
 livemode
 */
@property(nonatomic)            bool livemode;
/**
 refunds
 */
@property(nonatomic, strong)    NSArray *refunds;
/**
 created_at
 */
@property(nonatomic)            int created_at;
/**
 updated_at
 */
@property(nonatomic)            int updated_at;
/**
 response_code
 */
@property(nonatomic)            int response_code;
/**
 invoices
 */
@property(nonatomic, strong)    NSArray *invoices;
/**
 PMPayment payment
 */
@property(nonatomic, strong)    PMPayment *payment;
/**
 PMClient client
 */
@property(nonatomic, strong)    PMClient *client;
/**
 PMPreauthorization preauthorization
 */
@property(nonatomic, strong)    PMPreauthorization *preauthorization;

@end
