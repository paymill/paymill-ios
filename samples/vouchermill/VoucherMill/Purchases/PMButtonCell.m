//
//  PMButtonCell.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/5/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMButtonCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

@implementation PMButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateHighlighted];
    [self.submitButton.layer setMasksToBounds:YES];
    [self.submitButton.layer setBorderWidth:2.0f];
    [self.submitButton.layer setBorderColor:darkOrangeColor.CGColor];
    [self.submitButton.layer setCornerRadius:10.0f];
}

@end
