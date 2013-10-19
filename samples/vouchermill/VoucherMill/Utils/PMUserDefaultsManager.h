//
//  PMUserDefaultsManager.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/12/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMUserDefaultsManager : NSObject

+ (id)instance;

- (BOOL)isAutoConsumed;

- (NSArray *)getActiveCards;

@end
