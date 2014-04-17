//
//  UIImage+GDRSResizing.h
//  WhosWhoApp
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GDRSResizing)
- (UIImage *)gadrs_resizedImageToFitSize:(CGSize)newImageSize cornerRadius:(CGFloat)cornerRadius;
@end
