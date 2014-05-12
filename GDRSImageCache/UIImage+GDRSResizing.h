//
//  UIImage+GDRSResizing.h
//  GADRSImageCache
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIBezierPath*(^UIImageGDRSResizingClippingPathComputation)(CGRect newImageRect, CGRect targetRect);

@interface UIImage (GDRSResizing)

- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize;
- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize
                           clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation;


- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize;
- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize
                            clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation;

@end


