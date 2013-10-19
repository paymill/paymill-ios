//
//  PMVoucherUtils.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMVoucherUtils.h"

@implementation PMVoucherUtils
+(NSString*)timeStampAsString:(NSInteger)timestamp {
	NSDate *createdAtDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSDateFormatter *formatter;
	NSString        *dateString;
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
	dateString = [formatter stringFromDate:createdAtDate];
	return dateString;
}
+(PMVoucher *)voucherFromPMObject:(id)pmObject {
	PMVoucher *voucher;
	UIImage *image;
	UIImage *bigImage;
	NSString *desc = @"preauth";
	NSString *currency;
	NSString *amount;
	NSString *status;
	NSString *createdAt;
	NSString *creditCardNumber;
	NSString *creditCardType;
	NSString *account;
	NSString *bankCode;
	
	if([pmObject isKindOfClass:[PMPreauthorization class]]) {
		currency = ((PMPreauthorization *)pmObject).currency;
		amount = ((PMPreauthorization *)pmObject).amount;
		status = ((PMPreauthorization *)pmObject).status;
		createdAt = createdAt = [PMVoucherUtils timeStampAsString:((PMPreauthorization *)pmObject).created_at.intValue];
		creditCardNumber = ((PMPreauthorization *)pmObject).payment.last4;
		creditCardType = ((PMPreauthorization *)pmObject).payment.card_type;
		account = ((PMPreauthorization *)pmObject).payment.account;
		bankCode = ((PMPreauthorization *)pmObject).payment.code;
	} else if([pmObject isKindOfClass:[PMTransaction class]]) {
		desc = ((PMTransaction *)pmObject).description;
		currency = ((PMTransaction *)pmObject).currency;
		amount = ((PMTransaction *)pmObject).amount;
		status = ((PMTransaction *)pmObject).status;
		createdAt = [PMVoucherUtils timeStampAsString:((PMTransaction *)pmObject).created_at];
		creditCardNumber = ((PMTransaction *)pmObject).payment.last4;
		creditCardType = ((PMTransaction *)pmObject).payment.card_type;
		account = ((PMTransaction *)pmObject).payment.account;
		bankCode = ((PMTransaction *)pmObject).payment.code;
	}
	else {
		return nil;
	}
	if([desc isEqualToString:@"preauth"]) {
		image = [UIImage imageNamed:kCustom];
		bigImage = [UIImage imageNamed:kCustomBig];
	}
	else if([desc isEqualToString:kTickets]) {
		image = [UIImage imageNamed:kTickets];
		bigImage = [UIImage imageNamed:kTicketsBig];
	}
	else if([desc isEqualToString:kBurger]) {
		image = [UIImage imageNamed:kBurger];
		bigImage = [UIImage imageNamed:kBurgerBig];
	}
	else if([desc isEqualToString:kTyre]) {
		image = [UIImage imageNamed:kTyre];
		bigImage = [UIImage imageNamed:kTyreBig];
	}
	else if([desc isEqualToString:kCustom]){
		image = [UIImage imageNamed:kCustom];
		bigImage = [UIImage imageNamed:kCustomBig];
	}
	
	voucher = [[PMVoucher alloc] initWithVoucherAmount:amount andCurrency:currency andImage:image andBigImage:bigImage andDescription:desc andDate:createdAt andStatus:status /*only temporary!!!*/andIsCreditCard:YES andCreditCardNumber:creditCardNumber andCreditCardType:creditCardType andVoucherAccount:account andVoucherBankCode:bankCode];
	
	if([pmObject isKindOfClass:[PMTransaction class]]){
		voucher.transactionId = ((PMTransaction *)pmObject).id;
	}
	
	return voucher;
}

+(PMVoucher *)voucherFromOfflineVoucher:(OfflineVoucher *)offlineVoucher {
	UIImage *image;
	UIImage *bigImage;
	NSString *currency = offlineVoucher.currency;
	NSString *amount = offlineVoucher.amount;
	NSString *desc = offlineVoucher.descript;
	
	if([desc isEqualToString:kTickets]) {
		image = [UIImage imageNamed:kTickets];
		bigImage = [UIImage imageNamed:kTicketsBig];
	}
	else if([desc isEqualToString:kBurger]) {
		image = [UIImage imageNamed:kBurger];
		bigImage = [UIImage imageNamed:kBurgerBig];
	}
	else if([desc isEqualToString:kTyre]) {
		image = [UIImage imageNamed:kTyre];
		bigImage = [UIImage imageNamed:kTyreBig];
	}
	else if([desc isEqualToString:kCustom]){
		image = [UIImage imageNamed:kCustom];
		bigImage = [UIImage imageNamed:kCustomBig];
	}
	
	PMVoucher* voucher = [[PMVoucher alloc] initWithVoucherAmount:amount andCurrency:currency andImage:image andBigImage:bigImage andDescription:desc andDate:nil andStatus:nil /*only temporary!!!*/andIsCreditCard:YES andCreditCardNumber:nil andCreditCardType:nil andVoucherAccount:nil andVoucherBankCode:nil];
	
	return voucher;
}

+(void)showErrorAlertWithTitle:(NSString*)title errorType:(PMErrorType)type errorMessage:(NSString*)message {
	
	UIAlertView *plistAlert = [[UIAlertView alloc]
							   initWithTitle:[NSString stringWithFormat:@"%@ %d", title, type]
							   message:message
							   delegate:nil
							   cancelButtonTitle:nil
							   otherButtonTitles:@"OK",nil];
	[plistAlert show];
	
}

@end
