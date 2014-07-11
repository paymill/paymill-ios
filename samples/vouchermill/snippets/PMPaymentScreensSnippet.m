//
//  PMPaymentScreensSnippet.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/30/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMPaymentScreensSnippet.h"
#import <PayMillSDK/PMSDK.h>
#import "PMPaymentViewController.h"
#import "PMConstants.h"

NSString *currency = @"EU";
NSInteger amount = 100;
NSString *description = @"product description";
BOOL isTestMode = YES;
BOOL safeStoreEnabled = YES;
BOOL isAutoConsumed = YES;

@implementation PMPaymentScreensSnippet
-(void)createTokenWithPaymentScreenSnippet {
	NSError *error;
	//set payment view settings
	id pmViewSettings = [PMSettings settingsWithPaymentType:TOKEN directDebitCountry:@"DE" testMode:YES safeStoreEnabled:YES andConsumable:isAutoConsumed];
    
	//Create payment parameters
	id params = [PMFactory genPaymentParamsWithCurrency:@"EU" amount:100 description:@"Desc" error:&error];
	
	
	
	//check for errors
	if(!error){
		//create the payment view controller
        id payViewNav = [[PMPaymentViewController alloc] initWithParams:params
														   publicKey:myPublicKey
															settings:pmViewSettings
															   style:[self customStyle]
					  
															 success:^(id resObject) {
															     //show succes screen
															 }
					  
															 failure:^(NSError *error) {
																//show failure screen
															 }];
    //present the payment view controller
	UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:payViewNav];
		[self presentViewController:navCtrl animated:YES completion:nil];
	}
}

#pragma mark - PMStyle
- (PMStyle*)customStyle
{
    UIColor *mainColor = [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0];
	PMStyle* style = [PMStyle new];
    style.backgroundColor = [UIColor whiteColor];
    style.navbarColor = [UIColor whiteColor];
    style.inputFieldTextColor = [UIColor darkTextColor];
    style.inputFieldBackgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1];
    style.inputFieldTitleColor = mainColor;
    style.inputFieldBorderColor = [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0];
    style.inputFieldBorderWidth = 2.0;
    style.inputFieldBorderStyle = UITextBorderStyleRoundedRect;
    style.inputFieldCornerRadius = 8.0;
    style.inputFieldConfirmColor = [UIColor darkTextColor];
    style.inputFieldWrongColor = [UIColor redColor];
    style.buttonBackgroundColor = mainColor;
    style.buttonTitleColor = [UIColor whiteColor];
    style.segmentColor = [UIColor whiteColor];
    
    return style;
}

@end
