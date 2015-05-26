//
//  TestImageFactory.swift
//  SimpleCascadeClassifierExperiment
//
//  Created by Olee on 26.05.15.
//  Copyright (c) 2015 you & the gang. All rights reserved.
//

import Cocoa

class TestImageFactory {
    
    class func randf() -> CGFloat {
        return CGFloat(rand()) / CGFloat(RAND_MAX)
    }
    
    class func createRandomImagesWithSize(size: CGFloat, count: Int, shapesPerImage: Int) -> [TestImage] {
        
        var result = [TestImage]()
        
        for k in 0..<count {
            
            var shapes = [ShapeSpec]()
            
            for n in 0..<shapesPerImage {
                
                while true {
                    let t = ShapeSpecType.randomType()
                    let s = 0.05 + 0.15 * TestImageFactory.randf()
                    let pad = 0.5*s
                    let c = NSMakePoint(pad+TestImageFactory.randf()*(1.0-2.0*pad), pad+TestImageFactory.randf()*(1.0-2.0*pad))
                    let shape = ShapeSpec(shapeType: t, center: c, size: s)
                    
                    var isAllowed = true
                    
                    for s in shapes {
                        let dx = s.center.x - shape.center.x
                        let dy = s.center.y - shape.center.y
                        let d = sqrt(dx*dx+dy*dy)
                        
                        if d < 0.75*(shape.size + s.size) {
                            isAllowed = false
                            break
                        }
                    }
                    
                    if isAllowed {
                        shapes.append(shape)
                        break
                    }
                }
            }
            
            let testImage = TestImageFactory.createImageWithSize(size, withShapes: shapes)
            result.append(testImage)
        }
        
        return result
    }
    
    class func createImageWithSize(size: CGFloat, withShapes shapes: [ShapeSpec]) -> TestImage {
        
        let result = TestImage()
        
        result.image = NSImage(size: NSMakeSize(size, size))
        result.shapes = shapes
        
        result.image?.lockFocus()

        NSColor.whiteColor().set()
        NSBezierPath.fillRect(NSMakeRect(0, 0, size, size))

        for shape in shapes {
            
            let center = CGPointMake(size * shape.center.x, size * shape.center.y)
            let s = shape.size * size
            
            NSColor.blackColor().set()
            
            switch shape.shapeType {
            case .Circle:
                NSBezierPath(ovalInRect: NSMakeRect(center.x-0.5*s, center.y-0.5*s, s, s)).stroke()
                
            case .Square:
                NSBezierPath.strokeRect(NSMakeRect(center.x-0.5*s, center.y-0.5*s, s, s))
                
            case .Cross:
                let path = NSBezierPath()
                
                path.moveToPoint(NSMakePoint(center.x-0.5*s, center.y-0.5*s))
                path.lineToPoint(NSMakePoint(center.x+0.5*s, center.y+0.5*s))
                
                path.moveToPoint(NSMakePoint(center.x+0.5*s, center.y-0.5*s))
                path.lineToPoint(NSMakePoint(center.x-0.5*s, center.y+0.5*s))
                                
                path.stroke()
                
            default:
                ()
            }
        }
        
        result.image?.unlockFocus()

        return result
    }
    
}




