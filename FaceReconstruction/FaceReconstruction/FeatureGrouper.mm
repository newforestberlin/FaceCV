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

#define FeatureGrouper_GroupRadius 10.0
#define FeatureGrouper_MaxGroupAge 5.0

FeatureGrouper::FeatureGrouper() {
    detector = new cv::ORB(1000, 1.4f, 8, 31, 0, 2, cv::ORB::HARRIS_SCORE, 31);
}

FeatureGrouper::~FeatureGrouper() {
    delete detector;
}

// MARK: Processing

void FeatureGrouper::processImage(cv::Mat &image) {
        
    cv::Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // Detect keypoints
    std::vector<cv::KeyPoint> keypoints;
    detector->detect(image_copy, keypoints);
    
    NSLog(@"keypoints = %ld", keypoints.size());
    
    // Compute descriptors for all keypoints
    cv::Mat descriptors;
    detector->compute(image_copy, keypoints, descriptors);
    
    for(std::vector<FeatureGroup>::size_type i = 0; i != groups.size(); i++) {
        groups[i].beingEditing();
    }

    for(std::vector<cv::KeyPoint>::size_type i = 0; i != keypoints.size(); i++) {
        cv::KeyPoint kp = keypoints[i];
        
        double x = kp.pt.x;
        double y = kp.pt.y;
        
        // Create new feature
        Feature *newFeature = new Feature();
        newFeature->keypoint = new cv::KeyPoint(kp);
        
        // Get descriptor
        newFeature->descriptor = new cv::Mat(descriptors.row(i));
        
        FeatureGroup *group = groupForPosition(x, y);
        if (group == NULL) {
            group = new FeatureGroup(*newFeature);
            groups.push_back(*group);
        }
        else {
            group->addFeature(*newFeature);
        }
    }
    
    for(std::vector<FeatureGroup>::size_type i = 0; i != groups.size(); i++) {
        groups[i].endEditingAndIncreaseAgeIfNotChanged();
    }
    
    // Remove groups that are too old
    std::vector<FeatureGroup>::iterator groupIterator = groups.begin();
    while (groupIterator != groups.end()) {
        if (groupIterator->getCountOfNonChangedEditingFrames() > FeatureGrouper_MaxGroupAge) {
            groupIterator = groups.erase(groupIterator);
        }
        else {
            ++groupIterator;
        }
    }
    
    cv::Mat resultImage;
    cv::drawKeypoints(image_copy, keypoints, resultImage);
    
    for(std::vector<FeatureGroup>::size_type i = 0; i != groups.size(); i++) {
        FeatureGroup fg = groups[i];
        
        double centerX, centerY;
        fg.getCenter(&centerX, &centerY);
        
        cv::Point p;
        p.x = (int)centerX;
        p.y = (int)centerY;
        
        if (fg.getCountOfNonChangedEditingFrames() > FeatureGrouper_MaxGroupAge) {
            cv::Scalar color(0, 80, 0);
            cv::circle(resultImage, p, FeatureGrouper_GroupRadius, color);
        }
        else {
            cv::Scalar color(0, 255, 0);
            cv::circle(resultImage, p, FeatureGrouper_GroupRadius, color);
        }
    }
    
    cvtColor(resultImage, image, CV_BGR2BGRA);
}

// MARK: Groups

FeatureGroup *FeatureGrouper::groupForPosition(double x, double y) {
    
    for(std::vector<FeatureGroup>::size_type i = 0; i != groups.size(); i++) {
        FeatureGroup fg = groups[i];
        
        if (fg.getCountOfNonChangedEditingFrames() >= FeatureGrouper_MaxGroupAge) continue;
        
        double centerX, centerY;
        fg.getCenter(&centerX, &centerY);
        
        double dx = x - centerX;
        double dy = y - centerY;
        double delta = sqrt(dx*dx+dy*dy);
        
        if (delta < FeatureGrouper_GroupRadius) {
            
            return &groups[i];
        }
    }
    
    return NULL;
}



