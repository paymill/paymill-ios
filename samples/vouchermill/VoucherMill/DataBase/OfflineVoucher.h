//
//  OfflineVoucher.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 7/1/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OfflineVoucher : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * transactionId;

@end
