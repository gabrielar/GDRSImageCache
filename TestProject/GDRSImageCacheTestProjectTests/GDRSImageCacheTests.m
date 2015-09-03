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
    
    __block BOOL handlerHasExecuted = NO;
    
    UIImage *image = [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
        GDRSTAssertEqualImages(image, [UIImage imageWithData:[NSData dataWithContentsOfURL:testPictureURL]]);
        handlerHasExecuted = YES;
    }];
    GDRSTAssertEqualImages(image, [UIImage imageWithData:[NSData dataWithContentsOfURL:defaultTestPictureURL]]);
    
    NSDate *lastRunLoopDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
    while (!handlerHasExecuted && [[NSDate new] compare:lastRunLoopDate] == NSOrderedAscending) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:lastRunLoopDate];
    }
    
    XCTAssert(handlerHasExecuted, @"");
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
    
    NSDate *lastRunLoopDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
    while ([[NSDate new] compare:lastRunLoopDate] == NSOrderedAscending) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:lastRunLoopDate];
    }
}

- (void)testThatImageIsCached
{
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *defaultTestPictureURL = [testBundle URLForResource:@"DefaultTestPicture" withExtension:@"png"];
    NSURL *testPictureURL = [testBundle URLForResource:@"TestPicture" withExtension:@"png"];
    
    GDRSImageCache *cache = [GDRSImageCache new];
    cache.defaultImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:defaultTestPictureURL]];
    
    __block BOOL handlerHasExecuted = NO;
    
    [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
        UIImage *secondImage = [cache fetchImageWithURL:testPictureURL completionHandler:^(UIImage *image, NSError *error) {
            XCTFail(@"");
        }];
        GDRSTAssertEqualImages(secondImage, [UIImage imageWithData:[NSData dataWithContentsOfURL:testPictureURL]]);
        handlerHasExecuted = YES;
    }];
    
    NSDate *lastRunLoopDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
    while (!handlerHasExecuted && [[NSDate new] compare:lastRunLoopDate] == NSOrderedAscending) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:lastRunLoopDate];
    }
    
    XCTAssert(handlerHasExecuted, @"");
}

@end
