//
//  HTTPClient.m
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//


#import "HTTPClient.h"
#import "ErrorHandlingLayer.h"

@implementation HTTPClient



+ (HTTPClient *)sharedHTTPClient
{
    static HTTPClient *_sharedHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[HTTPClient alloc] init];
    });
    
    return _sharedHTTPClient;
}


-(void) requestwithParameters:(NSDictionary *)parameters forMethod:(NSString *)methodCalled{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSString *stringURL = WEBSERVICE_BASE_URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request setTimeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    if (parameters) {
        for (NSInteger i = 0; i < parameters.count; i++) {
            NSString *currentKey = [parameters.allKeys objectAtIndex:i];
            NSString *currentValue = [parameters.allValues objectAtIndex:i];
            NSString *subString;
            if (i == parameters.count -1)
            {
                subString = [NSString stringWithFormat:@"%@=%@" ,currentKey ,currentValue];
            }
            else
            {
                subString = [NSString stringWithFormat:@"%@=%@&" ,currentKey ,currentValue];
            }
            stringURL = [stringURL stringByAppendingString:[subString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        }
    }
    
    // request url
    [request setURL:[NSURL URLWithString:stringURL]];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200) {
                NSDictionary* json = [[NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:kNilOptions
                                       error:&error] objectForKey:@"photos"];
                if (json != nil) {
                    NSArray* photosDictionaryArray = [json objectForKey:@"photo"];
                    
                    [self didSuccessWithResponse:photosDictionaryArray fromMethod:methodCalled];
                }
                
            }else{
                
                [ErrorHandlingLayer handleErrorCode:httpResp.statusCode];
            }
        }
        
        
    }];
    [postDataTask resume];
}


-(void)didSuccessWithResponse:(NSArray*)JSONArray fromMethod:(NSString*)methodName{
    
}


@end
