//
//  PMLoginTextFieidCell.m
//  VoucherMill
//
//  Created by Oleg Ivanov on 7/3/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMLoginTextFieldCell.h"
@interface PMLoginTextFieldCell ()

@property (nonatomic, weak) IBOutlet UITextField *publicKey;
@property (strong, nonatomic) UIToolbar *keyBar;

@end

@implementation PMLoginTextFieldCell

@synthesize publicKey, keyBar, delegate;

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
    [publicKey setBorderStyle:UITextBorderStyleRoundedRect];
    [publicKey setAutoresizingMask:UIViewAutoresizingNone];
    [publicKey setFont:[UIFont systemFontOfSize:15.0]];
    [publicKey setTextColor:[UIColor blackColor]];
    [publicKey setTextAlignment:NSTextAlignmentCenter];
    [publicKey setBackgroundColor:[UIColor clearColor]];
    publicKey.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIColor *color = [[UIColor alloc]initWithRed:149/255.0f green:0/255.0f  blue:11/255.0f alpha:1 ];
    publicKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your public key here" attributes:@{NSForegroundColorAttributeName: color}];
    
    // Do any additional setup after loading the view
    //Create Prev/Next+Done tab bar to keyboard
    self.keyBar = [[UIToolbar alloc] init];
    [self.keyBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.keyBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyBoard)];
    
    NSArray *itemArray = [NSArray arrayWithObjects:doneButton, nil];
    
    [keyBar setItems:itemArray];
    
    [publicKey setInputAccessoryView:keyBar];
    
    publicKey.delegate = self;
    
    publicKey.keyboardType = UIKeyboardAppearanceDefault;
    
    publicKey.keyboardAppearance = UIKeyboardAppearanceDefault;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

-(void)resignKeyBoard {
    [delegate loginText:publicKey.text];
	[self textFieldShouldReturn:self.publicKey];
}

@end
