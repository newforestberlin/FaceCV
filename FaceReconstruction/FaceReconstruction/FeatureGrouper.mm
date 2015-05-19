//
//  FeatureGrouper.cpp
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#include "FeatureGrouper.h"

#include <opencv2/highgui/highgui.hpp>
#import <opencv2/opencv.hpp>

FeatureGrouper::FeatureGrouper() {
    detector = new cv::ORB(1000, 1.4f, 8, 31, 0, 2, cv::ORB::HARRIS_SCORE, 31);
}

FeatureGrouper::~FeatureGrouper() {
    delete detector;
}

void FeatureGrouper::processImage(cv::Mat &image) {
        
    cv::Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    std::vector<cv::KeyPoint> keypoints;
    detector->detect(image_copy, keypoints);
    
    cv::Mat descriptors;
    detector->compute(image_copy, keypoints, descriptors);
    
    cv::Mat resultImage;
    cv::drawKeypoints(image_copy, keypoints, resultImage);
    
    cvtColor(resultImage, image, CV_BGR2BGRA);
}