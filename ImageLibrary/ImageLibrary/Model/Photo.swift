
import Foundation

protocol DownloadItemUrl {
    var downloadUrl:URL? { get }
}

class Photo: DownloadItemUrl {
    let url:String
    let height:Int
    let width:Int
    
    init(url:String, height:Int, width:Int) {
        self.url = url
        self.height = height
        self.width = width
    }
    
    var downloadUrl:URL? {
        return URL(string: url)
    }
}
