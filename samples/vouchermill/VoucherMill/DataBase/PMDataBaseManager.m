//
//  PMDataBaseManager.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 9/11/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMDataBaseManager.h"
#import "OfflineVoucher.h"
#import "Constants.h"

@implementation PMDataBaseManager

static PMDataBaseManager* sharedInstance;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
- (void)insertNewOfflineVoucherWithAmount:(NSString*)amount
                                 currency:(NSString*)currency
                              description:(NSString*)description
                     andCompletionHandler:(PMDataCompletionHandler)completionHandler
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    OfflineVoucher* voucher = [NSEntityDescription
                               insertNewObjectForEntityForName:@"OfflineVoucher"
                               inManagedObjectContext:context];
    
    voucher.amount = amount;
    voucher.currency = currency;
    voucher.descript = description;
        
    NSError *error;
    if (![context save:&error]) {
    }
    
    PM_SAFE_BLOCK_CALL(completionHandler, error);
}

- (NSArray*)allOfflineVouchersWithCompletionHandler:(PMDataCompletionHandler)completionHandler
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"OfflineVoucher" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    PM_SAFE_BLOCK_CALL(completionHandler, error);
    
    return fetchedObjects;
}

/**************************************/
#pragma mark - Core Data
/**************************************/

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:@"VoucherMill" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VoucherMill.sqlite"];
	
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
	}
    
    return _persistentStoreCoordinator;
}

/************************************************/
#pragma mark - Application's Documents directory
/************************************************/
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
