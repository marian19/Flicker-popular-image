//
//  ErrorHandlingLayer.h
//  SearchManger.m
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ErrorHandlingLayer : NSObject <UIAlertViewDelegate>

+(void)handleErrorCode:(NSInteger)statusCode;

@end
