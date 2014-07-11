//
//  PMLoginViewController.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/5/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMLoginViewController.h"
#import <PayMillSDK/PMSDK.h>
#import "PMVoucherParams.h"
#import <QuartzCore/QuartzCore.h>
#import "PMLoginTextFieldCell.h"
#import "PMLoginSegmentedControlCell.h"
#import "PMLoginButtonCell.h"
#import "PMPaymentViewController.h"
#import "PMVoucherParams.h"
#import "PMBuyContainerController.h"
#import "Constants.h"
#import "PMSettingsViewController.h"
#import "PMVoucherUtils.h"
#import "MBProgressHUD.h"

@interface PMLoginViewController ()

@property (nonatomic,weak) IBOutlet UITableView *loginTableView;
@property (nonatomic, strong) NSString *publicKeyLogin;
@property (nonatomic) BOOL isTestMode;
@property (nonatomic, strong) UITableViewController *tableViewController;

- (IBAction)showSettings:(id)sender;

@end

@implementation PMLoginViewController
@synthesize loginTableView, publicKeyLogin, isTestMode, tableViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
	
    loginTableView.rowHeight = 75.0f;
    publicKeyLogin = @"";
    isTestMode = YES;
}


- (void) keyboardWillShow:(NSNotification *)note {
	// move the view up by 120 pts
    CGRect frame = self.view.frame;
    frame.origin.y -= 120;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
	
    // move the view back to the origin
    CGRect frame = self.view.frame;
    frame.origin.y += 120;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginText:(NSString *)text {
    publicKeyLogin = text;
}

- (void)segmentedState:(NSInteger)state {
  
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if device is iPhone4
    if (self.view.frame.size.height == 416) {
        return 73.0f;
    } else {
        return 90.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    PMLoginTextFieldCell *firstCell;
    PMLoginSegmentedControlCell *secondCell;
    PMLoginButtonCell *otherCell;
    switch (indexPath.row) {
        case 0:
            otherCell = [loginTableView dequeueReusableCellWithIdentifier:@"testCell"
                                                                forIndexPath:indexPath];
            otherCell.loginButtonTitle = @"Test Log In";
            [otherCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            otherCell.loginButtonTag = 0;
            cell = otherCell;
            break;
            
        case 1:
            firstCell = [loginTableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
            [firstCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            firstCell.delegate = self;
            cell = firstCell;
            break;
        case 2:
            secondCell = [loginTableView dequeueReusableCellWithIdentifier:@"segmentedCell"];
            [secondCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell = secondCell;
            break;
        case 3:
            otherCell = [loginTableView dequeueReusableCellWithIdentifier:@"buttonCell"
                                                             forIndexPath:indexPath];
            otherCell.loginButtonTitle = @"Log In";
            [otherCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            otherCell.loginButtonTag = 1;
            cell = otherCell;
            break;
        case 4:
            otherCell = [loginTableView dequeueReusableCellWithIdentifier:@"buttonCell"
                                                             forIndexPath:indexPath];
            otherCell.loginButtonTitle = @"Generate Token";
            [otherCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            otherCell.loginButtonTag = 2;
            cell = otherCell;
            break;
        default:
            break;
    }
    
	return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:kGENERATETOKEN]) {
		PMBuyContainerController *dest = segue.destinationViewController;
		dest.isToken = YES;
		PMVoucherParams *params = [PMVoucherParams instance];
		params.action = TOKEN_WO_INIT;
		params.isTestMode = self.isTestMode;
	}
}


/**************************************/
#pragma mark - Validate method
/**************************************/
-(BOOL)isInputValid {
	return ([publicKeyLogin isEqualToString:@""] || [publicKeyLogin length] < 32) ? NO : YES;
}

/**************************************/
#pragma mark - Button actions
/**************************************/
- (IBAction)logIn:(UIButton *)sender {
    [PMVoucherParams instance].publicKey = publicKeyLogin;
	if (![self isInputValid]) {
		[PMVoucherUtils showErrorAlertWithTitle:@"Public Key Not Entered" errorType: WRONG_PARMETERS errorMessage:@"Enter public key with 32 symbols!"];
		return;
	}
    if (sender.tag == 1) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [PMManager initWithTestMode:isTestMode merchantPublicKey:publicKeyLogin newDeviceId:nil init:^(BOOL success, NSError *error) {
        		if(success){
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        			[self performSegueWithIdentifier:@"Dashboard" sender:sender];
        		}
        		else {
                    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        			UIAlertView *notAuthorized = [[UIAlertView alloc] initWithTitle:@"Authorization failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        			[notAuthorized show];
        		}
        	}];
    } else if (sender.tag == 2){
        //code for generate of token
		[PMVoucherParams instance].isTestMode = self.isTestMode;
		[self performSegueWithIdentifier:kGENERATETOKEN sender:sender];
    }

}

- (IBAction)segmentedSelected:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        isTestMode = YES;
    } else {
        isTestMode = NO;
    }
}

- (IBAction)testLogIn:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [PMManager initWithTestMode:YES merchantPublicKey:myPublicKey newDeviceId:nil init:^(BOOL success, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];

        if( success ) {
            [self performSegueWithIdentifier:@"Dashboard" sender:sender];
            [PMVoucherParams instance].publicKey = myPublicKey;
        }
        else {
            UIAlertView *notAuthorized = [[UIAlertView alloc] initWithTitle:@"Authorization failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notAuthorized show];
        }
    }];
}

- (IBAction)showSettings:(id)sender
{
    PMSettingsViewController* settingsViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"PMSettingsViewController"];
    [self.navigationController pushViewController:settingsViewCtrl animated:YES];
}

@end
