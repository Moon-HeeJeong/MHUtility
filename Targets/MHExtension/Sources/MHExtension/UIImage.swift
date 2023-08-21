//
//  File.swift
//  
//
//  Created by LittleFoxiOSDeveloper on 2023/05/23.
//

import Foundation
import UIKit

extension UIImage {
    public func getPixelColor(point: CGPoint) -> UIColor? {
       guard let cgImage = self.cgImage, let dataProvider = cgImage.dataProvider,  let pixelData = dataProvider.data else {
           return nil
       }
       let data = CFDataGetBytePtr(pixelData)
       let x = Int(point.x)
       let y = Int(point.y)
       let index = Int(self.size.width) * y + x
       let expectedLengthA = Int(self.size.width * self.size.height)
       let expectedLengthRGB = 3 * expectedLengthA
       let expectedLengthRGBA = 4 * expectedLengthA
       let numBytes = CFDataGetLength(pixelData)
       
       if let _ = data{
           switch numBytes {
           case expectedLengthA:
               return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data![index])/255.0)
           case expectedLengthRGB:
               return UIColor(red: CGFloat(data![3*index])/255.0, green: CGFloat(data![3*index+1])/255.0, blue: CGFloat(data![3*index+2])/255.0, alpha: 1.0)
           case expectedLengthRGBA:
               return UIColor(red: CGFloat(data![4*index])/255.0, green: CGFloat(data![4*index+1])/255.0, blue: CGFloat(data![4*index+2])/255.0, alpha: CGFloat(data![4*index+3])/255.0)
           default:
               return nil
           }
       }else{
           return nil
       }
   }
   
   
   
    public func pixel(at point: CGPoint) -> (UInt8, UInt8, UInt8, UInt8)? {
       let width = Int(self.size.width)
       let height = Int(self.size.height)
       let x = Int(point.x)
       let y = Int(point.y)
       guard x < width && y < height else {
           return nil
       }
       guard let cfData:CFData = self.cgImage?.dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) else {
           return nil
       }
       let bytesPerPixel = 4
       let offset = (x + y * width) * bytesPerPixel
       return (pointer[offset], pointer[offset + 1], pointer[offset + 2], pointer[offset + 3])
   }
   
    public func cropImage(totalImageCount : Int) -> [UIImage] {
       
       var images = [UIImage]()
       
       let scaleFactor = UIScreen.main.scale
       let imageSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
       let standardImageHeight: CGFloat = imageSize.height / CGFloat(totalImageCount)
       
       for i in 0..<totalImageCount{
           let cropRect = CGRect(origin: CGPoint(x: 0,y:standardImageHeight * CGFloat(i)), size: CGSize(width: imageSize.width, height: standardImageHeight))
           let imageRef : CGImage = self.cgImage!.cropping(to: cropRect)!
           let image = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
           images.append(image)
       }
       
       return images
   }
    
    public func cropImage(oneHeight :CGFloat) -> [UIImage] {
        let totalImageCount = Int(self.size.height/(oneHeight/UIScreen.main.scale))
        return self.cropImage(totalImageCount: totalImageCount)
    }
   
    public var cropImageFitHeight: UIImage {
       get{
           let scaleFactor: CGFloat = UIScreen.main.scale
           let imageSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
           
           let cropRect = CGRect(origin: CGPoint(x: (imageSize.width-imageSize.height)/2.0, y: 0), size: CGSize(width: imageSize.height, height: imageSize.height))
           let selfCGimage = self.cgImage
           if let cropImage = selfCGimage?.cropping(to: cropRect){
               let image = UIImage(cgImage: cropImage, scale: self.scale, orientation: self.imageOrientation)
               return image
           }
           
           return self
       }
   }
   
   public func reSize(with newSize: CGSize) -> UIImage?{
       UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
       self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
       let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return newImage
   }
   
    
   
}
