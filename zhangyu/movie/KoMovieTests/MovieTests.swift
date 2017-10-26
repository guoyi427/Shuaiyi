//
//  MovieTests.swift
//  KoMovie
//
//  Created by Albert on 10/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class MovieTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovieList()  {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = MovieRequest()
        
        request.requestMovieList(in: 2210, success: { (list) in
            
             completed.fulfill()
            
            }) { (err) in
                
                print("err\(err)")
                
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
