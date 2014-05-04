//
//  CacheFilterViewController.m
//  GDRSImageCache
//
//  Created by Gabriel Radu on 05/05/2014.
//  Copyright (c) 2014 GADRS Consulting Ltd. All rights reserved.
//

#import "CacheFilterViewController.h"
#import "GDRSImageCache.h"

@interface CacheFilterViewController ()

@end

@implementation CacheFilterViewController

- (void)configureView
{
    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"VisualTestImageCache" withExtension:@"png"];
    GDRSImageCache *cache = [[GDRSImageCache alloc] initWithCachedImageFilter:^UIImage *(UIImage *sourceImage) {
        return [sourceImage gadrs_resizedImageToAspectFitSize:self.roundCornersImageView.bounds.size cornerRadius:10];
    }];
    [cache fetchImageWithURL:imageUrl completionHandler:^(UIImage *image, NSError *error) {
        self.roundCornersImageView.image = image;
    }];
}


@end
