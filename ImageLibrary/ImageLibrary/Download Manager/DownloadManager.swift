

import Foundation
import UIKit

typealias DownloadHandler<DocType:AnyObject> = (_ doc: DocType?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

final class DownloadManager {
    private var completionHandler: DownloadHandler<AnyObject>?
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.flickrTest.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    let docCache = NSCache<NSString, AnyObject>()
    
    static let shared = DownloadManager()
    private init () {
        docCache.countLimit = 50
    }
    
    func downloadDocument<T:DownloadItemUrl>(_ downloadItem: T, indexPath: IndexPath?,  handler: @escaping DownloadHandler<AnyObject>) {
        self.completionHandler = handler
        guard let url = downloadItem.downloadUrl else {
            return
        }
        if let cachedData = docCache.object(forKey: url.absoluteString as NSString) {
            
           self.completionHandler?(cachedData, url, indexPath, nil)
        } else {
             
            if let operations = (downloadQueue.operations as? [DownloadOperation])?.filter({$0.docUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                print("Increase the priority for \(url)")
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                print("Create a new task for \(url)")
                let operation = DownloadOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                operation.downloadHandler = { (data, url, indexPath, error) in
                    if let data = data {
                        self.docCache.setObject(data, forKey: url.absoluteString as NSString)
                        self.completionHandler?(data, url, indexPath, error)
                    }
                    else {
                        
                    }
                    
                    
                }
                downloadQueue.addOperation(operation)
            }
        }
    }
    
    
    func reducePriority <T: DownloadItemUrl>(_ downloadItem: T) {
        guard let url = downloadItem.downloadUrl else {
            return
        }
        
        if let operations = (downloadQueue.operations as? [DownloadOperation])?.filter({$0.docUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            print("Reduce the priority for \(url)")
            operation.queuePriority = .low
        }
    }
    
    func cancelAll() {
        downloadQueue.cancelAllOperations()
    }
    
}




