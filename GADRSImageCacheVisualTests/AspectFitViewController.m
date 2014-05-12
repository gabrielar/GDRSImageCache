//
//  AspectFitViewController.m
//  GDRSImageCache
//
//  Created by Gabriel Radu on 04/05/2014.
//  Copyright (c) 2014 GADRS Consulting Ltd. All rights reserved.
//

#import "AspectFitViewController.h"

@interface AspectFitViewController ()

@end

@implementation AspectFitViewController

- (void)configureView
{
    UIImage *image = [UIImage imageNamed:@"VisualTestImage"];
    
    self.sharpCornersImageView.image = [image gdrs_resizedImageToAspectFitSize:self.sharpCornersImageView.bounds.size];
    self.roundCornersImageView.image = [image gdrs_resizedImageToAspectFitSize:self.roundCornersImageView.bounds.size cornerRadius:10];
}

@end
