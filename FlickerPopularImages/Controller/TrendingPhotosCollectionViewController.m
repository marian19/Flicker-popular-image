//
//  TrendingPhotosCollectionViewController.m
//  FlickerPopularImages
//
//  Created by Marian on 12/7/16.
//  Copyright © 2016 Marian. All rights reserved.
//

#import "TrendingPhotosCollectionViewController.h"
#import "SearchManager.h"
#import "FlickrPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotoCollectionViewCell.h"
#import "ImageViewController.h"
#import "CoreDataController.h"
#import "Reachability.h"
#import "ErrorHandlingLayer.h"
#import "UIViewController+Alerts.h"

@interface TrendingPhotosCollectionViewController ()<HTTPClientDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign , nonatomic) int pageNumber;
@property (strong , nonatomic) NSNumber *lastItemReached;
@property (strong, nonatomic) SearchManager *searchManager;
@property (strong, nonatomic) NSArray *photosArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TrendingPhotosCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _pageNumber = 1;
    _lastItemReached = [NSNumber numberWithInt:0];
    
    //change navigation bar tint color
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:3.0f/255.0f green:169.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    
    _searchManager = [SearchManager sharedInstance];
    _searchManager.hTTPClientDelegateObject = self;
    
    [self setupRefreshControl];
    [self getPhotosInPage:_pageNumber];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRefreshControl{
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}
#pragma mark - refresh control action

-(void)refershControlAction{
    _pageNumber = 1;
    _photosArray = nil;
    [self getPhotosInPage:_pageNumber];
    
}

#pragma mark - getTrendingImagesInPage using searchManager

-(void)getPhotosInPage:(int)pageNmber{
    //check the internet connection
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        [ErrorHandlingLayer handleErrorCode:-100];
    }else{
        [self showSpinner:nil];
        _pageNumber++;
        [_searchManager getTrendingImagesInPage:pageNmber];
    }
    
}

#pragma mark - HTTPClientDelegate Method

-(void)didSuccessWithObjectsArray:(NSArray*)objectsArray fromMethod:(NSString*)methodName{
    [_refreshControl endRefreshing];
    
    //save new objects to core data
    NSManagedObjectContext *managedObjectContext = [[CoreDataController sharedInstance] managedObjectContext];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    _lastItemReached = [NSNumber numberWithInt:0];
    
    if (objectsArray.count >0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_photosArray.count == 0) {
                _photosArray = objectsArray;
                [_collectionView reloadData];
            }else{
                
                int index = (int)_photosArray.count;
                _photosArray = [_photosArray arrayByAddingObjectsFromArray:objectsArray] ;
                
                // Create the indexes with a loop
                NSMutableArray *indexes = [NSMutableArray array];
                
                for (int i = index; i < _photosArray.count; i++){
                    [indexes addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                
                // Perform the updates
                [self.collectionView performBatchUpdates:^{
                    
                    //Inser the new cells
                    [self.collectionView insertItemsAtIndexPaths:indexes];
                    
                } completion:nil];
                
            }
        });
    }
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [self addAnimationToCell:cell];
    
    return cell;
}

#pragma mark - Configure collection view cell
- (void)configureCell:(id)cell atIndexPath:(NSIndexPath*)indexPath{
    PhotoCollectionViewCell *photoCell = cell;
    FlickrPhoto *photo = [_photosArray objectAtIndex:indexPath.item];
    
    [photoCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[photo  getPhotoThumbnailURL]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self hideSpinner:nil];
        
    }];
    
    if ([_lastItemReached intValue] == 0 && indexPath.item == [_photosArray count] - 1)
    {
        _lastItemReached = [NSNumber numberWithInt:1];
        [self getPhotosInPage:_pageNumber];
        
    }
    
}

-(void)addAnimationToCell:(id)cell{
    PhotoCollectionViewCell *photoCell = cell;
    
    CATransform3D rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, .0, 0.5, 0.5);
    photoCell.contentView.alpha = 0.8;
    photoCell.contentView.layer.transform = rotation;
    photoCell.contentView.layer.anchorPoint = CGPointMake(0, 0.5);
    
    [UIView animateWithDuration:.5
                     animations:^{
                         photoCell.contentView.layer.transform = CATransform3DIdentity;
                         photoCell.contentView.alpha = 1;
                         photoCell.contentView.layer.shadowOffset = CGSizeMake(0, 0);
                     } completion:^(BOOL finished) {
                     }];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ImageViewController *imageViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
    [imageViewController setPhotos:_photosArray];
    [imageViewController setSelectedIndex:indexPath.item];
    
}



@end
