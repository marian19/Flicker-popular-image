//
//  HTTPClient.h
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServices.h"



@protocol HTTPClientDelegate <NSObject>
-(void)didSuccessWithObjectsArray:(NSArray*)objectsArray fromMethod:(NSString*)methodName;

@end



@interface HTTPClient : NSObject <NSURLSessionDelegate>

+ (HTTPClient *)sharedHTTPClient;
-(void)requestwithParameters:(NSDictionary *)parameters forMethod:(NSString *)methodCalled;
-(void)didSuccessWithResponse:(NSArray*)JSONArray fromMethod:(NSString*)methodName;
@end
