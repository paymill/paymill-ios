//
//  PMBuyDetailsErrorMessageCell.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/15/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMBuyDetailsErrorMessageCell.h"

@interface PMBuyDetailsErrorMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellMessage;

@end

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
    self.cellTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    self.cellTitle.text = self.titleText;
    self.cellTitle.textColor = [UIColor whiteColor];
    
    self.cellMessage.font = [UIFont boldSystemFontOfSize:15.0f];
    self.cellMessage.text = self.cellText;
    self.cellMessage.textColor = [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0];
    
    CGRect frame = self.cellMessage.frame;
    frame.size.height = [PMBuyDetailsErrorMessageCell labelSizeForText:self.cellText
                                              maxWidth:CGRectGetWidth(self.cellMessage.bounds)].height;
    self.cellMessage.frame = frame;
}

@end
