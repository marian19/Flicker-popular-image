//
//  ErrorHandlingLayer.m
//  SearchManger.m
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//


#import "ErrorHandlingLayer.h"

@implementation ErrorHandlingLayer

static UIAlertController *errorMessageAlertView;


static const NSInteger TOO_MANY_TAGS= 1;
static const NSInteger UNKNOWN_USER= 2;
static const NSInteger PARAMTERLESS_SEARCHES_DISABLED= 3;
static const NSInteger DO_NOT_HAVE_PERMISSION=  4;
static const NSInteger FLICKR_API_UNAVAILABLE=  10;
static const NSInteger ILOGICAL_ARGUMENTS  = 18;
static const NSInteger INVALID_API_KEY  =   100;
static const NSInteger SERVICE_UNAVAILABLE  =  105;
static const NSInteger METHOD_NOT_FOUND = 112;
static const NSInteger INTERNET_CONNECTION= -100;
static const NSInteger INTERNAL_SERVER_ERROR_CODE = 500;
static const NSInteger RESOURCE_NOT_FOUND_ERROR_CODE = 404;
static const NSInteger INVALID_DATA_SENT_ERROR_CODE = 400;


+(void)handleErrorCode:(NSInteger)statusCode
{
    NSString *errorMessage =@"Oops, something went wrong. Please try again";
    
    switch (statusCode)
    {
            
        case INTERNAL_SERVER_ERROR_CODE:
            errorMessage = @"Internal Server Error";
            break;
            
        case RESOURCE_NOT_FOUND_ERROR_CODE:
            errorMessage = @"The requested resource could not be found but may be available in the future";
            break;
            
            
        case INVALID_DATA_SENT_ERROR_CODE:
            errorMessage = @"Bad Request";
            break;
            
        case TOO_MANY_TAGS:
            errorMessage = @"Too many tags in ALL query";
            break;
            
        case UNKNOWN_USER:
            errorMessage = @"Unknown user";
            break;
            
        case PARAMTERLESS_SEARCHES_DISABLED:
            errorMessage = @"Parameterless searches have been disabled";
            break;
            
        case DO_NOT_HAVE_PERMISSION:
            errorMessage = @"You don't have permission to view this pool";
            break;
            
        case FLICKR_API_UNAVAILABLE:
            errorMessage = @"Sorry, the Flickr search API is not currently available";
            break;
            
        case ILOGICAL_ARGUMENTS:
            errorMessage = @"Illogical arguments";
            break;
            
        case INVALID_API_KEY:
            errorMessage = @"The API key passed was not valid or has expired";
            break;
            
        case SERVICE_UNAVAILABLE:
            errorMessage = @"Service currently unavailable";
            break;
            
        case METHOD_NOT_FOUND:
            errorMessage = @"The requested method was not found";
            break;
            
        case INTERNET_CONNECTION:
            errorMessage = @"Please check your internet connection";
            break;
            
        default:
            break;
    }
    [ErrorHandlingLayer handleErrorWithMessage:errorMessage];
}


+(void)handleErrorWithMessage:(NSString*)message
{
    
    errorMessageAlertView = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [errorMessageAlertView addAction: [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:nil]];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainController = [keyWindow rootViewController];
    [mainController presentViewController:errorMessageAlertView animated:YES completion:nil];
    
    
}




@end
