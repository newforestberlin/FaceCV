//
//  BasicFeatureVisualizer.cpp
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#include "BasicFeatureVisualizer.h"

#include <opencv2/highgui/highgui.hpp>
#import <opencv2/opencv.hpp>

BasicFeatureVisualizer::BasicFeatureVisualizer() {
    detector = new cv::ORB(1000, 1.4f, 8, 31, 0, 2, cv::ORB::HARRIS_SCORE, 31);
}

BasicFeatureVisualizer::~BasicFeatureVisualizer() {
    delete detector;
}

void BasicFeatureVisualizer::processImage(cv::Mat &image) {

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

/*
 
CODE FOR HAAR CASCADE FACE DETECTOR , USE SOME OF THE TRAINING FILES. THEN GET REGION OF FACE AND THEN DETECT EYES!
 
cv::Mat grayImage;
std::vector<cv::Rect> faces;

cv::cvtColor(image, grayImage, CV_BGR2GRAY);
cv::equalizeHist(grayImage, grayImage);
self.faceDetector.detectMultiScale(grayImage, faces);

for (std::vector<cv::Rect>::iterator it = faces.begin(); it != faces.end();
     it++)
cv::rectangle(image, *it, cv::Scalar(0,255,0));

*/