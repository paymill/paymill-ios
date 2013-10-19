//
//  PMViewControllerFactory.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 6/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMViewControllerFactory : NSObject
+(void) openViewControllerFromClass:(Class)cls modal:(BOOL)modal initSelector:(SEL)initSelector;
@end
