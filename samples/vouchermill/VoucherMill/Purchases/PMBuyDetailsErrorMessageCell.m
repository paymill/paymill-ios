//
//  PMBuyDetailsErrorMessageCell.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/15/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMBuyDetailsErrorMessageCell.h"

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMBuyDetailsErrorMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellMessage;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMBuyDetailsErrorMessageCell

@synthesize titleText, cellText, font;

+ (CGSize)labelSizeForText:(NSString*)text
                  maxWidth:(CGFloat)width
{
    CGSize maximumSize = CGSizeMake(width, 10000);
    CGSize labelHeightSize = [text sizeWithFont:[UIFont systemFontOfSize:20.0f]
                             constrainedToSize:maximumSize
                                 lineBreakMode:NSLineBreakByWordWrapping];
    labelHeightSize.height = MAX(labelHeightSize.height, 44.0);
    return labelHeightSize;
}

/**************************************/
#pragma mark - Init
/**************************************/
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

/**************************************/
#pragma mark -
/**************************************/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIFont* labelFont = [UIFont boldSystemFontOfSize:15.0f];
    
    self.cellTitle.font = labelFont;
    self.cellMessage.font = labelFont;
    self.cellTitle.textColor = [UIColor whiteColor];
    self.cellMessage.textColor = [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0];
}

/**************************************/
#pragma mark -
/**************************************/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.cellTitle.text = self.titleText;
    self.cellMessage.text = self.cellText;
    
    CGRect frame = self.cellMessage.frame;
    frame.size.height = [PMBuyDetailsErrorMessageCell labelSizeForText:self.cellText
                                              maxWidth:CGRectGetWidth(self.cellMessage.bounds)].height;
    self.cellMessage.frame = frame;
}

@end
