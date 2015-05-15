//
//  VideoCameraDelegateImplementation.m
//  FaceReconstruction
//
//  Created by Olee on 14.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#import "VideoCameraDelegateImplementation.h"

#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/nonfree/features2d.hpp>
#include <opencv2/highgui/highgui.hpp>

#import <opencv2/opencv.hpp>

cv::ORB detector(1000, 1.4f, 8, 31, 0, 2, cv::ORB::HARRIS_SCORE, 31);

bool firstTime = true;

std::vector<cv::KeyPoint> prev_keypoints;
cv::Mat prev_descriptors;
cv::Mat prev_frame;

cv::BFMatcher matcher(cv::NORM_L2);

//CV_WRAP explicit ORB(int nfeatures = 500, float scaleFactor = 1.2f, int nlevels = 8, int edgeThreshold = 31,
//                     int firstLevel = 0, int WTA_K=2, int scoreType=ORB::HARRIS_SCORE, int patchSize=31 );


@implementation VideoCameraDelegateImplementation


- (id) init {
    self = [super init];
    
    if (self) {
        
    }

    return self;
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus

- (void)processImage:(cv::Mat &)image {
    
//    // Do some OpenCV stuff with the image
//    cv::Mat image_copy;
//    cvtColor(image, image_copy, CV_BGRA2BGR);
//    
//    // invert image
//    bitwise_not(image_copy, image_copy);
//    cvtColor(image_copy, image, CV_BGR2BGRA);

    // Do some OpenCV stuff with the image
    cv::Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);

    if (firstTime) {
        firstTime = false;
        prev_frame = image_copy;
        detector.detect(prev_frame, prev_keypoints);
        detector.compute(prev_frame, prev_keypoints, prev_descriptors);
        return;
    }
    
    std::vector<cv::KeyPoint> keypoints;
    detector.detect(image_copy, keypoints);
    
    cv::Mat descriptors;
    detector.compute(image_copy, keypoints, descriptors);
    
    std::vector<cv::DMatch> matches;
    matcher.match( prev_descriptors, descriptors, matches);
    
    cv::Mat resultImage;
    cv::drawMatches(prev_frame, prev_keypoints, image_copy, keypoints, matches, resultImage);
//    cv::drawKeypoints(image_copy, keypoints, resultImage);
    
    prev_descriptors = descriptors;
    prev_keypoints = keypoints;
    prev_frame = image_copy;
    
    cvtColor(resultImage, image, CV_BGR2BGRA);
}

#endif

@end
