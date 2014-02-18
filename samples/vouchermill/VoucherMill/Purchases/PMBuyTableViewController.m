//
//  PMBuyTableViewController.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/5/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMBuyTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "PMPaymentViewController.h"
#import "PMBuyChildCustomCell.h"
#import <PayMillSDK/PMSDK.h>
#import "PMPaymentViewController.h"
#import "PMVoucherParams.h"
#import "PMVoucher.h"
#import "Constants.h"
#import "PMImageViewCell.h"
#import "PMButtonCell.h"
#import "PMBuyDetailsViewController.h"
#import "PMVoucherUtils.h"
#import "PMDataBaseManager.h"
#import "PMUserDefaultsManager.h"

typedef NS_ENUM(NSInteger, PMCustomVoucherField)
{
	IMAGE,
    AMOUNT,
    CURRENCY,
    DESCRIPTION,
    BUTTON,
};

static NSString *genericVCellIdentifier = @"GenericVoucherCell";
static NSString *customVCellIdentifier = @"CustomVoucherCell";
static NSString *buttonVCellIdentifier = @"ButtonVoucherCell";
static NSString *imageCellIdentifier = @"ImageCellIdentifier";

@interface PMVoucherPresentation :  NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *bigImage;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *description;

@end

@implementation PMVoucherPresentation
@synthesize image, bigImage, amount, currency, description;
@end

@interface PMBuyTableViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableImageVertSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTableVertSpace;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic) BOOL updateConstraints;
@property (nonatomic) int updateConstratinsCount;
@property (nonatomic) NSInteger buyActionIndex;
@property (nonatomic, strong) NSArray *genericVouchers;

- (IBAction)buyAction:(id)sender;

@end

@implementation PMBuyTableViewController

@synthesize index, buyButton, tableImageVertSpace, buttonTableVertSpace, topMargin, bottomMargin, updateConstraints, updateConstratinsCount, buyActionIndex, genericVouchers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	//[self.view setNeedsDisplay];
	// Do any additional setup after loading the view.
    
    self.updateConstratinsCount = 0;
	self.updateConstraints = YES;
	
	self.buyActionIndex = 0;
	
    [self createVoucherPresentations];
    [self registerNibs];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.isVisible = YES;
}

- (void)createVoucherPresentations
{
    PMVoucherPresentation *voucher1 = [[PMVoucherPresentation alloc] init];
	voucher1.image = [UIImage imageNamed:@"tickets"];
	voucher1.bigImage = [UIImage imageNamed:@"tickets_big"];
	voucher1.currency = @"EUR";
	voucher1.amount = @"100";
	voucher1.description = kTickets;
	
	PMVoucherPresentation *voucher2 = [[PMVoucherPresentation alloc] init];
	voucher2.image = [UIImage imageNamed:@"tyre"];
	voucher2.bigImage = [UIImage imageNamed:@"tyre_big"];
	voucher2.currency = @"EUR";
	voucher2.amount = @"200";
	voucher2.description = kTyre;
	
	PMVoucherPresentation *voucher3 = [[PMVoucherPresentation alloc] init];
	voucher3.image = [UIImage imageNamed:@"burger"];
	voucher3.bigImage = [UIImage imageNamed:@"burger_big"];
	voucher3.currency = @"EUR";
	voucher3.amount = @"300";
	voucher3.description = kBurger;
	
	PMVoucherPresentation *voucher4 = [[PMVoucherPresentation alloc] init];
	voucher4.image = [UIImage imageNamed:@"custom"];
	voucher4.bigImage = [UIImage imageNamed:@"custom_big"];
	voucher4.currency = @"EUR";
	voucher4.amount = @"400";
	voucher4.description = kCustom;
	
	genericVouchers = [NSArray arrayWithObjects:voucher1, voucher2, voucher3, voucher4, nil];
}

- (void)registerNibs
{
    [self.tableView registerNib:[UINib nibWithNibName:@"PMButtonCell" bundle:nil] forCellReuseIdentifier:buttonVCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PMImageViewCell" bundle:nil] forCellReuseIdentifier:imageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"PMBuyChildCustomCell" bundle:nil] forCellReuseIdentifier:customVCellIdentifier];
}

- (IBAction)customValue:(UITextField *)sender forEvent:(UIEvent *)event {
	PMVoucherPresentation *voucher = [genericVouchers lastObject];
	switch (sender.tag) {
		case AMOUNT:
			voucher.amount = sender.text;
			break;
		case CURRENCY:
			voucher.currency = sender.text;
			break;
		case DESCRIPTION:
			voucher.description = sender.text;
			break;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case IMAGE:
			return 100.0;
        case BUTTON:
			return 70.0;
		default:
            //check if device is iPhone4
            if (self.view.frame.size.height == 316) {
                return 44.0;
            } else {
                return 70.0;
            }
	}
	return 0.0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	
	switch (indexPath.row) {
		case IMAGE:
			cell = [self dequeCellWithIdentiefier:imageCellIdentifier forIndexPath:indexPath];
			break;
	}
	
	//child controller with index 4 has a different table view
	if(self.index < 3) {
        if (indexPath.row == BUTTON) {
            cell = [self dequeCellWithIdentiefier:buttonVCellIdentifier forIndexPath:indexPath];
        }
        else {
            cell =  [self dequeCellWithIdentiefier:genericVCellIdentifier forIndexPath:indexPath];
        }
	}
    else {
        if (indexPath.row == BUTTON) {
            cell = [self dequeCellWithIdentiefier:buttonVCellIdentifier forIndexPath:indexPath];
        }
        else {
            cell = [self dequeCellWithIdentiefier:customVCellIdentifier forIndexPath:indexPath];
        }
	}
    
    cell.textLabel.textColor = lightOrangeColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.detailTextLabel.text = [sectionContents objectAtIndex:[indexPath row]];
    cell.detailTextLabel.textColor = darkOrangeColor;
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:kLabelFontSize];
    
	return cell;
}

-(UITableViewCell *)dequeCellWithIdentiefier:(NSString *)cellIdentifer forIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    PMBuyChildCustomCell *firstCell;
	PMImageViewCell *secondCell;
    PMButtonCell* lastCell;
    
	if([cellIdentifer isEqualToString:genericVCellIdentifier]) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:genericVCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:genericVCellIdentifier];
        }
        
		[self configureGenericVoucherCell:cell forIndexPath:indexPath];
	}
	else if([cellIdentifer isEqualToString:customVCellIdentifier]) {
        firstCell = [self.tableView dequeueReusableCellWithIdentifier:customVCellIdentifier forIndexPath:indexPath];
        firstCell.customValue.delegate = self;
        firstCell.delegate = self;
        
		[self configureCustomVoucherCell:firstCell forIndexPath:indexPath];
        cell = firstCell;
	}
	else if([cellIdentifer isEqualToString:imageCellIdentifier]) {
		secondCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
		[self configureImageViewCell:secondCell forIndexPath:indexPath];
		cell = secondCell;
	}
    else if ([cellIdentifer isEqualToString:buttonVCellIdentifier]) {
        lastCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
        [lastCell.submitButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
		//[self configureImageViewCell:lastCell forIndexPath:indexPath];
		cell = lastCell;
    }
    
	return cell;
}

-(void)configureGenericVoucherCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	PMVoucherPresentation *voucher = (PMVoucherPresentation *)[genericVouchers objectAtIndex:index];
    
	switch (indexPath.row) {
		case AMOUNT:
			cell.textLabel.text = @"Amount:";
			cell.detailTextLabel.text = voucher.amount;
			break;
		case CURRENCY:
			cell.textLabel.text = @"Currency:";
			cell.detailTextLabel.text = voucher.currency;
			break;
		case DESCRIPTION:
			cell.textLabel.text = @"Description:";
			cell.detailTextLabel.text = voucher.description;
			break;
	}
}

-(void)configureCustomVoucherCell:(PMBuyChildCustomCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    PMVoucherPresentation* voucher = [self.genericVouchers lastObject];
    
    switch (indexPath.row) {
		case AMOUNT:
            cell.customValueLabelTitle = @"Amount:";
            cell.customValue.backgroundColor = [UIColor clearColor];
            cell.customValue.enabled = YES;
            cell.customValue.keyboardType = UIKeyboardTypeNumberPad;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			cell.tag = 1;
			break;
		case CURRENCY:
            cell.customValueLabelTitle = @"Currency:";
            cell.customValue.backgroundColor = [UIColor lightGrayColor];
            cell.customValue.text = voucher.currency;
            cell.customValue.enabled = NO;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			cell.tag = 2;
			break;
		case DESCRIPTION:
            cell.customValueLabelTitle = @"Description:";
            cell.customValue.backgroundColor = [UIColor lightGrayColor];
            cell.customValue.text = voucher.description;
            cell.customValue.enabled = NO;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			cell.tag = 3;
			break;
	}
}

-(void)configureImageViewCell:(PMImageViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
	PMVoucherPresentation *voucher = (PMVoucherPresentation *)[genericVouchers objectAtIndex:index];
	
    cell.image = voucher.bigImage;	
}

#pragma mark - Table view delegate

- (IBAction)buyAction:(id)sender {
	
	NSError *error;
	PMPaymentParams *params;
	PMSettings *pmViewSettings;
	PMPaymentViewController *payViewNav;
	
	//get the right voucher
	PMVoucherPresentation *voucherPresi = [genericVouchers objectAtIndex:index];
	
	//copy parameters from UI
	PMVoucherParams *vouchParams = [PMVoucherParams instance];
	vouchParams.voucherValue = voucherPresi.amount.intValue;
	vouchParams.currency = voucherPresi.currency;
	vouchParams.description = voucherPresi.description;
	
	//set payment view settings
	pmViewSettings = [[PMSettings alloc] init];
	pmViewSettings.paymentType = vouchParams.action;
	pmViewSettings.cardTypes = [[PMUserDefaultsManager instance] getActiveCards];
	pmViewSettings.directDebitCountry = @"DE";
	pmViewSettings.isTestMode = vouchParams.isTestMode;
	pmViewSettings.consumable = (![[PMUserDefaultsManager instance] isAutoConsumed]);
	//Create payment parameters
	params = [PMFactory genPaymentParamsWithCurrency:vouchParams.currency amount:vouchParams.voucherValue description:vouchParams.description error:&error];
	
    UIStoryboard* stBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [stBoard instantiateViewControllerWithIdentifier:@"PMNavigationController"];
    PMBuyDetailsViewController *pmBuyDetailsViewController = navController.childViewControllers[0];

	//check for errors
	if(!error){
		//create the payment view controller
        payViewNav = [[PMPaymentViewController alloc] initWithParams:params publicKey:vouchParams.publicKey settings:pmViewSettings style:nil success:^(id resObject) {
			
			PMVoucherParams *vouchParams = [PMVoucherParams instance];
			//PMVoucherPresentation *voucherPresi = [genericVouchers objectAtIndex:index];
        
			if (vouchParams.action == TOKEN || vouchParams.action == TOKEN_WO_INIT) {
				pmBuyDetailsViewController.buyVoucher = nil;
				pmBuyDetailsViewController.token = (NSString*)resObject;
			}
			else if(vouchParams.action == TRANSACTION || vouchParams.action == PREAUTHORIZATION) {
				pmBuyDetailsViewController.buyVoucher.voucherAmount = ((PMTransaction *)resObject).amount;
				pmBuyDetailsViewController.buyVoucher.voucherStatus = ((PMTransaction *)resObject).status;
				pmBuyDetailsViewController.buyVoucher.voucherDescrpition = ((PMTransaction *)resObject).description;
				if(!pmBuyDetailsViewController.buyVoucher.voucherDescrpition) {
					pmBuyDetailsViewController.buyVoucher.voucherDescrpition = @"N/A";
				}
				//convert timestamp to date and save it as string
				pmBuyDetailsViewController.buyVoucher.voucherCreationDate = [PMVoucherUtils timeStampAsString:((PMTransaction *)resObject).created_at];
				
				pmBuyDetailsViewController.buyVoucher.voucherBigImage = voucherPresi.bigImage;
				pmBuyDetailsViewController.buyVoucher.voucherCreditCardNumber = ((PMTransaction *)resObject).payment.last4;
				pmBuyDetailsViewController.buyVoucher.voucherAccount = ((PMTransaction *)resObject).payment.account;
				pmBuyDetailsViewController.buyVoucher.voucherCurrency = ((PMTransaction *)resObject).currency;
				pmBuyDetailsViewController.buyVoucher.voucherBankCode = ((PMTransaction *)resObject).payment.code;
				//temporarily only
				pmBuyDetailsViewController.buyVoucher.isCreditCard = YES; 			}
				
			    PMVoucher *voucher = pmBuyDetailsViewController.buyVoucher;
				//insert only bought(transactions) vouchers in DB
			if(vouchParams.action == TRANSACTION) {
				   pmBuyDetailsViewController.buyVoucher.transactionId = ((PMTransaction *)resObject).id;
				   [[PMDataBaseManager instance] insertNewOfflineVoucherWithAmount:voucher.voucherAmount currency:voucher.voucherCurrency description:voucher.voucherDescrpition andCompletionHandler:^(NSError *err) {
					   if(err) {
						   [PMVoucherUtils showErrorAlertWithTitle:@"Error inserting offline voucher" errorType:INTERNAL errorMessage:err.description];
					   }
				}];
			}
            
			[self.navigationController presentViewController:navController animated:YES completion:nil];
			
        } failure:^(NSError *error) {
            pmBuyDetailsViewController.buyError = error;
			[self.navigationController presentViewController:navController animated:YES completion:nil];

		}];
        
		//present the view controller modally
         self.isVisible = NO;
        UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:payViewNav];
		[self presentViewController:navCtrl animated:YES completion:nil];

	}
	else {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"PM Error: " message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
        
	}
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	PMVoucherParams *vouchParams = [PMVoucherParams instance];
	if (vouchParams.action == TOKEN || vouchParams.action == TOKEN_WO_INIT) {
		//show alert
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PayMill Response" message:@"Secure payment token generated."delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alert show];
		return NO;
	}
	return YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
    
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIView* sprv = textField.superview;
    
    while ( nil != sprv ) {
        if ( [sprv isKindOfClass:[UITableViewCell class]])
            break;
        
        sprv = sprv.superview;
    }
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:(UITableViewCell*)sprv];
    [self performSelector:@selector(scrollTo:) withObject:indexPath afterDelay:0.2];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    UIView* sprv = textField.superview;
    
    while ( nil != sprv ) {
        if ( [sprv isKindOfClass:[UITableViewCell class]])
            break;
        
        sprv = sprv.superview;
    }
    
    if ( sprv.tag == 1 ) {
        NSCharacterSet* numberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if( [string stringByTrimmingCharactersInSet:numberSet].length > 0 ) {
            NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            PMVoucherPresentation *voucher = [genericVouchers lastObject];
            voucher.amount = newString;
            
            return YES;
        }
        else {
            return NO;
        }
    }
    
    return YES;
}

- (void)scrollTo:(NSIndexPath*)ip
{
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)buyChildCustomCell:(PMBuyChildCustomCell *)buyChildCustomCell doneButtonWasSelected:(UIBarButtonItem *)button
{
    [self textFieldShouldReturn:buyChildCustomCell.customValue];
}

@end
