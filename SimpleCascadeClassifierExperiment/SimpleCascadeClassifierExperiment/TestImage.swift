//
//  TestImage.swift
//  SimpleCascadeClassifierExperiment
//
//  Created by Olee on 26.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

import Cocoa

class TestImage {
    
    var image: NSImage?    
    var shapes: [ShapeSpec]?
    
    func exportImageToPath(path: String) {
        if let image = image {
            if let tiffData = image.TIFFRepresentation {
                tiffData.writeToFile(path, atomically: true)
            }
        }
    }

}