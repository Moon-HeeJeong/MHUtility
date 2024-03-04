//
//  MHLog.swift
//  Phonics
//
//  Created by LittleFoxiOSDeveloper on 2023/07/21.
//  Copyright © 2023 com.littlefox. All rights reserved.
//

import Foundation

public enum MHLogKind{
    case debug(message: String)
    case info(message: String)
    case network(message: String)
    case error(message: String)
    
    public var title: String{
        switch self {
        case .debug:
            return "🟡 DEBUG"
        case .info:
            return "🔵 INFO"
        case .network:
            return "🟢 NETWORK"
        case .error:
            return "🔴 ERROR"
        }
    }
    
    public var message: String{
        switch self {
        case .debug(let message):
            return message
        case .info(let message):
            return message
        case .network(let message):
            return message
        case .error(let message):
            return message
        }
    }
    
    public var desc: String{
        "\(self.title) \(self.message)"
    }
}

public class MHLog: NSObject{
    
    static public let work = MHLog()
    
    static public func write(_ str: MHLogKind, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function){
        
        //디버그일때 로그찍고, 릴리즈일 땐 아무것도 안찍는다
        #if DEBUG
        let log: String = {
            let fileNameStr = (fileName.components(separatedBy: "/").last)?.components(separatedBy: ".").first
            return "\(work.now) \(String(describing: fileNameStr))(\(functionName)) \(lineNumber): \(str.desc)\n"
        }()
        
        print(log)
        #endif
        //
    }
    
    private var now: String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSS"
        dateFormat.locale = Locale.current
        return dateFormat.string(from: Date())
    }
    
    
    // 이 밑은 Log 파일을 만든다면 사용
    
    let folderName = "Log"
    let fileName = "log.txt"
    let limitedFileSize: UInt64 = 20*1024*1024 //20MB
    
    public var dataToAttachToEmail: Data?{
        if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first{
            let path = cacheDir.appendingPathComponent(folderName)
            let fileUrl: URL? = path.appendingPathComponent(fileName)
            return try? Data(contentsOf: fileUrl!)
        }
        return nil
    }
    
    private func toFile(log: String){
        if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first{
            let path = cacheDir.appendingPathComponent(folderName)
            let textPath = path.appendingPathComponent(fileName)
            
            let fileSize = sizeForLocalFilePath(filePath: textPath.relativePath)
            if fileSize > limitedFileSize{
                try? FileManager.default.removeItem(at: textPath)
            }
            
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            let t = (toText() ?? "") + "\n" + log
            try? t.write(to: textPath, atomically: false, encoding: String.Encoding.utf8)
            
        }
    }
    
    private func sizeForLocalFilePath(filePath: String) -> UInt64{
        do{
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
            if let fileSize = fileAttributes[FileAttributeKey.size]{
                return (fileSize as! NSNumber).uint64Value
            }else{
                print("Failed to get a size attribute from path: \(filePath)")
            }
        }catch {
            print("Failed to get file attributes for local path: \(filePath) with error: \(error)")
        }
        return 0
    }
    
    private func toText() -> String?{
        if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first{
            let path = cacheDir.appendingPathComponent(folderName).appendingPathComponent(fileName)
            let t = try? String(contentsOf: path, encoding: String.Encoding.utf8)
            return t
        }
        return nil
    }
    
}
