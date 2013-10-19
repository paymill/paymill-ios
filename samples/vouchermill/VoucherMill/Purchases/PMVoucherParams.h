//
//  PMPayParams.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 5/9/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMPaymentViewController.h"

@interface PMVoucherParams : NSObject
//@property (nonatomic) bool isPreuthorization;
@property (nonatomic) PMPaymentType action;
@property (nonatomic) int voucherValue;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) BOOL isTestMode;
+ (PMVoucherParams*) instance;
@end
