//
//  PMBuyViewController.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 7/3/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMBuyContainerController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "PMVoucherParams.h"

typedef NS_ENUM(NSInteger, PMBuyAction)
{
    BUY,
    RESERVE,
    GEN_TOKEN,
};

@interface PMBuyContainerController ()
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *children;

@property (nonatomic, assign) CGFloat pageVCYPosition;;
@property (nonatomic, assign) BOOL isKeybordShown;

@end

@implementation PMBuyContainerController
@synthesize children, pageControl, segmentedControl, isToken;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    //[self.view setBackgroundColor:[UIColor clearColor]];
    
	// kick things off by making the first page
	//create page control
    [self createPageControl];
    
    [self createSegControl];
    
    [self createPageViewController];
	
    [self addSubviews];
    [self registerForKeybordNotif];
}

-(void)registerForKeybordNotif
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
}

- (void)addSubviews
{
    [self.view addSubview:self.pageControl];
    
    segmentedControl.frame = CGRectMake
	(
	 self.pageVC.view.center.x - (segmentedControl.frame.size.width)/2,
	 10,
	 segmentedControl.frame.size.width,
	 segmentedControl.frame.size.height
	 );
	
	[self.view addSubview:segmentedControl];
    
    [self addChildViewController:self.pageVC];
    [[self view] addSubview:[self.pageVC view]];
    [self.pageVC didMoveToParentViewController:self];
}

- (void)createPageControl
{
    CGFloat pageControlHeight = 36.0;
    
    CGRect frame = CGRectMake(0.0,
                              CGRectGetMaxY(self.view.bounds) - pageControlHeight,
                              CGRectGetWidth(self.view.bounds),
                              pageControlHeight);
    
	self.pageControl = [[UIPageControl alloc]initWithFrame:frame];
	self.pageControl.backgroundColor = [UIColor whiteColor];
	self.pageControl.currentPage = 0;
	//self.pageControl.pageIndicatorTintColor = [UIColor orangeColor];
	self.pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
	self.pageControl.numberOfPages = 4;	// must be set or control won't draw
    self.pageControl.enabled = NO;
	self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
}

- (void)createSegControl
{
    NSArray *segments;
	PMVoucherParams *params = [PMVoucherParams instance];
	if (params.action == TOKEN_WO_INIT) {
		segments = [NSArray arrayWithObjects:@"Token", nil];
	} else {
		segments = [NSArray arrayWithObjects:@"Buy",@"Reserve", @"Token", nil];
	}
	
	UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
	UIColor *color = [UIColor whiteColor];
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, UITextAttributeFont, color, UITextAttributeTextColor,nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
	[segmentedControl setTitleTextAttributes:attrs forState:UIControlStateNormal];
	
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	[segmentedControl setBackgroundImage:[UIImage imageNamed:@"button_backgroundimage"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[segmentedControl setBackgroundImage:[UIImage imageNamed:@"selectedbutton_backgroundimage"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[segmentedControl setDividerImage:[UIImage imageNamed:@"divider_selected"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[segmentedControl.layer setMasksToBounds:YES];
	[segmentedControl.layer setBorderWidth:2.0f];
	[segmentedControl.layer setBorderColor:darkOrangeColor.CGColor];
	[segmentedControl.layer setCornerRadius:10.0f];
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)createPageViewController
{
    CGFloat offset = 20.0;
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
	self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    
	CGFloat pageVCHeight = CGRectGetMaxY(self.view.bounds) - segmentedControl.frame.size.height - pageControl.frame.size.height;
    
	[[self.pageVC view] setFrame:CGRectMake(0.0,
                                            CGRectGetHeight(segmentedControl.bounds) + offset,
                                            CGRectGetWidth(self.view.bounds),
                                            pageVCHeight - offset)];
    
	self.pageVC.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
    PMBuyTableViewController *initialViewController = [self viewControllerAtIndex:0];
	children = [NSMutableArray arrayWithObject:initialViewController];
    
    [self.pageVC setViewControllers:children direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    PMBuyTableViewController* buyViewCtrl = [self viewControllerAtIndex:pageControl.currentPage];
    
    if ( (!self.isKeybordShown) && buyViewCtrl.isVisible) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        NSDictionary *userInfo = [note userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGFloat height = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? kbSize.width : kbSize.height;
        
        self.pageVCYPosition = self.pageVC.view.frame.origin.y;
        
        CGRect pageVCFrame = self.pageVC.view.frame;
        CGRect viewFrame = self.view.frame;
        
        pageVCFrame.origin.y = 0.0;
        viewFrame.size.height -= height - self.pageControl.bounds.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = viewFrame;
            self.pageVC.view.frame = pageVCFrame;
        }];
        
        self.isKeybordShown = YES;
    }
}

- (void) keyboardDidHide:(NSNotification *)note
{
    // move the view back to the origin
    PMBuyTableViewController* buyViewCtrl = [self viewControllerAtIndex:pageControl.currentPage];
    if ( self.isKeybordShown && buyViewCtrl.isVisible ) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        NSDictionary *userInfo = [note userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        CGFloat height = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? kbSize.width : kbSize.height;
        
        CGRect pageVCFrame = self.pageVC.view.frame;
        CGRect viewFrame = self.view.frame;
        
        pageVCFrame.origin.y = self.pageVCYPosition;
        viewFrame.size.height += height - self.pageControl.bounds.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = viewFrame;
            self.pageVC.view.frame = pageVCFrame;
        }];
        
        self.isKeybordShown = NO;
    }
}

-(void)segmentAction:(UISegmentedControl *)sender
{
	PMVoucherParams *params = [PMVoucherParams instance];
    
	switch (sender.selectedSegmentIndex) {
		case BUY:
			params.action = TRANSACTION;
			break;
		case RESERVE:
			params.action = PREAUTHORIZATION;
			break;
		case GEN_TOKEN:
			params.action = TOKEN;
			break;
		default:
			break;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
	if(pendingViewControllers && pendingViewControllers.count > 0) {
		pageControl.currentPage = [pendingViewControllers[0] index];
	}
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PMBuyTableViewController *)viewController
{
	NSUInteger index = [viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PMBuyTableViewController *)viewController
{
    NSUInteger index = [viewController index];
    index++;
    
    if (index == 4) {
        return nil;
    }
	
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
	static NSUInteger instanceCount = 0;
    
	PMBuyTableViewController *childViewController;
	if(index >= children.count) {
		instanceCount++;
        
		childViewController = [[PMBuyTableViewController alloc] initWithNibName:@"PMBuyTableViewController" bundle:nil];
        childViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		childViewController.index = index;
        
		[children addObject:childViewController];
	}
	else {
		childViewController = [children objectAtIndex:index];
	}
    
	return childViewController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
