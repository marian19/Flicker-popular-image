//
//  FlickrPhoto+CoreDataProperties.m
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "FlickrPhoto+CoreDataProperties.h"

@implementation FlickrPhoto (CoreDataProperties)

+ (NSFetchRequest<FlickrPhoto *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FlickrPhoto"];
}

@dynamic farm;
@dynamic photoID;
@dynamic secret;
@dynamic server;

@end
