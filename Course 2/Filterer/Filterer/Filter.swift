//
//  Filter.swift
//  Filterer
//
//  Created by Daniel Alejandro Carriola on 30.05.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import Foundation
import UIKit

enum FilterName {
    case red
    case green
    case blue
    case grayScale
    case sepia
}

class Filter {
    
    fileprivate var _image: RGBAImage!
    
    init(image: UIImage) {
        _image = RGBAImage(image: image)
    }
    
    func applyFilter(withName name: FilterName) -> UIImage? {
        switch name {
        case .red:
            return enhanceRed()
        case .green:
            return enhanceGreen()
        case .blue:
            return enhanceBlue()
        case .grayScale:
            return grayScale()
        case .sepia:
            return sepia()
        }
    }
    
    func enhanceRed(withIntensity intensity: Int = 0) -> UIImage? {
        var temp: RGBAImage = _image
        for y in 0 ..< temp.height {
            for x in 0 ..< temp.width {
                let index = y * temp.width + x
                var pixel = temp.pixels[index]
                let redDelta = Int(pixel.red) - intensity
                var modifier = 1 + 4 * (Double(y) / Double(temp.height))
                
                if Int(pixel.red) < intensity {
                    modifier = 1
                }
                
                pixel.red = UInt8(max(min(255, Int(round(Double(intensity) + modifier * Double(redDelta)))), 0))
                temp.pixels[index] = pixel
            }
        }
        return temp.toUIImage()
    }
    
    func enhanceGreen(withIntensity intensity: Int = 0) -> UIImage? {
        var temp: RGBAImage = _image
        for y in 0 ..< temp.height {
            for x in 0 ..< temp.width {
                let index = y * temp.width + x
                var pixel = temp.pixels[index]
                let greenDelta = Int(pixel.green) - intensity
                var modifier = 1 + 4 * (Double(y) / Double(temp.height))
                
                if Int(pixel.green) < intensity {
                    modifier = 1
                }
                
                pixel.green = UInt8(max(min(255, Int(round(Double(intensity) + modifier * Double(greenDelta)))), 0))
                temp.pixels[index] = pixel
            }
        }
        return temp.toUIImage()
    }
    
    func enhanceBlue(withIntensity intensity: Int = 0) -> UIImage? {
        var temp: RGBAImage = _image
        for y in 0 ..< temp.height {
            for x in 0 ..< temp.width {
                let index = y * temp.width + x
                var pixel = temp.pixels[index]
                let blueDelta = Int(pixel.blue) - intensity
                var modifier = 1 + 4 * (Double(y) / Double(temp.height))
                
                if Int(pixel.blue) < intensity {
                    modifier = 1
                }
                
                pixel.blue = UInt8(max(min(255, Int(round(Double(intensity) + modifier * Double(blueDelta)))), 0))
                temp.pixels[index] = pixel
            }
        }
        return temp.toUIImage()
    }
    
    func grayScale() -> UIImage? {
        var temp: RGBAImage = _image
        for y in 0 ..< temp.height {
            for x in 0 ..< temp.width {
                let index = y * temp.width + x
                var pixel = temp.pixels[index]
                
                pixel.red = UInt8(max(min(255, (Double(pixel.red) * 0.299) + (Double(pixel.green) * 0.587) + (Double(pixel.blue) * 0.114)), 0))
                pixel.green = UInt8(max(min(255, (Double(pixel.red) * 0.299) + (Double(pixel.green) * 0.587) + (Double(pixel.blue) * 0.114)), 0))
                pixel.blue = UInt8(max(min(255, (Double(pixel.red) * 0.299) + (Double(pixel.green) * 0.587) + (Double(pixel.blue) * 0.114)), 0))
                temp.pixels[index] = pixel
            }
        }
        return temp.toUIImage()
    }
    
    func sepia() -> UIImage? {
        var temp: RGBAImage = _image
        for y in 0 ..< temp.height {
            for x in 0 ..< temp.width {
                let index = y * temp.width + x
                var pixel = temp.pixels[index]
                
                pixel.red = UInt8(max(min(255, (Double(pixel.red) * 0.393) + (Double(pixel.green) * 0.769) + (Double(pixel.blue) * 0.189)), 0))
                pixel.green = UInt8(max(min(255, (Double(pixel.red) * 0.349) + (Double(pixel.green) * 0.686) + (Double(pixel.blue) * 0.168)), 0))
                pixel.blue = UInt8(max(min(255, (Double(pixel.red) * 0.272) + (Double(pixel.green) * 0.534) + (Double(pixel.blue) * 0.131)), 0))
                temp.pixels[index] = pixel
            }
        }
        return temp.toUIImage()
    }
    
}
