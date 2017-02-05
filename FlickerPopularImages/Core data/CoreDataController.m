//
//  CoreDataController.m
//
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import "CoreDataController.h"

@interface CoreDataController ()

- (void)initializeCoreData;

@property (nonatomic, strong) NSURL *storeURL;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation CoreDataController

+(instancetype)sharedInstance {
    
    static CoreDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

#pragma mark - Core Data stack

- (void)initializeCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FlickerPopularImages" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSAssert(_managedObjectModel != nil, @"Error initializing Managed Object Model");
    
    self.storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FlickerPopularImages.sqlite"];
    
    
    self.managedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    self.backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil  queue:nil  usingBlock:^(NSNotification* note) {
        NSManagedObjectContext *moc = self.managedObjectContext;
        if (note.object != moc) {
            [moc performBlock:^(){
                [moc mergeChangesFromContextDidSaveNotification:note];
            }];
        }
    }];
}

- (NSManagedObjectContext *)setupManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    
    managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError* error;
    NSPersistentStore *store = [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                             configuration:nil
                                                                                                       URL:self.storeURL
                                                                                                   options:@{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES}
                                                                                                     error:&error];
    
    if (!store) {
        NSLog(@"Failed to create PersistentStore");
    }
    
    NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    
    return managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.HOME.kjshdgjkdhjd" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    [self saveMainContext];
    [self saveBackgroundContext];
}

- (void)saveMainContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (void)saveBackgroundContext {
    NSManagedObjectContext *managedObjectContext = self.backgroundManagedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (void) deleteAllObjects {
    
    if (_managedObjectContext != nil) {
        //all core data entities
        NSDictionary *allEntities = _managedObjectModel.entitiesByName;
        
        for (NSString* entityName in [allEntities allKeys]) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
            [fetchRequest setEntity:entity];
            NSError *error;
            NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
            for (NSManagedObject *managedObject in items) {
                [_managedObjectContext deleteObject:managedObject];
            }
            if (![_managedObjectContext save:&error]) {
            }
        }
    }
}

@end
