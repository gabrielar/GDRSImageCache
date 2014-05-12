//
//  UIImage+GDRSResizing.h
//  GADRSImageCache
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Callback handler which must compute and return a bezier path. This
 *  path will be applied as clipping mask for the new image.
 *
 *  @param newImageRect The bounds of the new (resized) image.
 *  @param targetRect   The rect where the old image will be drawn in
 *  the new image.
 *
 *  @return This bezier path will be applied as clipping mask for the 
 *  new image.
 */
typedef UIBezierPath*(^UIImageGDRSResizingClippingPathComputation)(CGRect newImageRect, CGRect targetRect);


/**
 *  Adds methods for resizing the receiver.
 */
@interface UIImage (GDRSResizing)


/// @name Aspect fit methods

/**
 *  Returns a scaled image of the receiver which which fits the provided 
 *  size while maintaining the aspect ratio. Any remaining area of the 
 *  new image bounds is transparent. Can be called on a background thread.
 *
 *  @param newImageSize The size of the new (resized) image.
 *
 *  @return A image with the size of newImageSize
 */
- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize;

/**
 *  Returns a scaled image of the receiver which which fits the provided
 *  size while maintaining the aspect ratio. Any remaining area of the
 *  new image bounds is transparent. Can be called on a background thread.
 *
 *  @param newImageSize The size of the new (resized) image.
 *  @param cornerRadius The radius to use in drawing the rounded corners 
 *                      the new image. Note that the rounded corner are 
 *                      drawn around the actual image, not around any
 *                      remaining transparent area.
 *
 *  @return A image with the size of newImageSize
 */
- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius;

/**
 *  Returns a scaled image of the receiver which which fits the provided
 *  size while maintaining the aspect ratio. Any remaining area of the
 *  new image bounds is transparent. Can be called on a background thread.
 *
 *  @param newImageSize The size of the new (resized) image.
 *  @param clippingComputation Callback handler which must compute and
 *                             return a bezier path. This path will be 
 *                             applied as clipping mask for the new image.
 *
 *  @return A image with the size of newImageSize
 */
- (UIImage *)gadrs_resizedImageToAspectFitSize:(CGSize)newImageSize
                           clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation;



/// @name Aspect fill methods

/**
 *  Returns a scaled version of the receiver which fills the provided size 
 *  while retaining the aspect ratio of the image. Some portion of the content 
 *  may be clipped to fill the new size. Can be called on a background thread.
 *
 *  @param newImageSize The size of the new (resized) image.
 *
 *  @return A image with the size of newImageSize
 */
- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize;

/**
 *  Returns a scaled version of the receiver which fills the provided size
 *  while retaining the aspect ratio of the image. Some portion of the content
 *  may be clipped to fill the new size. Can be called on a background thread.
 *
 *  @param newImageSize The size of the new (resized) image.
 *  @param cornerRadius The radius to use in drawing the rounded corners
 *                      the new image.
 *
 *  @return A image with the size of newImageSize
 */
- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius;

/**
 *  Returns a scaled version of the receiver which fills the provided size
 *  while retaining the aspect ratio of the image. Some portion of the content
 *  may be clipped to fill the new size. Can be called on a background thread.
 *
 *  @param newImageSize The size of the new (resized) image.
 *  @param clippingComputation Callback handler which must compute and
 *                             return a bezier path. This path will be
 *                             applied as clipping mask for the new image.
 *
 *  @return A image with the size of newImageSize
 */
- (UIImage *)gadrs_resizedImageToAspectFillSize:(CGSize)newImageSize
                            clippingComputation:(UIImageGDRSResizingClippingPathComputation)clippingComputation;

@end


