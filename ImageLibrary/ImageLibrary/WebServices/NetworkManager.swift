//
//  NetworkManager.swift
//  ImageLibrary
//
//  Created by user178197 on 8/14/20.
//  Copyright © 2020 user178197. All rights reserved.
//

import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("nil")
                completion(nil)
                return
            }
           
            completion(self?.decode(data))
        })
        task.resume()
    }
}


class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}
 
extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) -> [Resource.ModelType]? {
        
             let wrapper = try? JSONDecoder().decode([Resource.ModelType].self, from: data)
        
        return wrapper
    }
    
    func load(withCompletion completion: @escaping ([Resource.ModelType]?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}
