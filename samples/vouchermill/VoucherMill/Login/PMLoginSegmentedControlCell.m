//
//  PMLoginSegmentedControlCell.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/3/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMLoginSegmentedControlCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PMLoginSegmentedControlCell ()
@property (nonatomic, strong) NSMutableArray *loginSegments;
@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentedControl;

@end
@implementation PMLoginSegmentedControlCell

@synthesize loginSegments, segmentedControl, PMMode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)layoutSubviews
{
    [segmentedControl setAutoresizingMask:UIViewAutoresizingNone];
    UIColor *borderColor = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, color, UITextAttributeTextColor,nil];
    [segmentedControl setTitleTextAttributes:attrs forState:UIControlStateNormal];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedControl setDividerImage:[UIImage imageNamed:@"divider_selected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl.layer setMasksToBounds:YES];
    [segmentedControl.layer setBorderWidth:2.0f];
    [segmentedControl.layer setBorderColor:borderColor.CGColor];
    [segmentedControl.layer setCornerRadius:10.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
