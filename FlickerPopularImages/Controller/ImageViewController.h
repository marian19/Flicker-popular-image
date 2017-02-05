//
//  ImageViewController.h
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"

@interface ImageViewController : UIViewController
@property (strong, nonatomic) NSArray *Photos;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
