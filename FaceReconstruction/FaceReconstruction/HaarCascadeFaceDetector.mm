//
//  HaarCascadeFaceDetector.cpp
//  FaceReconstruction
//
//  Created by Olee on 22.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

#include "HaarCascadeFaceDetector.h"

#include <opencv2/highgui/highgui.hpp>
#import <opencv2/opencv.hpp>

// Comment this if you want to perform eye detection independent of face detection
#define LOOK_FOR_EYES_IN_FACES

HaarCascadeFaceDetector::HaarCascadeFaceDetector() {
    NSString *faceXMLPath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
    NSString *eyesXMLPath = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye" ofType:@"xml"];
    
    faceDetector = new cv::CascadeClassifier();
    faceDetector->load([faceXMLPath UTF8String]);
    
    eyeDetector = new cv::CascadeClassifier();
    eyeDetector->load([eyesXMLPath UTF8String]);
}

HaarCascadeFaceDetector::~HaarCascadeFaceDetector() {
    delete faceDetector;
    delete eyeDetector;
}

void HaarCascadeFaceDetector::processImage(cv::Mat &image) {
    
    double S = 2.0;

    cv::Mat rgbImage;
    cvtColor(image, rgbImage, CV_BGRA2BGR);

    cv::Mat grayImage, grayImageSmaller;
    cv::cvtColor(image, grayImage, CV_BGR2GRAY);
    
    NSLog(@"%d %d", grayImage.cols, grayImage.rows);
    
    cv::pyrDown(grayImage, grayImageSmaller, cv::Size( floor(grayImage.cols/S), floor(grayImage.rows/S)));
    cv::equalizeHist(grayImageSmaller, grayImageSmaller);
    
    NSLog(@"smaller %d %d", grayImageSmaller.cols, grayImageSmaller.rows);

    std::vector<cv::Rect> faces;

    faceDetector->detectMultiScale(grayImageSmaller, faces, 1.1, 2, CV_HAAR_SCALE_IMAGE, cv::Size(floor(50/S), floor(50/S)) );
    
#ifdef LOOK_FOR_EYES_IN_FACES
    for( size_t i = 0; i < faces.size(); i++ ) {
        cv::Point center( S*(faces[i].x + faces[i].width*0.5), S*(faces[i].y + faces[i].height*0.5) );
        cv::ellipse(rgbImage, center, cv::Size( S*(faces[i].width*0.5), S*(faces[i].height*0.5)), 0, 0, 360, cv::Scalar( 0, 255, 255 ), 2, 8, 0 );
        
        cv::Mat faceROI = grayImageSmaller( faces[i] );
        std::vector<cv::Rect> eyes;
        
        eyeDetector->detectMultiScale(faceROI, eyes, 1.1, 2, CV_HAAR_SCALE_IMAGE, cv::Size(floor(15/S), floor(15/S)) );
        
        for( size_t j = 0; j < eyes.size(); j++ ) {
            cv::Point center( S*(faces[i].x + eyes[j].x + eyes[j].width*0.5), S*(faces[i].y + eyes[j].y + eyes[j].height*0.5) );
            int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25*S );
            cv::circle(rgbImage, center, radius, cv::Scalar( 0, 255, 0 ), 2, 8, 0 );
        }
    }
#else
    for( size_t i = 0; i < faces.size(); i++ ) {
        cv::Point center( S*(faces[i].x + faces[i].width*0.5), S*(faces[i].y + faces[i].height*0.5) );
        cv::ellipse(rgbImage, center, cv::Size( S*faces[i].width*0.5, S*faces[i].height*0.5), 0, 0, 360, cv::Scalar( 0, 255, 255 ), 2, 8, 0 );
    }
    
    std::vector<cv::Rect> eyes;
    eyeDetector->detectMultiScale(grayImageSmaller, eyes, 1.1, 2, CV_HAAR_SCALE_IMAGE, cv::Size(floor(30/S), floor(30/S)), cv::Size(floor(100/S), floor(100/S)));
    
    for( size_t j = 0; j < eyes.size(); j++ ) {
        cv::Point center( S*(eyes[j].x + eyes[j].width*0.5), S*(eyes[j].y + eyes[j].height*0.5) );
        int radius = cvRound( (eyes[j].width + eyes[j].height)*0.25*S );
        cv::circle(rgbImage, center, radius, cv::Scalar( 0, 255, 0 ), 2, 8, 0 );
    }
#endif
    
    
    cv::cvtColor(rgbImage, image, CV_BGR2BGRA);
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