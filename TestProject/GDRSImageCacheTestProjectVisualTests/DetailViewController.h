//
//  DetailViewController.h
//  GADRSImageCacheVisualTests
//
//  Created by Gabriel Radu on 04/05/2014.
//  Copyright (c) 2014 GADRS Consulting Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GDRSImageCache/UIImage+GDRSResizing.h>

@interface DetailViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView *sharpCornersImageView;
@property (nonatomic, weak) IBOutlet UIImageView *roundCornersImageView;
- (void)configureView;
@end
