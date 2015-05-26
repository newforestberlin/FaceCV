//
//  ShapeSpec.swift
//  SimpleCascadeClassifierExperiment
//
//  Created by Olee on 26.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

import Foundation

enum ShapeSpecType {
    case Circle
    case Square
    case Cross
    case Unknown
    
    
    static func randomType() -> ShapeSpecType {
        let r = rand() % 3
        
        switch r {
        case 0:
            return .Circle
        case 1:
            return .Square
        case 2:
            return .Cross
        default:
            return .Unknown
        }                
    }
}

struct ShapeSpec {
    
    // Type of the shape
    var shapeType: ShapeSpecType
    
    // Center of the shape in normalized coordinates (1.0 = full image width and height)
    var center: NSPoint = NSPoint.zeroPoint
    
    // Width and height of the shape in normalized coordinates (1.0 = full image width and height)
    var size: CGFloat = 0.1

}