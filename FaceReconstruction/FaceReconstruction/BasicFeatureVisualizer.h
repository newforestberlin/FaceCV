//
//  BasicFeatureVisualizer.h
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#ifndef __FaceReconstruction__BasicFeatureVisualizer__
#define __FaceReconstruction__BasicFeatureVisualizer__

#include <stdio.h>
#include "Processor.h"

#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>

class BasicFeatureVisualizer: public Processor {
    
public:
    
    BasicFeatureVisualizer();
    ~BasicFeatureVisualizer();
    
    void processImage(cv::Mat &image);
    
private:
    
    cv::ORB *detector;
    
};

#endif /* defined(__FaceReconstruction__BasicFeatureVisualizer__) */
