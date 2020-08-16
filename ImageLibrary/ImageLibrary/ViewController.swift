


import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    private var request: AnyObject?
    private let refreshControl = UIRefreshControl()
    
    var searches = PhotoSearchResults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshPhotos(_:)), for: .valueChanged)
        photoCollectionView.refreshControl = refreshControl
        
        fetch()
    }
    
    func fetch() {
        let apiRequest = ApiRequest(resource: UserInfoResource())
        request = apiRequest
        apiRequest.load { [weak self] (users:[Users]?) in
            guard let users = users else {
                print("no users")
                return
            }
            
            self?.searches.searchResults.removeAll()
            var uniqueUrls = [String]()
            for userItem in users {
                let user = userItem.user
                
                
                if !uniqueUrls.contains(user.profile_image.large)
                {
                    uniqueUrls.append(user.profile_image.large)
                    self?.searches.searchResults.append(Photo(url: user.profile_image.large))
                }
                
                
            }
            print("count = \(String(describing: self?.searches.searchResults.count))")
            self?.photoCollectionView.reloadData()
            self?.refreshControl.endRefreshing()
            
        }
    }
    
    
    
    @objc func refreshPhotos(_ sender:Any) {
        fetch()
    }
    
    func photoForIndexPath(indexPath: IndexPath) -> Photo {
        return searches.searchResults[(indexPath as NSIndexPath).row]
    }
}


extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoForIndexPath(indexPath: indexPath)
        (cell as! PhotoCollectionViewCell).imageView.image = #imageLiteral(resourceName: "default")
        DownloadManager.shared.downloadDocument(photo
        , indexPath: indexPath) { (data, url, indexPath, error) in
            if let newIndexPath = indexPath {
                DispatchQueue.main.async {
                    if let getCell = collectionView.cellForItem(at: newIndexPath) {
                        
                        (getCell as? PhotoCollectionViewCell)!.imageView.image = UIImage(data: data as! Data)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         let photo = photoForIndexPath(indexPath: indexPath)
        DownloadManager.shared.reducePriority(photo)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches.searchResults.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.PhotoCell.cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = #imageLiteral(resourceName: "default")
      return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = Constants.PhotoCollectionView.sectionInsets.left * (Constants.PhotoCollectionView.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth/Constants.PhotoCollectionView.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.PhotoCollectionView.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.PhotoCollectionView.sectionInsets.left
    }
}
