//
//  PMUISupport.m
//  VoucherMill
//
//  Created by gabi on 3/19/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMUISupport.h"

@implementation PMUISupport

+ (void)showYesNOAlertWithMessage:(NSString*)message tag:(NSInteger)tag andDelegate:(id<UIAlertViewDelegate>)delegate;
{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:kPMStringNo
                                          otherButtonTitles:kPMStringYes, nil];
    alert.tag = tag;
    
    [alert show];
}

+ (void)showPasswordAlertWithMessage:(NSString *)message tag:(NSInteger)tag andDelegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:kPMStringForgot
                                          otherButtonTitles:kPMStringOk, nil];
    alert.tag = tag;
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

+ (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:kPMStringOk
                                          otherButtonTitles:nil];
    
    [alert show];
}

+ (void)showErrorAlertWithMessage:(NSString *)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:kPMStringOk
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
