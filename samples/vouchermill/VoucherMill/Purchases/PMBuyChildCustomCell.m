//
//  PMBuyChildCustomCell.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 8/8/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMBuyChildCustomCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#define kLabelFontSize 14
@interface PMBuyChildCustomCell ()

@property (weak, nonatomic) IBOutlet UILabel *customValueLabel;
@property (strong, nonatomic) UIToolbar *keyBar;
@property (strong, nonatomic) UITextField *editedField;
@property (nonatomic) NSInteger lastSegmentIndex;

@end

@implementation PMBuyChildCustomCell

@synthesize customValue, customValueLabel, customValueLabelTitle, keyBar, editedField, lastSegmentIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //this method is never called with prototype cells with reuse identifiers
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [customValueLabel setTextColor:lightOrangeColor];
    [customValueLabel setFont:[UIFont boldSystemFontOfSize:kLabelFontSize]];
    [customValue setBorderStyle:UITextBorderStyleRoundedRect];
    [customValue setFont:[UIFont systemFontOfSize:15.0]];
    [customValue setTextColor:[UIColor blackColor]];
    [customValue setTextAlignment:NSTextAlignmentCenter];
    [customValue setBackgroundColor:[UIColor clearColor]];
    
    customValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIColor *color = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    customValue.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter custom value" attributes:@{NSForegroundColorAttributeName: color}];
    
    // Do any additional setup after loading the view
    //Create Prev/Next+Done tab bar to keyboard
    self.keyBar = [[UIToolbar alloc] init];
    [self.keyBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.keyBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    [segControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segControl.selectedSegmentIndex = -1;
    [segControl addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem* segButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    
    NSArray *itemArray = [NSArray arrayWithObjects:segButton, flexButton, doneButton, nil];
    
    [keyBar setItems:itemArray];
    
    [customValue setInputAccessoryView:keyBar];
    
    //customValue.delegate = self;
    
    customValue.keyboardType = UIKeyboardTypeDefault;
    
    keyBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}


-(void)layoutSubviews
{
	[super layoutSubviews];
    
    [customValueLabel setText:customValueLabelTitle];
}

-(void)segSelected:(id)sender
{
	UISegmentedControl *segCtlr = (UISegmentedControl *)sender;
	
    int newtag = (int)self.tag;
    if(segCtlr.selectedSegmentIndex == 1) {
        newtag += 1;
	}
    else {
        if(newtag > 0)
            newtag -= 1;
	}
	
	PMBuyChildCustomCell *nextCell  = (PMBuyChildCustomCell *)[self.superview viewWithTag:newtag];
	if([nextCell isKindOfClass:[PMBuyChildCustomCell class]]) {
		[nextCell.customValue becomeFirstResponder];
	}
	else {
		[self.customValue resignFirstResponder];
	}
	
    segCtlr.selectedSegmentIndex = -1;
	//lastSegmentIndex = segCtlr.selectedSegmentIndex;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyChildCustomCell:doneButtonWasSelected:)]) {
        [self.delegate buyChildCustomCell:self doneButtonWasSelected:sender];
    }
}

@end
