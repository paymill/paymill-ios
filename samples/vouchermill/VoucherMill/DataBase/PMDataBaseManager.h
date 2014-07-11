//
//  PMDataBaseManager.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineVoucher.h"
#import "PMVoucher.h"

typedef void (^PMDataCompletionHandler)(NSError* err);

@interface PMDataBaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)instance;

- (void)insertNewOfflineVoucherWithAmount:(NSString*)amount
                                 currency:(NSString*)currency
                              description:(NSString*)description
							transactionId:(NSString*)transactionId
                     andCompletionHandler:(PMDataCompletionHandler)completionHandler;

- (void)insertNewOfflineVoucherWithVoucher:(PMVoucher *)voucher
					  andCompletionHandler:(PMDataCompletionHandler)completionHandler;

- (NSArray*)allOfflineVouchersWithCompletionHandler:(PMDataCompletionHandler)completionHandler;

-(OfflineVoucher *)findVoucherByTransactionId:(NSString *)transactionId andCompletionHandler:(PMDataCompletionHandler)completionHandler;

@end
