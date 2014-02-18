//
//  PMLoginButtonCell.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/3/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMLoginButtonCell.h"
#import <QuartzCore/QuartzCore.h>
@interface PMLoginButtonCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
@implementation PMLoginButtonCell

@synthesize loginButton, loginButtonTitle, loginButtonTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.loginButton setAutoresizingMask:UIViewAutoresizingNone];
    UIColor *color = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    [self.loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateHighlighted];
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton.layer setBorderWidth:2.0f];
    [self.loginButton.layer setBorderColor:color.CGColor];
    [self.loginButton.layer setCornerRadius:10.0f];
}

/**************************************/
#pragma mark -
/**************************************/
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.loginButton setTitle:self.loginButtonTitle forState:UIControlStateNormal];
    [self.loginButton setTag:self.loginButtonTag];
}

@end
