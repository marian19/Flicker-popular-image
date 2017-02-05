//
//  SearchManger.m
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import "SearchManager.h"
#import "WebServices.h"
#import "FlickrPhoto.h"
#import "CoreDataController.h"

@implementation SearchManager


+ (instancetype)sharedInstance
{
    static SearchManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SearchManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)getTrendingImagesInPage:(int)pageNumber{
    if (pageNumber == 1) {
        [[CoreDataController sharedInstance] deleteAllObjects];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"method"] = @"flickr.photos.search";
    parameters[@"api_key"] = API_KEY;
//    parameters[@"tags"] = @"Trending%2Cpopular";
    parameters[@"tags"] = @"Trending";

    parameters[@"per_page"] = [NSNumber numberWithInt:50];
    parameters[@"page"] = [NSNumber numberWithInt:pageNumber];
    parameters[@"format"] = @"json";
    parameters[@"nojsoncallback"] = [NSNumber numberWithInt:1];
    [self requestwithParameters:parameters forMethod:@"search"];

}

-(void)didSuccessWithResponse:(NSArray*)JSONArray fromMethod:(NSString*)methodName{
    
  
    NSMutableArray *photos = [NSMutableArray new];
    for (NSDictionary *photoDictionary in JSONArray) {
        FlickrPhoto *photo = [FlickrPhoto createPhotoFromJSONDictionary:photoDictionary];
        
        [photos addObject:photo];
    }
    [self.hTTPClientDelegateObject didSuccessWithObjectsArray:photos fromMethod:methodName];
    
}

//-(void)didFailWithError:(NSError *)error{
//
//}

@end
