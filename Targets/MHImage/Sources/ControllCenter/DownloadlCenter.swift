//
//  ControllCenter.swift
//  OperationPractice
//
//  Created by LittleFoxiOSDeveloper on 11/1/23.
//

import Foundation
import UIKit
import Combine
import SwiftUI

public class DownloadCenter: NSObject{
    
    static let `default` = DownloadCenter()
    
    //오퍼레이션 생성 (Task들이 들어가는 큐 생성)
    public var loadQueue: OperationQueue = {
        let q = OperationQueue()
        q.name = "loadQueueName"
        q.maxConcurrentOperationCount = 1 //한번에 돌릴 수 있는 최대 오퍼레이션 갯수
        return q
    }()
    
    //오퍼레이션 관리 <키:오퍼레이션 객체(Task 1개씩)>
    private var loadOperations: NSCache = NSCache<AnyObject, AnyObject>()
    
    //캐시
    private var caches: NSCache = NSCache<AnyObject, AnyObject>()
    
    override init() {
        super.init()
        //메모리부족 노티피케이션
        NotificationCenter.default.addObserver(self, selector: #selector(removeAllCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    //이미지 로딩(다운로드)
    public func loadImage(urlStr: String) -> AnyPublisher<ImageLoadResponse, Never>{
        
        if self.isExistOperation(key: urlStr){
            return Result<ImageLoadResponse, Never>.Publisher(.error(error: .existOperation)).eraseToAnyPublisher()
        }
        
        let downloadOperation = LoaderOperation(urlStr: urlStr)
        
        self.saveOperation(downloadOperation, key: urlStr)
        self.loadQueue.addOperation(downloadOperation)
        
        return downloadOperation.resultSubject.eraseToAnyPublisher()
    }
    
    //캐시
    public func saveCache(_ image: UIImage, key: String){
        self.caches.setObject(image, forKey: key as AnyObject)
    }
    public func getSavedCache(key: String) -> UIImage?{
        return self.caches.object(forKey: key as AnyObject) as? UIImage
    }
    
    
    //오퍼레이션
    public func saveOperation(_ op: LoaderOperation, key: String){
        self.loadOperations.setObject(op, forKey: key as AnyObject)
    }
    public func removeOperation(key: String){
        if self.isExistOperation(key: key){
            self.loadOperations.removeObject(forKey: key as AnyObject)
        }
    }
    private func isExistOperation(key: String) -> Bool{
        if let _ = self.loadOperations.object(forKey: key as AnyObject){
            return true
        }
        return false
    }
    
    @objc private func removeAllCache(){
        self.caches.removeAllObjects()
    }
    
    
}

public class LoaderOperation: Operation{
    
    let urlStr: String
    var image: UIImage?
    
    let resultSubject = PassthroughSubject<ImageLoadResponse, Never>()
    
    init(urlStr: String) {
        self.urlStr = urlStr
    }
    
    public func originMain(){
        
        if self.isCancelled{
            return
        }
        
        let manager = ImageFileManager()
        var error: Error?
        
        if let imageCache = DownloadCenter.default.getSavedCache(key: urlStr){ //캐시 이미지
                image = imageCache
        }else if manager.isExistCacheFile(urlStr: urlStr){ //파일 이미지
            let fileImg = UIImage(contentsOfFile: manager.imageFilePath(urlStr: urlStr)!.path)
//            let fileImg = UIImage(contentsOfFile: manager.imageFilePath(urlStr: urlStr)!.path())
            DownloadCenter.default.saveCache(fileImg!, key: urlStr) // 파일 안에 이미지가 있으면 캐시에 저장?
            image = fileImg
        }else{
            
            do{
                let url = try urlStr.asURL
                let data = try Data(contentsOf: url())
                
                let imageFromData = UIImage(data: data)
                
                if let imageFromData = imageFromData, let folderUrl = manager.imageFilePath(urlStr: urlStr){
                    
                    try imageFromData.pngData()?.write(to: folderUrl)
                    DownloadCenter.default.saveCache(imageFromData, key: urlStr)
                }
                image = imageFromData
                
            }catch let e{
                error = e
            }
            image = nil
        }
        
        DownloadCenter.default.removeOperation(key: urlStr)
    }
    
    //combine 사용
    public override func main() {
        
            if self.isCancelled{
                resultSubject.send(.error(error: .cancelled))
            }
            
            let manager = ImageFileManager()
            
            if let imageCache = DownloadCenter.default.getSavedCache(key: self.urlStr){ //캐시 이미지
                resultSubject.send(.success(image: Image(uiImage: imageCache)))
                
            }else if manager.isExistCacheFile(urlStr: self.urlStr){ //파일 이미지
//                if let fileImg = UIImage(contentsOfFile: manager.imageFilePath(urlStr: self.urlStr)!.path()){
                if let fileImg = UIImage(contentsOfFile: manager.imageFilePath(urlStr: urlStr)!.path){
                    DownloadCenter.default.saveCache(fileImg, key: self.urlStr) // 파일 안에 이미지가 있으면 캐시에 저장
                    resultSubject.send(.success(image: Image(uiImage: fileImg)))
                }else{
                    resultSubject.send(.error(error: .notFoundImageInFile))
                }
            }else{
                
                do{
                    let url = try self.urlStr.asURL
                    let data = try Data(contentsOf: url())
                
                    let imageFromData = UIImage(data: data)
                    
                    if let imageFromData = imageFromData, let folderUrl = manager.imageFilePath(urlStr: self.urlStr){
                        
                        try imageFromData.pngData()?.write(to: folderUrl)
                        DownloadCenter.default.saveCache(imageFromData, key: self.urlStr)
                        
                        resultSubject.send(.success(image: Image(uiImage: imageFromData)))
                    }
//                    observer.onNext(imageFromData)
                    
                }catch let e{
                    resultSubject.send(.error(error: .imageConvertFail(message: e.localizedDescription)))
                }
                resultSubject.send(.error(error: .notFoundImage))
            }
            DownloadCenter.default.removeOperation(key: self.urlStr)
        
    }
}

extension String{
    func asURL() throws -> URL{
        guard let url = URL(string: self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else{
            throw ImageLoadingError.invalidUrl
        }
        return url
    }
}

//enum DataConnectedError: Error{
public enum ImageLoadingError: Error, Equatable{
    case invalidUrl
    case notFoundImage
    case notFoundImageInFile
    case imageConvertFail(message: String)
    case existOperation
    case cancelled
    
    var message: String{
        switch self {
        case .invalidUrl:
            return "유효하지 않은 url"
        case .notFoundImage:
            return "이미지를 찾을 수 없음"
        case .notFoundImageInFile:
            return "파일이 존재하지만 찾을 수 없음"
        case .imageConvertFail(let message):
            return "이미지 변환 에러 \(message)"
        case .existOperation:
            return "이미 존재하는 작업"
        case .cancelled:
            return "취소된 작업"
        }
    }
}

public enum ImageLoadResponse{
    case success(image: Image)
    case error(error: ImageLoadingError)
}
