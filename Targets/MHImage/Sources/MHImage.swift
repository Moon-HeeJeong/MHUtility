//
//  MHImage.swift
//  OperationPractice
//
//  Created by LittleFoxiOSDeveloper on 12/13/23.
//

import SwiftUI
import Combine


public struct MHImage: View {
    
    @StateObject var imageManager: ImageManager
    var urlStr: String?
    
    var isUseIndicator: Bool = false
    var defaultImage: Image? = nil
    
    public init(urlStr: String?, isUseIndicator: Bool = false, defaultImage: Image? = nil){
        
        let imageManager = ImageManager()
        _imageManager = StateObject(wrappedValue: imageManager)
        
        self.urlStr = urlStr
        self.isUseIndicator = isUseIndicator
        self.defaultImage = defaultImage
    }
    
    public var body: some View{
        GeometryReader(content: { geometry in
            
        ZStack {
            
            if let image = self.imageManager.image{
                image
                    .resizable()
            }else{
             
                if let err = self.imageManager.error, (err as? ImageLoadingError) != .existOperation{
                    //에러
                    //디폴트 이미지
                    if let img = self.defaultImage{
                        Rectangle()
                            .fill(Color.clear)
//                            .opacity(0.5)
                        
                        
                        let defaultImgHeight = geometry.size.height*0.8
                        let defaultImgWidth = defaultImgHeight*1.5
                        
                        img
                            .resizable()
                            .frame(width: defaultImgWidth, height: defaultImgHeight)
                            .opacity(0.5)
                    }
                }else{
                    //로딩중
                    if isUseIndicator{
                        Rectangle()
                            .fill(Color.clear)
                        ProgressView()
                            .scaleEffect(3, anchor: .center)
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
                
        }.onAppear(perform: {
            self.imageManager.load(urlStr: self.urlStr)
        })
    })
    }
}

extension MHImage{
    
    
    
//    func setOptions(isUseIndicator: Bool = false, isUseDefaultImage: Bool = false, defaultImage: Image? = nil) -> some View{
//        self.isUseIndicator = isUseIndicator
//        self.isUseDefaultImage = isUseDefaultImage
//        if let defaultImage = defaultImage{
//            self.defaultImage = defaultImage
//        }
//        return Color.clear
//
//    }
//    func onIndicator() -> some View{
//        self.isUseIndicator = true
//        return Color.clear
//    }
//    func onDefaultImage(image: Image? = Image(systemName: "photo")) -> some View{
//        self.isUseDefaultImage = true
//        if let image = image{
//            self.defaultImage = image
//        }
//        return Color.clear
//    }
}

#Preview {
    MHImage(urlStr: "https://cdn.littlefox.co.kr/phonicsworks/flashcard/image/card_front_alligator.jpg", isUseIndicator: true, defaultImage: Image(systemName: "photo"))
//        .setOptions(isUseIndicator: true, isUseDefaultImage: true)
//        .onIndicator()
//        .onDefaultImage(image: Image(systemName: "photo"))
}
