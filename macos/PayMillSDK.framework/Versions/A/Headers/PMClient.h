//
//  PMClient.h
//  PayMillSDK
//
//  Created by PayMill on 3/20/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
/**
 This object represents Client PayMill API Object.
 */
@interface PMClient : NSObject
/**
 id
 */
@property(nonatomic, strong) NSString *id;
/**
 email
 */
@property(nonatomic, strong) NSString *email;
/**
 description
 */
@property(nonatomic, strong) NSString *description;
/**
 created_at
 */
@property(nonatomic, strong) NSString *created_at;
/**
 updated_at
 */
@property(nonatomic, strong) NSString *updated_at;
/**
 payments
 */
@property(nonatomic, strong) NSArray *payments;
/**
 subscription
 */
@property(nonatomic, strong) NSString *subsctription;
@end
