//
//  ResourceTypes.swift
//  ImageLibrary
//
//  Created by user178197 on 8/14/20.
//  Copyright © 2020 user178197. All rights reserved.
//

import Foundation

protocol ApiResource {
    associatedtype ModelType: Decodable
    var methodPath: String { get }
}
 
extension ApiResource {
    var url: URL {
        var components = URLComponents(string: Constants.Endpoints.BaseUrl)!
        components.path = methodPath
        return components.url!
    }
}

struct UserInfoResource: ApiResource {
    typealias ModelType = Users
    let methodPath = Constants.Endpoints.getPath
}
