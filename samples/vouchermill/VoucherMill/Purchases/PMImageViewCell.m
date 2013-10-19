//
//  PMImageViewCell.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 8/22/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMImageViewCell.h"
@interface PMImageViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@end
@implementation PMImageViewCell

@synthesize image, customImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //this method is never called with prototype cells with reuse identifiers
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	[customImageView setImage:image];
}

@end
