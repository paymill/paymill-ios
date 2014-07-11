//
//  PMSettingsViewController.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 7/4/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMSettingsViewController.h"

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMSettingsViewController ()

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMSettingsViewController

@synthesize ccItems, ddItems;

/**************************************/
#pragma mark - Init
/**************************************/
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**************************************/
#pragma mark -
/**************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"CardsData"
                                                     ofType:@"plist"];
    NSDictionary* data = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    ccItems = [data objectForKey:@"Cards"];
    self.navigationController.navigationBar.translucent = NO;
    
    //ddItems = [NSArray arrayWithObjects:@"Germany", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*********************************************/
#pragma mark - UITableViewDataSource methods
/*********************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return ddItems.count;
            break;
        case 2:
            return ccItems.count;
            break;
            
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch(indexPath.section) {
        case 0:
            if (indexPath.row == 0 ) {
                cell.textLabel.text = @"Safe Store enabled";
                cell.imageView.image = nil;
            }
            else {
                cell.textLabel.text = @"auto-consume";
                cell.imageView.image = nil;
            }
            break;
            
        case 1:
            cell.textLabel.text = [ddItems objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:[ddItems objectAtIndex:indexPath.row]];
            break;
            
        case 2:
            cell.textLabel.text = [[ccItems objectAtIndex:indexPath.row] valueForKey:@"cardName"];
            cell.imageView.image = [UIImage imageNamed:[[ccItems objectAtIndex:indexPath.row] valueForKey:@"imageName"]];
            break;
    }
    
    bool checkFromDB = [[NSUserDefaults standardUserDefaults] objectForKey:cell.textLabel.text] == nil ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:cell.textLabel.text];
    
    cell.accessoryType = checkFromDB ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) {
        return @"";
    }
    else if ( section == 1 ) {
        return (ddItems && [ddItems count] > 0)  ? @"Direct Debit" : @"";
    }
    else {
        return @"Credit Card";
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat offset = 10.0;
    
    UIView *customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                       0.0,
                                                                       tableView.bounds.size.width,
                                                                       2*offset)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset,
                                                                    0.0,
                                                                    CGRectGetWidth(customTitleView.bounds) - 2*offset,
                                                                    CGRectGetHeight(customTitleView.bounds))];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.text = [self tableView:self.tableView titleForHeaderInSection:section]; 
    
    [customTitleView addSubview:titleLabel];
    
    return customTitleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50.0;
}

/*********************************************/
#pragma mark - UITableViewDelegate methods
/*********************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.accessoryType = selectedCell.accessoryType == UITableViewCellAccessoryNone ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    [self saveBoolToUserDefaults:selectedCell.textLabel.text value:selectedCell.accessoryType == UITableViewCellAccessoryCheckmark];
}

/**************************************/
#pragma mark -
/**************************************/
- (void)saveBoolToUserDefaults:(NSString *)key value:(bool)valueBool
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults){
        [standardUserDefaults setBool:valueBool forKey:key];
    }
}

@end
