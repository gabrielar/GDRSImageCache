//
//  GDRSImageCache.m
//  WhosWhoApp
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "GDRSImageCache.h"
#import "UIImage+GDRSResizing.h"

@interface GDRSImageCache()
@property (nonatomic, copy) GDRSImageCacheImageFilter imageFilter;
@property (nonatomic) NSCache *imageCache;
@end



@implementation GDRSImageCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageCache = [NSCache new];
    }
    return self;
}

- (instancetype)initWithCachedImageFilter:(GDRSImageCacheImageFilter)imageFilter
{
    self = [self init];
    if (self) {
        self.imageFilter = imageFilter;
    }
    return self;
}


- (UIImage *)fetchImageWithURL:(NSURL *)imageURL completionHandler:(void (^)(UIImage *image, NSError *error))completionHandler
{
    if (!imageURL) {
        return self.defaultImage;
    }
    
    NSString *cacheKey = [imageURL absoluteString];
    NSCache *cache = self.imageCache;
    
    __block UIImage *picture = [cache objectForKey:cacheKey];
    if (picture) {
        return picture;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSError *error = nil;
        
        picture = [self fetchAndResizeImageIfNecesaryFromURL:imageURL error:&error];
        if (picture) {
            [cache setObject:picture forKey:cacheKey];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (picture) {
                [cache setObject:picture forKey:cacheKey];
            }
            else {
                picture = self.defaultImage;
            }
            completionHandler(picture, error);
        });
        
    });
    
    return self.defaultImage;
}

- (UIImage *)fetchAndResizeImageIfNecesaryFromURL:(NSURL *)imageURL error:(NSError *__autoreleasing*)error
{
    UIImage *image = nil;
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:0 error:error];
    
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    
    if (self.imageFilter) {
        image = self.imageFilter(image);
    }
    
    return image;
}


@end
