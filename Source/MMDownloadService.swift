//
//  MMDownloadService.swift
//  MMAvatarLoadingView
//
//  Created by Mohamed EL Meseery on 7/21/18.
//

import UIKit

typealias OnSuccessHandler = (Data?) -> ()
typealias OnFailureHandler = (Error?) -> ()
typealias ProgressHandler = (Float) -> ()

class MMDownloadService : NSObject {
    
    public var isCacheEnabled : Bool = false
    
    private var downloadSession : URLSession {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    }
    private var downloadTask : URLSessionDownloadTask?
    
    /// Monitor Download
    private var onProgress : ProgressHandler?
    private var onSuccess : OnSuccessHandler?
    private var onFailure : OnFailureHandler?
    
    /// Cache
    private var cache : MMDataCache?
    private var invalidURLS = Set<URL>()
    
    override init() {
        super.init()
    }
    
    convenience init(cacheMaxImagesCount:Int,
                     cacheOnDiskSizeInBytes:Int) {
        self.init()
        cache = MMDataCache.init(maximumNumberOfObjects: cacheMaxImagesCount, maximumDiskStorage: cacheOnDiskSizeInBytes)
        isCacheEnabled = true
    }
    
    public func downloadFile(withURL downloadURL:URL,
                             onProgress:@escaping ProgressHandler,
                             onSuccess:@escaping OnSuccessHandler,
                             onFailure:@escaping OnFailureHandler) {
        if downloadTask?.state == .running {
            downloadTask?.cancel()
        }
        /// If invalid URL
        if invalidURLS.contains(downloadURL){
            let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
            onFailure(error)
            return
        }
        
        /// If cached, return it
        if let data = cache?.object(forKey: downloadURL.absoluteString as NSString) as Data? {
            onSuccess(data)
            return
        }
        
        let request = URLRequest.init(url: downloadURL, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15.0)
        
        /// Otherwise download
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.onProgress = onProgress
        
        
        downloadTask = downloadSession.downloadTask(with: request)
        downloadTask?.resume()
    }
}

extension MMDownloadService : URLSessionDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let err = error as NSError? {
            switch err.code {
            case NSURLErrorUnsupportedURL,
                 NSURLErrorCannotFindHost,
                 NSURLErrorBadURL,
                 NSURLErrorTimedOut:
                if let invalidURL = task.originalRequest?.url {
                    self.invalidURLS.insert(invalidURL)
                }
            default:
                break
            }
        }
        if let failureHandler = onFailure {
            failureHandler(error)
        }
    }
}

extension MMDownloadService : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let onProgress = onProgress {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            onProgress(progress)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let fileData = try? Data.init(contentsOf: location) {
            if isCacheEnabled,
                let downloadURL = downloadTask.currentRequest?.url?.absoluteString
            {
                cache?.setObject(fileData as NSData,
                                 forKey: downloadURL as NSString,
                                 cost:(fileData as NSData).length)
            }
            if let successHandler = onSuccess {
                successHandler(fileData)
            }
        }
        try? FileManager.default.removeItem(at: location)
    }
    
}
