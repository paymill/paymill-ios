//
//  PMPreauthorization.h
//  PayMillSDK
//
//  Created by PayMill on 3/20/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
#import "PMPayment.h"
#import "PMClient.h"
/**
 This object represents Preauthorization PayMill API Object.
 */
@interface PMPreauthorization : NSObject
/**
 id
 */
@property(nonatomic, strong) NSString *id;
/**
 amount
 */
@property(nonatomic, strong) NSString *amount;
/**
 currency
 */
@property(nonatomic, strong) NSString *currency;
/**
 status
 */
@property(nonatomic, strong) NSString *status;
/**
 livemode
 */
@property(nonatomic) bool livemode;
/**
 created_at
 */
@property(nonatomic, strong) NSString *created_at;
/**
 updated_at
 */
@property(nonatomic, strong) NSString *updated_at;
/**
 PMPayment payment
 */
@property(nonatomic, strong) PMPayment *payment;
/**
 PMClient client
 */
@property(nonatomic, strong) PMClient *client;
@end
