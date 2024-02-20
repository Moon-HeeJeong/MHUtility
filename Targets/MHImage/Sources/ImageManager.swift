//
//  ImageManager.swift
//  OperationPractice
//
//  Created by LittleFoxiOSDeveloper on 12/13/23.
//

import Foundation
import SwiftUI
import Combine

public class ImageManager: ObservableObject{
    
    @Published public var image: Image?
    @Published public var error: Error?
    
    var cancellables = Set<AnyCancellable>()
    
    public init(){}
    
    public func load(urlStr: String?){
        self.getImageData(urlStr: urlStr)
    }
    
    private func getImageData(urlStr: String?){
        guard let urlStr = urlStr else{
            return
        }
    
        DownloadCenter.default.loadImage(urlStr: urlStr)
            .sink { res in
                switch res {
                case .success(let image):
                    self.image = image
                case .error(let err):
                    self.error = err
                }
            }.store(in: &self.cancellables)
    }
}

