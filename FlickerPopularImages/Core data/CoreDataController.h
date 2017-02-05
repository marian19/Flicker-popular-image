//
//  CoreDataController.h
//  SearchManger.m
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject

+(instancetype)sharedInstance;

@property (strong) NSManagedObjectContext *managedObjectContext;

@property (strong) NSManagedObjectContext *backgroundManagedObjectContext;

- (void)saveContext;

//delete all core data objects
- (void) deleteAllObjects;


@end
