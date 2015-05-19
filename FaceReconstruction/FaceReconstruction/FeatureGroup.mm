//
//  FeatureGroup.cpp
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#include "FeatureGroup.h"

#define FeatureGroup_MaxSize 20

FeatureGroup::FeatureGroup(Feature firstFeature) {
    features.push_back(firstFeature);
    
    centerIsUpToDate = false;
    countOfNonChangedEditingFrames = 0;
}

// MARK: Adding features

void FeatureGroup::addFeature(Feature feature) {
    changedInThisEditingFrame = true;
    countOfNonChangedEditingFrames = 0;
    
    features.push_back(feature);
    
    if (features.size() > FeatureGroup_MaxSize) {
        features.erase(features.begin());
    }
    
    centerIsUpToDate = false;
}

// MARK: Center

void FeatureGroup::getCenter(double *x, double *y) {
    if (centerIsUpToDate==false) {
        
        centerX = 0.0;
        centerY = 0.0;
        
        double normalizer = 0.0;
        
        for(std::vector<Feature>::iterator it = features.begin(); it != features.end(); ++it) {
            Feature f = *it;
            
            centerX += f.keypoint->pt.x;
            centerY += f.keypoint->pt.y;
            
            normalizer += 1.0;
        }
        
        centerX /= normalizer;
        centerY /= normalizer;
        
        centerIsUpToDate = true;
    }
    
    *x = centerX;
    *y = centerY;
}

// MARK: Feature count

int FeatureGroup::featureCount() {
    return features.size();
}

// MARK: Editing

void FeatureGroup::beingEditing() {
    changedInThisEditingFrame = false;
}

void FeatureGroup::endEditingAndIncreaseAgeIfNotChanged() {
    
    if (changedInThisEditingFrame == false) {
        countOfNonChangedEditingFrames++;
    }
    
}

int FeatureGroup::getCountOfNonChangedEditingFrames() {
    return countOfNonChangedEditingFrames;
}







