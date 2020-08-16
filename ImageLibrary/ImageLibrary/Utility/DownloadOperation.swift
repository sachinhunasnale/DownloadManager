


import Foundation
import UIKit

class DownloadOperation: Operation {
    var downloadHandler: DownloadHandler<AnyObject>?
    var docUrl: URL!
    private var indexPath: IndexPath?
   
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    required init (url: URL, indexPath: IndexPath?) {
        self.docUrl = url
        self.indexPath = indexPath
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        self.downloadDocFromUrl()
    }
    
    func downloadDocFromUrl() {
       let newSession = URLSession.shared
        
        let downloadTask = newSession.downloadTask(with: self.docUrl) { (location, response, error) in
        
        if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
            self.downloadHandler?(data as AnyObject,self.docUrl, self.indexPath,error)
        }
        
          self.finish(true)
          self.executing(false)
        }
        downloadTask.resume()
    }
    
    
}


