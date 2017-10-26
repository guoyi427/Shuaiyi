//
//  RequestTests.swift
//  KoMovie
//
//  Created by Albert on 9/19/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class RequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        
        let cinema:CinemaRequest = CinemaRequest();
        cinema.requestGallery(2312, success: { (list) in
            
            completed.fulfill()
            }) { (err) in
                
              completed.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testActivityRequest() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: ActivityRequest = ActivityRequest()
        
        request.requestDetail(1777, success: { (obj) in
            
            completed.fulfill()
            
            }) { (err) in
                print("err\(err)")
        }
      
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testArtor() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request = MovieRelatedRequest()
        
        request.requestActorListForMovie(withMovieId: 388087, success: { (list) in
            
            completed.fulfill()
            
            }) { (err) in
                
                print("err\(err)")
        }
    
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
