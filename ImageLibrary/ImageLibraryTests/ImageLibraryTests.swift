//
//  ImageLibraryTests.swift
//  ImageLibraryTests
//
//  Created by user178197 on 8/12/20.
//  Copyright © 2020 user178197. All rights reserved.
//

import XCTest
@testable import ImageLibrary

class ImageLibraryTests: XCTestCase {
    var sut:URLSession!
    
    override func setUpWithError() throws {
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    //test the url is valid or not
    func testValidCallToApi() {
        let url = URL(string: "\(Constants.Endpoints.BaseUrl)\(Constants.Endpoints.getPath)")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = sut.dataTask(with: url!) { data, response, error in
            
          if let error = error {
            XCTFail("Error: \(error.localizedDescription)")
            return
          } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode == 200 {
              promise.fulfill()
            } else {
              XCTFail("Status code: \(statusCode)")
            }
          }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }

    

}
