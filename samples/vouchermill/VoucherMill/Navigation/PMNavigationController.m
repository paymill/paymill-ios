//
//  PMNavigationController.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/2/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMNavigationController.h"
#define lightOrangeColor [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0]

@interface PMNavigationController ()

@end

@implementation PMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
	UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, lightOrangeColor, UITextAttributeTextColor,nil];
    [self.navigationBar setTitleTextAttributes:attrs];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
