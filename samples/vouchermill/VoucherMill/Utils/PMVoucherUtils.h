//
//  PMVoucherUtils.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMVoucher.h"
#import <PayMillSDK/PMSDK.h>
#import "Constants.h"
#import "OfflineVoucher.h"
@interface PMVoucherUtils : NSObject
+(NSString*)timeStampAsString:(NSInteger)timestamp;
+(PMVoucher *)voucherFromPMObject:(id)pmObject;
+(PMVoucher *)voucherFromOfflineVoucher:(OfflineVoucher *)offlineVoucher;
+(void)showErrorAlertWithTitle:(NSString*)title errorType:(PMErrorType)type errorMessage:(NSString*)message;
@end
