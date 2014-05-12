//
//  UIImage+GDRSResizing.m
//  GADRSImageCache
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "UIImage+GDRSResizing.h"

typedef CGSize(^UIImageGDRSResizingScalingFactorComputation)(CGSize sizeRatio);


@implementation UIImage (GDRSResizing)


#pragma mark Size to aspect fit

- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize
{
    return [self gadrs_resizedImageToAspectFitSize:newImageSize clippingComputation:nil];
}

- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius
{
    return [self gadrs_resizedImageToAspectFitSize:newImageSize clippingComputation:^UIBezierPath *(CGRect newImageRect, CGRect targetRect) {
        return [UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:cornerRadius];
    }];
}

- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize
                           clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation
{
    return [self gadrs_resizedImageToSize:newImageSize scaleingComputation:^CGSize(CGSize sizeRatio) {
        
        CGFloat scalingFactor = MIN(sizeRatio.width, sizeRatio.height);
        return CGSizeMake(scalingFactor, scalingFactor);
        
    } clippingComputation:clippingComputation];
}


#pragma mark Size to aspect fill

- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize
{
    return [self gadrs_resizedImageToAspectFillSize:newImageSize clippingComputation:nil];
}

- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius
{
    return [self gadrs_resizedImageToAspectFillSize:newImageSize clippingComputation:^UIBezierPath *(CGRect newImageRect, CGRect targetRect) {
        return [UIBezierPath bezierPathWithRoundedRect:newImageRect cornerRadius:cornerRadius];
    }];
}

- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize
                            clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation
{
    return [self gadrs_resizedImageToSize:newImageSize scaleingComputation:^CGSize(CGSize sizeRatio) {
        
        CGFloat scalingFactor = MAX(sizeRatio.width, sizeRatio.height);
        return CGSizeMake(scalingFactor, scalingFactor);
        
    } clippingComputation:clippingComputation];
}


#pragma mark Size with computation blocks

- (UIImage *)gadrs_resizedImageToSize:(CGSize)newImageSize
                     scaleingComputation:(UIImageGDRSResizingScalingFactorComputation)scalingComputation
                     clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation
{
    UIImage *image = nil;
    
    CGFloat resizedImageScale = [[UIScreen mainScreen] scale];
    //    CGFloat selfScale = self.scale;
    
    CGSize sizeRatio = CGSizeMake(newImageSize.width/self.size.width,
                                  newImageSize.height/self.size.height);
    
    CGSize scalingFactor = scalingComputation(sizeRatio);
    
    CGRect targetRect = CGRectZero;
    targetRect.size.width = self.size.width * scalingFactor.width;
    targetRect.size.height = self.size.height *scalingFactor.height;
    targetRect.origin.x = (newImageSize.width - targetRect.size.width) / 2.0f;
    targetRect.origin.y = (newImageSize.height - targetRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, resizedImageScale); {
        
        if (clippingComputation) {
            CGRect newImageRect =  { CGPointZero, newImageSize };
            UIBezierPath *clippingPath = clippingComputation(newImageRect, targetRect);
            [clippingPath addClip];
        }
        
        [self drawInRect:targetRect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
    } UIGraphicsEndImageContext();
    
    return image;
}

@end


