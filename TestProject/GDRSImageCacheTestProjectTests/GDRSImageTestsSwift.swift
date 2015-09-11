//
//  GDRSImageTestsSwift.swift
//  GDRSImageCacheTestProject
//
//  Created by Gabriel Radu on 11/09/2015.
//  Copyright © 2015 GADRS Consulting Ltd. All rights reserved.
//

import XCTest


class GDRSImageTestsSwift: XCTestCase {
    
    var testBundle: NSBundle!
    var defaultTestPictureURL: NSURL!
    var testPictureURL: NSURL!
    var defaultTestPicture: UIImage!
    var testPicture: UIImage!
    
    
    // MARK: Setup and teardown
    
    override func setUp() {
        super.setUp()
        testBundle = NSBundle(forClass: self.dynamicType)
        guard let
            defaultTestPictureURL = testBundle.URLForResource("DefaultTestPicture", withExtension: "png"),
            testPictureURL = testBundle.URLForResource("TestPicture", withExtension: "png"),
            defaultTestPicture = UIImage(data: NSData(contentsOfURL: defaultTestPictureURL)!),
            testPicture = UIImage(data: NSData(contentsOfURL: testPictureURL)!)
            else {
                XCTFail("Could not find test pictures in bundle")
                return
        }
        self.defaultTestPictureURL = defaultTestPictureURL
        self.testPictureURL = testPictureURL
        self.defaultTestPicture = defaultTestPicture
        self.testPicture = testPicture
    }
    
    
    // MARK: Tests
    
    func testUncachedImage() {
        
        let cache = GDRSImageCache()
        cache.defaultImage = defaultTestPicture
        
        var imageRetrivedExpectation = optionalExpectationWithDescription("Image has been retrived from cache")
        var cachedImage: UIImage? = nil
        let image = cache.fetchImageWithURL(testPictureURL) { (image, error) -> Void in
            cachedImage = image
            imageRetrivedExpectation?.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0) { (error) -> Void in
            imageRetrivedExpectation = nil
        }
        
        GDRSTAssertEqualImages(image, defaultTestPicture)
        GDRSTAssertEqualImages(cachedImage, testPicture)
        
    }
    
    func testCachedImage() {
        
        let cache = GDRSImageCache()
        cache.defaultImage = defaultTestPicture

        cache.imageCache.setObject(testPicture, forKey: testPictureURL.absoluteString)
        
        var hasRunBlock = false
        let image = cache.fetchImageWithURL(testPictureURL) { (image, error) -> Void in
            hasRunBlock = true
        }
        
        var timeHasPassedExpectation = optionalExpectationWithDescription("10 seconds have passed")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            timeHasPassedExpectation?.fulfill()
        }
        
        waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            timeHasPassedExpectation = nil
        }
        
        XCTAssertFalse(hasRunBlock)
        GDRSTAssertEqualImages(image, testPicture)
        
    }
    
    func testThatImageIsCached() {

        let cache = GDRSImageCache()
        cache.defaultImage = defaultTestPicture
        
        var testPictureRetrievedExpectation = optionalExpectationWithDescription("Image has been retrived from cache")
        var timeHasPassedExpectation = optionalExpectationWithDescription("10 seconds have passed")
        var secondImage: UIImage?
        var secondImageFetchBlockRun = false
        cache.fetchImageWithURL(testPictureURL) { (image, error) -> Void in
            
            secondImage = cache.fetchImageWithURL(self.testPictureURL, completionHandler: { (image, error) -> Void in
                secondImageFetchBlockRun = true
            })
            
            testPictureRetrievedExpectation?.fulfill()
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
                timeHasPassedExpectation?.fulfill()
            }
            
        }
        
        waitForExpectationsWithTimeout(20.0) { (error) -> Void in
            testPictureRetrievedExpectation = nil
            timeHasPassedExpectation = nil
        }
        
        GDRSTAssertEqualImages(secondImage, testPicture)
        XCTAssertFalse(secondImageFetchBlockRun)
        
    }
    
    
    // MARK: Utilities
    
    func GDRSTAssertEqualImages(img1: UIImage?, _ img2: UIImage?, desc: String = "") {
        guard let i1 = img1, i2 = img2 else {
            if img1 != img2 {
                XCTFail(desc)
            }
            return
        }
        XCTAssertEqual(UIImagePNGRepresentation(i1), UIImagePNGRepresentation(i2), desc)
    }
    
    func optionalExpectationWithDescription(description: String) -> XCTestExpectation? {
        return expectationWithDescription(description)
    }
    
}
