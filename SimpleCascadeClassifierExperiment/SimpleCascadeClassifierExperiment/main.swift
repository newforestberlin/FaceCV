//
//  main.swift
//  SimpleCascadeClassifierExperiment
//
//  Created by Olee on 26.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

import Foundation

let testImages = TestImageFactory.createRandomImagesWithSize(200, count: 30, shapesPerImage: 10)

var k = 0
for testImage in testImages {
    testImage.exportImageToPath("/Users/olee/Desktop/TestImage\(k).tiff")
    k++
}

println("Done")




