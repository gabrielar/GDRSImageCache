//
//  UIImage+GDRSResizing.m
//  WhosWhoApp
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "UIImage+GDRSResizing.h"

@implementation UIImage (GDRSResizing)

- (UIImage *)gadrs_resizedImageToFitSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius
{
    UIImage *image = nil;
    
    CGFloat resizedImageScale = [[UIScreen mainScreen] scale];
//    CGFloat selfScale = self.scale;
    
    CGSize sizeRatio = CGSizeMake(newImageSize.width/self.size.width,
                                  newImageSize.height/self.size.height);
    
    CGFloat scalingFactor = MIN(sizeRatio.width, sizeRatio.height);
    
    CGRect targetRect = CGRectZero;
    targetRect.size.width = self.size.width * scalingFactor;
    targetRect.size.height = self.size.height *scalingFactor;
    targetRect.origin.x = (newImageSize.width - targetRect.size.width) / 2.0f;
    targetRect.origin.y = (newImageSize.height - targetRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions(targetRect.size, NO, resizedImageScale); {
        
        UIBezierPath *clippingPath = [UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:cornerRadius];
        //[clippingPath stroke];
        [clippingPath addClip];
        
        [self drawInRect:targetRect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
    } UIGraphicsEndImageContext();
    
    return image;
}


@end
