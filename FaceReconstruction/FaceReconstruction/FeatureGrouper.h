//
//  FeatureGrouper.h
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#ifndef __FaceReconstruction__FeatureGrouper__
#define __FaceReconstruction__FeatureGrouper__

#include <stdio.h>
#include "Processor.h"

#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>

#include "FeatureGroup.h"

// This one does not compare descriptors of features. But it shows the direction we are going.
// The SimilarityFeatureGrouper should use descriptor similarity to put features in groups.
// If a feature is within reach of a group and is similar enough to an feature already in the
// group, it replaces that feature in the given group. This might compensate for slight differences
// in descriptor values and could make everything more stable.
class FeatureGrouper: public Processor {
    
public:
    
    FeatureGrouper();
    ~FeatureGrouper();
    
    void processImage(cv::Mat &image);
    
private:
    
    FeatureGroup *groupForPosition(double x, double y);
    
    cv::ORB *detector;
    
    std::vector<FeatureGroup> groups;
        
};

#endif /* defined(__FaceReconstruction__FeatureGrouper__) */
