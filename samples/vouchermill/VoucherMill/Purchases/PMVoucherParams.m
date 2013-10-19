//
//  PMVoucherParams.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 5/9/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMVoucherParams.h"

@implementation PMVoucherParams

@synthesize action;
@synthesize voucherValue;
@synthesize currency;
@synthesize description;
@synthesize publicKey;
@synthesize isTestMode;
static PMVoucherParams *params = nil;

+(PMVoucherParams*) instance
{
    //Singleton pattern
    //Static local predicate must be initialized to 0
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        params = [[PMVoucherParams alloc] init];
    });
    
    return params;
}
@end
