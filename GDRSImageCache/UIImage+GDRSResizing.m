//
//  UIImage+GDRSResizing.m
//  WhosWhoApp
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "UIImage+GDRSResizing.h"

typedef CGSize(^UIImageGDRSResizingScalingFactorComputation)(CGSize sizeRatio);
typedef UIBezierPath*(^UIImageGDRSResizingClippingPathComputation)(CGRect newImageRect, CGRect targetRect);


@implementation UIImage (GDRSResizing)

- (UIImage *)gadrs_resizedImageToFitSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius
{
    return [self gadrs_resizedImageToFitSize:newImageSize scaleingComputation:^CGSize(CGSize sizeRatio) {
        
        CGFloat scalingFactor = MIN(sizeRatio.width, sizeRatio.height);
        return CGSizeMake(scalingFactor, scalingFactor);
        
    } clippingComputation:^UIBezierPath *(CGRect newImageRect, CGRect targetRect) {
        
         return [UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:cornerRadius];
        
    }];
}

- (UIImage *)gadrs_resizedImageToFitSize:(CGSize)newImageSize
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
    
    UIGraphicsBeginImageContextWithOptions(targetRect.size, NO, resizedImageScale); {
        
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
