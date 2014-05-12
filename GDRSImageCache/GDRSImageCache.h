//
//  GDRSImageCache.h
//  GADRSImageCache
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import "UIImage+GDRSResizing.h"


/**
 *  Callback which transforms an image to another image. It is normally
 *  used to filter the image fetched over the network into one that is
 *  cached.
 *
 *  @param sourceImage The source image.
 *
 *  @return The filtered (transformed) image.
 */
typedef UIImage*(^GDRSImageCacheImageFilter)(UIImage *sourceImage);

/**
 *  Callback called when an image has been fetched.
 *
 *  @param image The image fetched and some time processed (e.g.
 *               through a filter).
 *  @param error Points to an error if one has occurred during fetching
 *               otherwise nil.
 */
typedef void(^GDRSImageCacheFetchCompletionHandler)(UIImage *image, NSError *error);



/**
 *  Memory based cache for UIImage objects.
 * 
 *  A typical usage example of this class is:
 *  @code
         UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
 
         // create the cache
         GDRSImageCache *cache = [[GDRSImageCache alloc] initWithCachedImageFilter:^UIImage *(UIImage *sourceImage) {
 
             // resize the image to the image view size and round the image corners; 
             // this is called by the cache on a background thread
             return [sourceImage gdrs_resizedImageToAspectFitSize:anImageView.bounds.size cornerRadius:10];
             
         }];
 
         // set the default image, which will be returned from
         // fetchImageWithURL:completionHandler: if an image coresponding to the
         // requested url is not cached yet.
         cache.defaultImage = [UIImage imageNamed:<#place holder image name#>];
 
 
         NSURL *imageUrl = <#an url to a image#>;
 
         // fetch an image; the call returns imidiatly and the callback handler
         // is called when the image is fetched over the network
         anImageView.image = [cache fetchImageWithURL:imageUrl completionHandler:^(UIImage *image, NSError *error) {
             anImageView.image = image;
         }];
 *  @endcode
 */
@interface GDRSImageCache : NSObject

/**
 *  Temporary image which is returned for convenience when the requested
 *  image is not found in the cache. This image can be used until the
 *  requested image is fetched over the network.
 */
@property (nonatomic) UIImage *defaultImage;

/**
 *  Filter applied strait after the image has been fetch. Usually such a 
 *  filter is used to resize the image in order to fit the a certain
 *  UIImageView. This filter is called on a background thread before the 
 *  image is cached.
 */
@property (nonatomic, readonly, copy) GDRSImageCacheImageFilter imageFilter;

/**
 *  Initializes the cache with an image filter.
 *
 *  @param imageFilter Filter applied strait after the image has been fetch. 
 *                     Usually such a filter is used to resize the image in 
 *                     order to fit the a certain UIImageView. This filter is 
 *                     called on a background thread before the image is cached.
 *
 *  @return The initialized instance.
 */
- (instancetype)initWithCachedImageFilter:(GDRSImageCacheImageFilter)imageFilter;

/**
 *  Initiates an image fetch over the network and returns the cached image if
 *  one is already cached, or the defaultImage if a cached image is not found.
 *
 *  @param imageURL          The url where the image must be fetched from.
 *  @param completionHandler Called when the image has been fetched. It is not 
 *                           called back if the image is not fetched from over 
 *                           the network for some reason.
 *
 *  @return The cached image or the defaultImage if the image has not been 
 *          cached yet.
 */
- (UIImage *)fetchImageWithURL:(NSURL *)imageURL completionHandler:(GDRSImageCacheFetchCompletionHandler)completionHandler;

@end




