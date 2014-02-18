//
//  PMAppDelegate.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 1/22/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMAppDelegate.h"
#define lightOrangeColor [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0]

@implementation PMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[[UIBarButtonItem appearance] setTintColor:lightOrangeColor];
    [[UIPageControl appearance] setPageIndicatorTintColor:lightOrangeColor];
    
    if ( [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue] >= 7 ) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    lightOrangeColor,UITextAttributeTextColor,
                                    nil];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
                                                    forState:UIControlStateNormal];
    }
    
    UINavigationController* navCtrl = (UINavigationController*)[self.window rootViewController];
    navCtrl.navigationBar.translucent = NO;
    navCtrl.view.backgroundColor = [UIColor whiteColor];
    
	return YES;
}

+ (void)initFromUserDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //Get the bundle path
	NSString *bPath = [[NSBundle mainBundle] bundlePath];
	NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
	NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
    
	//Get the Preferences Array from the dictionary
	NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
	NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
	//Loop through the array
	NSDictionary *item;
	for(item in preferencesArray)
	{
		//Get the key of the item.
		NSString *keyValue = [item objectForKey:@"Key"];
        
		//Get the default value specified in the plist file.
		id defaultValue = [item objectForKey:@"DefaultValue"];
        
		if (keyValue && defaultValue)
			[standardUserDefaults setObject:defaultValue forKey:keyValue];
	}
	[standardUserDefaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
