//
//  PMUserDefaultsManager.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/12/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMUserDefaultsManager.h"

@implementation PMUserDefaultsManager
static PMUserDefaultsManager* sharedInstance;

/**************************************/
#pragma mark - instance
/**************************************/
+ (id)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (id)alloc
{
    if (!sharedInstance) {
		sharedInstance = [ super alloc ];
	}
    
	return sharedInstance;
}

- (id)init
{
    if ( nil != sharedInstance )
        return sharedInstance;
    
	if ( nil != (self = [super init])) {
    }
    
    return self;
}

/**************************************/
#pragma mark -
/**************************************/
- (BOOL)isAutoConsumed
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"auto-consume"] == nil ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:@"auto-consume"];
}

- (NSArray *)getActiveCards
{
	NSMutableArray *activeCards = [NSMutableArray array];
	NSString* path = [[NSBundle mainBundle] pathForResource:@"CardsData"
                                                     ofType:@"plist"];
    NSDictionary* data = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *cards = [data objectForKey:@"Cards"];
	
	for (NSDictionary *cc in cards) {
		NSString *cardName = [cc valueForKey:@"cardName"];
		BOOL active = [[NSUserDefaults standardUserDefaults] objectForKey:cardName] == nil ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:cardName];
		if(active) {
			[activeCards addObject:cardName];
		}
	}
	
	return activeCards;
}

@end
