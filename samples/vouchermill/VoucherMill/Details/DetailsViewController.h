//
//  DetailsViewController.h
//  VoucherMill
//
//  Created by Oleg Ivanov on 6/27/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMVoucher.h"

@protocol PMDetailsViewDelegate <NSObject>
-(void)reloadTable;
@end

@interface DetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PMVoucher *theVoucher;
@property (nonatomic, weak) IBOutlet UITableView *detailsTable;
@property (strong, nonatomic) IBOutlet UIImageView *voucherImage;
@property (strong, nonatomic) NSMutableArray *detailsList;
@property (strong, nonatomic) id<PMDetailsViewDelegate> delegate;

@end
