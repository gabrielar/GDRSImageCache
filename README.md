GDRSImageCache
==============

[![Build Status](https://api.travis-ci.org/gabrielar/GDRSImageCache.svg)](https://travis-ci.org/gabrielar/GDRSImageCache) 
 [![Cocoa Pod Version](https://cocoapod-badges.herokuapp.com/v/GDRSImageCache/badge.svg)](https://cocoapods.org/pods/GDRSImageCache)  [![Cocoa Pod Version](https://cocoapod-badges.herokuapp.com/l/GDRSImageCache/badge.svg)](https://raw.githubusercontent.com/gabrielar/GDRSImageCache/master/License.txt)

What it does
------------

GDRSImageCache is a minimalistic **caching and image resizing** library for iOS. Given an
URL it retrieves the image on a background thread and it caches it in memory. 

GDRSImageCache can be provided with a filtering block which can be used to resize and mask 
the images obtained from the URL before caching. This **unique feature** provides fast image 
rendering because the resizing and masking of the image is done on a background thread 
only once per image before caching. Thus this library is particularly well suited to be 
used with table and collection views, as it provides smooth scrolling.

Installation
-----------

### Using COCOAPODS

From the [COCOAPODS](http://cocoapods.org) website:

> CocoaPods is the dependency manager for Objective-C projects. It has thousands of libraries and can help you scale your projects elegantly.

#### New to COCOAPODS:

If you do not have COCOAPODS installed, follow these steps to install COCOAPODS and 
GDRSImageCache:

1.	Instal COCOAPODS as described in the "INSTALL" section of [http://cocoapods.org](http://cocoapods.org). 
1.	Follow the instructions under the "GET STARTED" section from the same webpage 
	([http://cocoapods.org](http://cocoapods.org)).
1.	In the ```Podfile``` instead of the lines ```pod 'JSONKit',       '~> 1.4'``` and 
	```pod 'Reachability',  '~> 3.0'``` write ```pod 'GDRSImageCache',	'~> 1.0'```.

Your pod file should now look like this:

	platform :ios, '7.0'
	pod 'GDRSImageCache',	'~> 1.0'

Of course the ios versions can be less than ```7.0```. GDRSImageCache suports ios version 
of ```5.0``` and above.

#### Using COCOAPODS already:

If you have already installed COCOAPODS just add following line to your ```Podfile```

	pod 'GDRSImageCache',	'~> 1.0'

GDRSImageCache suports ios versions of ```5.0``` and above.

### Manual installation

Drag and drop following four files from the ```GDRSImageCache``` directory into Xcode in the Project Navigator:

* GDRSImageCache.h
* GDRSImageCache.m
* UIImage+GDRSResizing.h
* UIImage+GDRSResizing.m

Also make sure that they are added to your target.


Usage
-----

A typical usage of GDRSImageCache is as shown below:

```objective-c
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
```
To use the GDRSImageCache class by it's self you need 
```#import <GDRSImageCache/GDRSImageCache.h>```. For the resizing methods of ```UIImage```
(e.g. ```gdrs_resizedImageToAspectFitSize:```) you need 
```#import <GDRSImageCache/UIImage+GDRSResizing.h>```.
