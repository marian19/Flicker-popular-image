//
//  SearchManger.h
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HTTPClient.h"

@interface SearchManager : HTTPClient
@property (nonatomic, weak) id <HTTPClientDelegate> hTTPClientDelegateObject;

+ (instancetype)sharedInstance;

-(void)getTrendingImagesInPage:(int)pageNumber;
@end
