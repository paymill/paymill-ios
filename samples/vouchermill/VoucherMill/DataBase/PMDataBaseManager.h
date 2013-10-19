//
//  PMDataBaseManager.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PMDataCompletionHandler)(NSError* err);

@interface PMDataBaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)instance;

- (void)insertNewOfflineVoucherWithAmount:(NSString*)amount
                                 currency:(NSString*)currency
                              description:(NSString*)description
                     andCompletionHandler:(PMDataCompletionHandler)completionHandler;

- (NSArray*)allOfflineVouchersWithCompletionHandler:(PMDataCompletionHandler)completionHandler;

@end
