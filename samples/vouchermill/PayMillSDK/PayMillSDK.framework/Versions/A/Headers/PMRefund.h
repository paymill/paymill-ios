//
//  PMRefund.h
//  PayMillSDK
//
//  Created by PayMill on 3/20/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
/**
 This object represents Refund PayMill API Object.
 */
@interface PMRefund : NSObject
/**
 id
 */
@property(nonatomic, strong)    NSString *id;
/**
 amount
 */
@property(nonatomic, strong)    NSString *amount;
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

@end
