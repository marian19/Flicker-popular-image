//
//  FlickrPhoto+CoreDataClass.h
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhoto : NSManagedObject
+(NSString*)entityName;
+ (instancetype)createPhotoFromJSONDictionary:(NSDictionary *)JSONDictionary;
-(NSString*)getPhotoThumbnailURL;
-(NSString*)getLargePhotoURL;
+(NSArray*)getAllPhotos;
@end

NS_ASSUME_NONNULL_END

