//
//  GDRSImageCacheTests.m
//  GDRSImageCacheTests
//
//  Created by Gabriel Radu on 17/04/2014.
//  Copyright (c) 2014 Gabriel Adrian Radu. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <GDRSImageCache/GDRSImageCache.h>



#define GDRSTAssertEqualImages(img1, img2) XCTAssertEqualObjects(UIImagePNGRepresentation(img1), UIImagePNGRepresentation(img2), @"");

@interface GDRSImageCache()
@property (nonatomic) NSCache *imageCache;
@end



#pragma mark -


@interface GDRSImageCacheTests : XCTestCase

@end

@implementation GDRSImageCacheTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUncachedImage
{
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *defaultTestPictureURL = [testBundle URLForResource:@"DefaultTestPicture" withExtension:@"png"];
    NSURL *testPictureURL = [testBundle URLForResource:@"TestPicture" withExtension:@"png"];
    
    GDRSImageCache *cache = [GDRSImageCache new];
    cache.defaultImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:defaultTestPictureURL]];
    
    __block XCTestExpectation *imageRetrivedExpectation = [self expectationWithDescription:@"Image has been retrived from cache"];
    UIImage *image = [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
        GDRSTAssertEqualImages(image, [UIImage imageWithData:[NSData dataWithContentsOfURL:testPictureURL]]);
        [imageRetrivedExpectation fulfill];
    }];
    GDRSTAssertEqualImages(image, [UIImage imageWithData:[NSData dataWithContentsOfURL:defaultTestPictureURL]]);
    
    [self waitForExpectationsWithTimeout:10.0 handler:^(NSError *error) {
        imageRetrivedExpectation = nil;
    }];
}

- (void)testCachedImage
{
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *defaultTestPictureURL = [testBundle URLForResource:@"DefaultTestPicture" withExtension:@"png"];
    NSURL *testPictureURL = [testBundle URLForResource:@"TestPicture" withExtension:@"png"];
    
    GDRSImageCache *cache = [GDRSImageCache new];
    cache.defaultImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:defaultTestPictureURL]];
    
    [cache.imageCache setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:testPictureURL]] forKey:[testPictureURL absoluteString]];
    
    UIImage *image = [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
        XCTFail(@"");
    }];
    GDRSTAssertEqualImages(image, [UIImage imageWithData:[NSData dataWithContentsOfURL:testPictureURL]]);
    
    __block XCTestExpectation *timeHasPassedExpectation = [self expectationWithDescription:@"10 seconds have passed"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timeHasPassedExpectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        timeHasPassedExpectation = nil;
    }];
}

- (void)testThatImageIsCached
{
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *defaultTestPictureURL = [testBundle URLForResource:@"DefaultTestPicture" withExtension:@"png"];
    NSURL *testPictureURL = [testBundle URLForResource:@"TestPicture" withExtension:@"png"];
    
    GDRSImageCache *cache = [GDRSImageCache new];
    cache.defaultImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:defaultTestPictureURL]];
    
    __block XCTestExpectation *testPictureRetrivedExpectation = [self expectationWithDescription:@"Image has been retrived from cache"];
    __block XCTestExpectation *timeHasPassedExpectation = [self expectationWithDescription:@"10 seconds have passed"];
    [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
        UIImage *secondImage = [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
            XCTFail(@"");
        }];
        GDRSTAssertEqualImages(secondImage, [UIImage imageWithData:[NSData dataWithContentsOfURL:testPictureURL]]);
        [testPictureRetrivedExpectation fulfill];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [timeHasPassedExpectation fulfill];
        });
        
    }];
    
    
    [self waitForExpectationsWithTimeout:20.0 handler:^(NSError *error) {
        testPictureRetrivedExpectation = nil;
        timeHasPassedExpectation = nil;
    }];
}

@end
