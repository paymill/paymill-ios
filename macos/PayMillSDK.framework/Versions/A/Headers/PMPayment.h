//
//  PMPayment.h
//  PayMillSDK
//
//  Created by PayMill on 2/8/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
/**
 This object represents Payment PayMill API Object.
 */
@interface PMPayment : NSObject
/**
 id
 */
@property(nonatomic, strong) NSString *id;
/**
 type
 */
@property(nonatomic, strong) NSString *type;
/**
 client
 */
@property(nonatomic, strong) NSString *client;
/**
 card_type
 */
@property(nonatomic, strong) NSString *card_type;
/**
 country
 */
@property(nonatomic, strong) NSString *country;
/**
 expire_month
 */
@property(nonatomic, strong) NSString *expire_month;
/**
 expire_year
 */
@property(nonatomic, strong) NSString *expire_year;
/**
 card_holder
 */
@property(nonatomic, strong) NSString *card_holder;
/**
 last4
 */
@property(nonatomic, strong) NSString *last4;
/**
 created_at
 */
@property(nonatomic, strong) NSString *created_at;
/**
 updated_at
 */
@property(nonatomic, strong) NSString *updated_at;
/**
 code
 */
@property(nonatomic, strong) NSString *code;
/**
 holder
 */
@property(nonatomic, strong) NSString *holder;
/**
 account
 */
@property(nonatomic, strong) NSString *account;
/**
 bic
 */
@property(nonatomic, strong) NSString *bic;
/**
 iban
 */
@property(nonatomic, strong) NSString *iban;

@end
