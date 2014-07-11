//
//  PMDebitCardView.h
//  VoucherMill
//
//  Created by gabi on 2/23/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPaymentView.h"

@interface PMCreditCardView : PMPaymentView <UIPickerViewDataSource, UIPickerViewDelegate>

+ (id)creditCardView;

@end
