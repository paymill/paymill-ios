//
//  PMBuyViewController.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 7/3/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBuyTableViewController.h"

@interface PMBuyContainerController : UIViewController<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

- (PMBuyTableViewController *)viewControllerAtIndex:(NSUInteger)pageIndex;

@property (nonatomic, strong)  UIPageViewController *pageVC;
@property (nonatomic) BOOL isToken;

@end
