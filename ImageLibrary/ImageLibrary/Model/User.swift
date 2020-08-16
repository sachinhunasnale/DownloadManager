//
//  User.swift
//  ImageLibrary
//
//  Created by user178197 on 8/14/20.
//  Copyright © 2020 user178197. All rights reserved.
//

import Foundation

struct Users:Decodable {
    let user:Profile
    let width:Int
    let height:Int
}

struct Profile:Decodable {
    let profile_image:ProfileImages
}

struct ProfileImages:Decodable {
    let small:String
    let medium:String
    let large:String
}
