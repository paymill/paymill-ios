//
//  PMViewControllerFactory.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMViewControllerFactory.h"

@implementation PMViewControllerFactory
+(void) openViewControllerFromClass:(Class)cls modal:(BOOL)modal initSelector:(SEL)initSelector
{
	id clasToCreate;

	if(cls) {
		clasToCreate = [[cls alloc] performSelector:initSelector];		
	}
	NSLog(@"Object created: %@", clasToCreate);
}
@end
