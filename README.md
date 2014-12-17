GDRSImageCache
==============

GDRSImageCache is a minimalistic caching and image resizing library for iOS. Given an
URL it retrieves the image on a background thread and it caches it in memory. 
GDRSImageCache can be provided with a filtering block which can be used to resize the 
images obtained from the URL before caching. 

Installation
-----------

###Manual installation (as a static library)

The GDRSImageCache has a static library target. Hence all that needs to be done is to copy
the contents of the GDRSImageCache library into your project directory, and add the
GDRSImageCache to your project. Then the test target in your project need to link to
the GDRSImageCache lib and to be made dependent on the lib target from the GDRSImageCache
project. Also make sure that the header and library search paths of your project
include ```$(BUILT_PRODUCTS_DIR)```, and that 'Other Linker Flags' contains ```-ObjC```.

Step by step instructions:

1.	Copy the contents of the GDRSImageCache repository into your project directory, it
	does not matter where exactly. 
1.	Open your project in XCode. 
1.	In XCode (with your project open) select the group which you wish to contain
	the GDRSImageCache project, and bring up it's context menu. 
1.	In the context menu select "Add files to << your project name >>..." 
1.	Select the GDRSImageCache project file (ie. GDRSImageCache.xcodeproj), and click the 
	"Add" button. 
1.	Go to the "Build Phases" of your project, and select the tests target.
1.	Add the GDRSImageCache library to the "Target Dependencies".
1.	Add the ```libGDRSImageCache.a``` to "Link Binary With Libraries"
1.	Go to the "Build Settings" of your project, and select the tests target.
1.	Add ```$(BUILT_PRODUCTS_DIR)``` to the 'Header Search Path' and to the 'Library Search Path'.
1. 	Add ```-ObjC``` to "Other Linker Flags".

###Using COCOAPODS

From the [COCOAPODS](http://cocoapods.org) website:

> CocoaPods is the dependency manager for Objective-C projects. It has thousands of libraries and can help you scale your projects elegantly.

####New to COCOAPODS:

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

####Using COCOAPODS already:

If you have already installed COCOAPODS just add following line to your ```Podfile```

	pod 'GDRSImageCache',	'~> 1.0'

GDRSImageCache suports ios versions of ```5.0``` and above.

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
