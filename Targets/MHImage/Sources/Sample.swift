//
//  Sample.swift
//  MHImage
//
//  Created by LittleFoxiOSDeveloper on 2/21/24.
//

import Foundation
import Combine
import SwiftUI

struct ListData: Hashable{
    var idx: Int
    var image: Image?
    var resultStr: String
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(idx)
    }
}

//* DownloadCenter를 이용하는 경우
class ContentVM: ObservableObject{
    
    var urlStrs: [String] = ["https://cdn.littlefox.co.kr/phonicsworks/flashcard/image/card_front_alligator.jpg",
                             "https://cdn.littlefox.co.kr/phonicsworks/flashcard/image/card_back_alligator.jpg",
                             "https://cdn.littlefox.co.kr/phonicsworks/flashcard/image/card_front_alligator.jpg",
                             "https://cdn.littlefox.co.kr/phonicsworks/flashcard/image/card_front_alligator.jg"
    ]
    
    @Published var imageDatas: [ListData] = []
    
    var cancellables = Set<AnyCancellable>()
    
    func getImageData(){
        imageDatas.removeAll()
        imageDatas = []
        
        for i in 0..<urlStrs.count {
            
            DownloadCenter.default.loadImage(urlStr: urlStrs[i])
                .sink { res in
                switch res {
                case .success(let image):
                    self.imageDatas.append(ListData(idx: i+1, image: image, resultStr: "success"))
                case .error(let err):
                    self.imageDatas.append(ListData(idx: i+1, image: nil, resultStr: err.message))
                }
            }.store(in: &self.cancellables)
        }
    }
}


struct ContentView: View {
    
    @StateObject var viewModel = ContentVM()
    
    var cancellables = Set<AnyCancellable>()
    
    //* MHImage를 이용하는 경우
    var body: some View {
        
        VStack {
            ForEach(viewModel.urlStrs, id: \.self){ value in
                HStack(content: {
                    
                    MHImage(urlStr: value, isUseIndicator: true, defaultImage: Image(systemName: "photo"))
//                        .setOptions(isUseIndicator: true, isUseDefaultImage: true)
                })
            }
                
        }
        .padding()
    }
    
    //* DownloadCenter를 이용하는 경우
//    var body: some View {
//
//        VStack {
//
//            ForEach($viewModel.imageDatas, id: \.self) { value in
//                HStack(content: {
////                    Text("\(value.idx.wrappedValue)")
//
//                    value.image.wrappedValue?
//                        .resizable()
//                    Spacer()
//                    Text(value.resultStr.wrappedValue)
//                })
//                }
//        }
//        .padding()
//        .onAppear {
//            self.viewModel.getImageData()
//        }
//    }
}

#Preview {
    ContentView()
}
