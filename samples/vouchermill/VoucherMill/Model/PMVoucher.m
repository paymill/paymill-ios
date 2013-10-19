//
//  Voucher.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 6/27/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMVoucher.h"

@implementation PMVoucher

@synthesize voucherImage,voucherType, isCreditCard, voucherAccount, voucherAmount, voucherBankCode, voucherBigImage, voucherCreationDate, voucherCreditCardNumber, voucherCreditCardType, voucherCurrency, voucherDescrpition, voucherStatus, transactionId;

- (id)initWithVoucherAmount:(NSString *)aVoucherAmount andCurrency:(NSString *)aVoucherCurrency andImage:(UIImage *)aVoucherImage andBigImage:(UIImage *)aVoucherBigImage andDescription:(NSString *)aVoucherDescrpition andDate:(NSString *) aVoucherCreationDate andStatus:(NSString *) aVoucherStatus andIsCreditCard:(BOOL) aIsCreditCard andCreditCardNumber:(NSString *)aVoucherCreditCardNumber andCreditCardType:(NSString *)aVoucherCreditCardType andVoucherAccount:(NSString *)aVoucherAccount andVoucherBankCode:(NSString *)aVoucherBankCode
{
    self = [super init];
    if (self) {
        self.voucherAmount = aVoucherAmount;
        self.voucherCurrency = aVoucherCurrency;
        self.voucherImage = aVoucherImage;
        self.voucherBigImage = aVoucherBigImage;
        self.voucherDescrpition = aVoucherDescrpition;
        self.voucherCreationDate = aVoucherCreationDate;
        self.voucherStatus = aVoucherStatus;
        self.isCreditCard = aIsCreditCard;
        self.voucherCreditCardNumber = aVoucherCreditCardNumber;
        self.voucherCreditCardType = aVoucherCreditCardType;
        self.voucherAccount = aVoucherAccount;
        self.voucherBankCode = aVoucherBankCode;
    }
    return self;
}

@end
