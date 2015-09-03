//
//  AspectFillViewController.m
//  GDRSImageCache
//
//  Created by Gabriel Radu on 04/05/2014.
//  Copyright (c) 2014 GADRS Consulting Ltd. All rights reserved.
//

#import "AspectFillViewController.h"

@interface AspectFillViewController ()

@end

@implementation AspectFillViewController

- (void)configureView
{
    UIImage *image = [UIImage imageNamed:@"VisualTestImage"];
    
    self.sharpCornersImageView.image = [image gdrs_resizedImageToAspectFillSize:self.sharpCornersImageView.bounds.size];
    self.roundCornersImageView.image = [image gdrs_resizedImageToAspectFillSize:self.roundCornersImageView.bounds.size cornerRadius:10];
}

@end
