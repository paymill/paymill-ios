//
//  Voucher.h
//  VoucherMill
//
//  Created by Oleg Ivanov on 6/27/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VoucherStateType)
{
    Online,
    Offline,
    NotConsumed
};

@interface PMVoucher : NSObject

//@property (nonatomic, strong) Transaction *transaction;
@property (nonatomic) BOOL isCreditCard;
@property (nonatomic, strong) UIImage *voucherImage;
@property (nonatomic, strong) UIImage *voucherBigImage;
@property (nonatomic, strong) NSString *voucherAmount;
@property (nonatomic, strong) NSString *voucherCurrency;
@property (nonatomic, strong) NSString *voucherDescrpition;
@property (nonatomic, strong) NSString *voucherCreationDate;
@property (nonatomic, strong) NSString *voucherStatus;
@property (nonatomic, strong) NSString *voucherCreditCardNumber;
@property (nonatomic, strong) NSString *voucherCreditCardType;
@property (nonatomic, strong) NSString *voucherAccount;
@property (nonatomic, strong) NSString *voucherBankCode;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic) VoucherStateType voucherType;

- (id)initWithVoucherAmount:(NSString *)aVoucherAmount andCurrency:(NSString *)aVoucherCurrency andImage:(UIImage *)aVoucherImage andBigImage:(UIImage *)aVoucherBigImage andDescription:(NSString *)aVoucherDescrpition andDate:(NSString *) aVoucherCreationDate andStatus:(NSString *)aVoucherStatus andIsCreditCard:(BOOL) aIsCreditCard andCreditCardNumber:(NSString *)aVoucherCreditCardNumber andCreditCardType:(NSString *)aVoucherCreditCardType andVoucherAccount:(NSString *)aVoucherAccount andVoucherBankCode:(NSString *)aVoucherBankCode;

@end
