//
//  FlickrPhoto+CoreDataClass.m
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "FlickrPhoto.h"
#import "CoreDataController.h"
#import "FlickrPhoto+CoreDataProperties.h"

@implementation FlickrPhoto

+(NSString*)entityName {
    return @"FlickrPhoto";
}


+ (instancetype)createPhotoFromJSONDictionary:(NSDictionary *)JSONDictionary{
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataController sharedInstance] managedObjectContext];
    
    FlickrPhoto *photo = [NSEntityDescription
           insertNewObjectForEntityForName:[FlickrPhoto entityName]
           inManagedObjectContext:managedObjectContext];
    if (photo) {
        photo.photoID = [NSString stringWithFormat:@"%@",[JSONDictionary objectForKey:@"id"]];
        photo.farm = [NSString stringWithFormat:@"%@",[JSONDictionary objectForKey:@"farm"]];
        photo.server = [NSString stringWithFormat:@"%@",[JSONDictionary objectForKey:@"server"]];
        photo.secret = [NSString stringWithFormat:@"%@",[JSONDictionary objectForKey:@"secret"]];
        
    }
    
    
    return photo;
}
-(NSString*)getPhotoThumbnailURL{
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_m.jpg",self.farm,self.server ,self.photoID ,self.secret];
}
-(NSString*)getLargePhotoURL{
    return [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_b.jpg",self.farm,self.server ,self.photoID ,self.secret];
}

+(NSArray*)getAllPhotos{
    //    NSManagedObjectContext *managedObjectContext = [[CoreDataController sharedInstance] backgroundManagedObjectContext];
    NSManagedObjectContext *managedObjectContext = [[CoreDataController sharedInstance] managedObjectContext];
    NSFetchRequest *fetchRequest = [FlickrPhoto fetchRequest];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!results) {
        abort();
    }
    return results ;
}


@end
