//
//  GDRSImageCache.h
//  WhosWhoApp
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "UIImage+GDRSResizing.h"



typedef UIImage*(^GDRSImageCacheImageFilter)(UIImage *sourceImage);



typedef void(^GDRSImageCacheFetchCompletionHandler)(UIImage *image, NSError *error);



@interface GDRSImageCache : NSObject

@property (nonatomic) UIImage *defaultImage;

@property (nonatomic, readonly, copy) GDRSImageCacheImageFilter imageFilter;

- (instancetype)initWithCachedImageFilter:(GDRSImageCacheImageFilter)imageFilter;

- (UIImage *)fetchImageWithURL:(NSURL *)imageURL completionHandler:(GDRSImageCacheFetchCompletionHandler)completionHandler;

@end




