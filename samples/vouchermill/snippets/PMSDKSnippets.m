//
//  PMSDKSnippets.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/30/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMSDKSnippets.h"
#import <PayMillSDK/PMSDK.h>
#import "PMDataBaseManager.h"
#import "PMVoucher.h"
#import "PMVoucherUtils.h"
#import "PMConstants.h"

@implementation PMSDKSnippets

-(void)generateTokenWithPublicKeySnippet {
	
	NSError *error;
	PMPaymentParams *params;
	id paymentMethod = [PMFactory genCardPaymentWithAccHolder:@"Max Musterman" cardNumber:@"4711100000000000" expiryMonth:@"12" expiryYear:@"2014"
												 verification:@"333" error:&error];
	
	if(!error) {
		params = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:100 description:@"Description" error:&error];
	}
	
	if(!error) {
		[PMManager generateTokenWithPublicKey:myPublicKey testMode:YES method:paymentMethod parameters:params
		success:^(NSString *token) {
			//token successfully created
		}
		failure:^(NSError *error) {
			//token generation failed
		}];
	}
}

-(void)createTransactionSnippet {
	//init with PAYMILL public key
	[PMManager initWithTestMode:YES merchantPublicKey:myPublicKey newDeviceId:nil init:^(BOOL success, NSError *error) {
        if(success) {
            // init successfull
            // start using the SDK
		}
    }];
	
	NSError *error;
	PMPaymentParams *params;
	id paymentMethod = [PMFactory genCardPaymentWithAccHolder:@"Max Musterman" cardNumber:@"4711100000000000" expiryMonth:@"12" expiryYear:@"2014"
												 verification:@"333" error:&error];
	
	if(!error) {
		params = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:100 description:@"Description" error:&error];
	}
	
	if(!error) {
		[PMManager transactionWithMethod:paymentMethod parameters:params consumable:YES
								 
		success:^(PMTransaction *transaction) {
			// transaction successfully created
		}
		failure:^(NSError *error) {
			// transaction creation failed
		}];
	}
}

-(void)recoverWithTransactionId:(NSString *)transactionId andVoucher:(PMVoucher *)voucher {
	if (nil == [[PMDataBaseManager instance] findVoucherByTransactionId:transactionId andCompletionHandler:nil]) {
		//we haven't saved this transaction yet
		[[PMDataBaseManager instance] insertNewOfflineVoucherWithVoucher:voucher andCompletionHandler:^(NSError *error) {
			
			if(error) {
				[PMVoucherUtils showErrorAlertWithTitle:@"Error inserting offline voucher" errorType:INTERNAL	errorMessage:error.description];
			}
			else {
				//transaction saved, now consume the transaction
				[PMManager consumeTransactionForId:transactionId success:^(NSString *id) {
					//
				} failure:^(NSError *error) {
					//
				}];
			}
		}];
	}
}

@end
