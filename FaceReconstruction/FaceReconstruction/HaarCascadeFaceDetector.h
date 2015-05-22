//
//  HaarCascadeFaceDetector.h
//  FaceReconstruction
//
//  Created by Olee on 22.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#ifndef __FaceReconstruction__HaarCascadeFaceDetector__
#define __FaceReconstruction__HaarCascadeFaceDetector__

#include <stdio.h>
#include "Processor.h"

#include <opencv2/core/core.hpp>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/imgproc/imgproc.hpp>

class HaarCascadeFaceDetector: public Processor {
    
public:
    
    HaarCascadeFaceDetector();
    ~HaarCascadeFaceDetector();
    
    void processImage(cv::Mat &image);
    
private:
    
    cv::CascadeClassifier *faceDetector;
    cv::CascadeClassifier *eyeDetector;
    
};

#endif /* defined(__FaceReconstruction__HaarCascadeFaceDetector__) */
