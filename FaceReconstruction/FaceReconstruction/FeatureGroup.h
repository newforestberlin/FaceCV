//
//  FeatureGroup.h
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#ifndef __FaceReconstruction__FeatureGroup__
#define __FaceReconstruction__FeatureGroup__

#include <stdio.h>

#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>

// MARK: Feature

class Feature {
public:
    cv::KeyPoint *keypoint;
    cv::Mat *descriptor;
};

// MARK: FeatureGroup

class FeatureGroup {
public:
    
    FeatureGroup(Feature firstFeature);
    
    void getCenter(double *x, double *y);
    
    void addFeature(Feature feature);
    
    int featureCount();
    
    void beingEditing();
    void endEditingAndIncreaseAgeIfNotChanged();
    int getCountOfNonChangedEditingFrames();
    
private:
    
    std::vector<Feature> features;
    
    double centerX, centerY;
    
    bool centerIsUpToDate;
    
    bool changedInThisEditingFrame = false;
    
    int countOfNonChangedEditingFrames;
    
};

#endif /* defined(__FaceReconstruction__FeatureGroup__) */
