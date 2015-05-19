//
//  Processor.h
//  FaceReconstruction
//
//  Created by Olee on 19.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#ifndef FaceReconstruction_Processor_h
#define FaceReconstruction_Processor_h

#import <opencv2/highgui/cap_ios.h>
#import <opencv2/imgproc/types_c.h>

class Processor {
public:    
    virtual void processImage(cv::Mat &image) = 0;
};

#endif
