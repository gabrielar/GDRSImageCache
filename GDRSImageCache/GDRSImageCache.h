//
//  GDRSImageCache.h
//  WhosWhoApp
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "UIImage+GDRSResizing.h"

@interface GDRSImageCache : NSObject

@property (nonatomic) UIImage *defaultImage;

@property (nonatomic, readonly) BOOL shouldResizeImage;
@property (nonatomic, readonly) CGSize cachedImageSize;
@property (nonatomic, readonly) CGFloat cachedImageCornerRadius;

- (instancetype)initWithCachedImageSize:(CGSize)cachedImageSize corenerRadius:(CGFloat)cornerRadius;

- (UIImage *)fetchImageWithURL:(NSURL *)imageURL completionHandler:(void (^)(UIImage *image, NSError *error))completionHandler;


@end
