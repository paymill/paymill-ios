//
//  PMPaymentMethodsListViewController.h
//  VoucherMill
//
//  Created by gabi on 3/14/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayMillSDK/PMSDK.h>
#import "PMPaymentViewController.h"

//Block callbacks

typedef void(^OnPaymentListSuccess)(id);
typedef void(^OnPaymentListFailure)(NSError *);

/**************************************/
#pragma mark - Class Interface
/**************************************/
@interface PMPaymentMethodsListViewController : UIViewController <UIAlertViewDelegate>

- (PMPaymentMethodsListViewController *)initWithParams:(PMPaymentParams*)pmParams
                                     paymentsArr:(NSArray *)payments
                                      pmSettings:(PMSettings *)settings
                                    successBlock:(void (^)(id))success
                                 andFailureBlock:(void (^)(NSError *))failure;

- (void)setSafestorePassword:(NSString*)password;

@end