//
//  FlickrPhoto+CoreDataProperties.h
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "FlickrPhoto.h"


NS_ASSUME_NONNULL_BEGIN

@interface FlickrPhoto (CoreDataProperties)

+ (NSFetchRequest<FlickrPhoto *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *farm;
@property (nullable, nonatomic, copy) NSString *photoID;
@property (nullable, nonatomic, copy) NSString *secret;
@property (nullable, nonatomic, copy) NSString *server;

@end

NS_ASSUME_NONNULL_END
