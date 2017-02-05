//
//  ImageViewController.m
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import "ImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import "ErrorHandlingLayer.h"
#import "UIViewController+Alerts.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

//didSwipe is used to check if the selectedIndex change while there is no internet connection
@property (assign, nonatomic) NSInteger didSwipe;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    _didSwipe = 0;
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(pinchGestureAction:)];
    [_imageView addGestureRecognizer:twoFingerPinch];
    [self loadImageAtIndex:_selectedIndex];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - swipe gesture action

- (IBAction)swipeLeft:(id)sender {
    if (_selectedIndex != _Photos.count-1) {
        _didSwipe = 1;
        _selectedIndex++;
        
        [UIView transitionWithView:_imageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self loadImageAtIndex:_selectedIndex];
                        }
                        completion:nil];
    }
    
}

- (IBAction)swipeRight:(id)sender {
    if (_selectedIndex != 0) {
        _didSwipe = -1;
        _selectedIndex--;
        [UIView transitionWithView:_imageView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self loadImageAtIndex:_selectedIndex];
                            
                        }
                        completion:nil];
    }
    
}



#pragma mark - pinch gesture action

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)recognizer{
    if (recognizer.scale >1.0f && recognizer.scale < 2.5f) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        _imageView.transform = transform;
    }
}


#pragma mark - load image view from url

-(void)loadImageAtIndex:(NSInteger)index{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        
        [ErrorHandlingLayer handleErrorCode:-100];
        if (_didSwipe == 1) {
            _selectedIndex --;
        }else if(_didSwipe == -1){
            _selectedIndex ++;
        }
    }
    else{
        
        [self showSpinner:nil];
        FlickrPhoto *photo = [_Photos objectAtIndex:index];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[photo getLargePhotoURL]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self hideSpinner:nil];
            
        }];
    }
}

@end
