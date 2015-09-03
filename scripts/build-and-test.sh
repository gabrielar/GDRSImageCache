#!/bin/bash

ORIGINAL_DIR=$(pwd)

cd TestProject
xcodebuild test -workspace GDRSImageCacheTestProject.xcworkspace -scheme GDRSImageCacheTestProject -sdk iphonesimulator -configuration Debug

cd $ORIGINAL_DIR
