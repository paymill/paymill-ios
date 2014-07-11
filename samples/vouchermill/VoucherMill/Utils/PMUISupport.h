//
//  PMUISupport.h
//  VoucherMill
//
//  Created by gabi on 3/19/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PMAlertType : NSInteger
{
    PMAlertTypeNone                         = 0,
    PMAlertTypeEnterPassword                = 1,
    PMAlertTypeEnterPasswordForMethosList   = 2,
    PMAlertTypeSavePayment                  = 3,
    PMAlertTypeExistingPayment              = 4,
    PMAlertTypeDeletePayment                = 5
}PMAlertType;

@interface PMUISupport : NSObject

+ (void)showYesNOAlertWithMessage:(NSString*)message tag:(NSInteger)tag andDelegate:(id<UIAlertViewDelegate>)delegate;
+ (void)showPasswordAlertWithMessage:(NSString *)message tag:(NSInteger)tag andDelegate:(id<UIAlertViewDelegate>)delegate;;
+ (void)showAlertWithMessage:(NSString *)message;
+ (void)showErrorAlertWithMessage:(NSString *)message;

@end
