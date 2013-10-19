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

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [loginButton setTitle:loginButtonTitle forState:UIControlStateNormal];
    [loginButton setTag:loginButtonTag];
    [loginButton setAutoresizingMask:UIViewAutoresizingNone];
    UIColor *color = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    [loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateHighlighted];
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setBorderWidth:2.0f];
    [loginButton.layer setBorderColor:color.CGColor];
    [loginButton.layer setCornerRadius:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
