//
//  AccountTests.swift
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class AccountTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEditUserProfile() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let updateProfile = AccountRequest()
        
        updateProfile.startPostSigature("", sucuess: {
            
            completed.fulfill()
        }) { (err) in
            print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    
    func testUserRequest() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let accReq = AccountRequest()
        
        accReq.requestUser(83419, success: { (user) in
            completed.fulfill()
            }) { (err) in
              print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    func testUserDetailRequest() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let accReq = AccountRequest()
        
        accReq.requestUserDetail(83419, success: { (socoal) in
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
