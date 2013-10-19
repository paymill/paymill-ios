//
//  OfflineVoucher.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OfflineVoucher : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * descript;

@end
