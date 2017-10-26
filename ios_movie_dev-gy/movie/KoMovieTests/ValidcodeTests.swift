//
//  ValidcodeTests.swift
//  KoMovie
//
//  Created by Albert on 10/11/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class ValidcodeTests: XCTestCase {
    
    lazy var request:ValidcodeRequest = ValidcodeRequest()
    
    override func setUp() {
        super.setUp()
        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResetPasswordValidcode() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        request.requestResetPasswordValidcode("13811035941", success: {
            completed.fulfill() 
        }, failure: { (err) in
             print("err\(err)")
        })
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }

    }
    
    
    func testAuthCodeReset() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        request.requestAuthResetSuccess({ (str) in
            completed.fulfill()
        }, failure: { (err) in
        print("err\(err)")
        })

        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testAuthCodeCheck() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        request.requestAuthCode("8a2883f851c8398801584d952a630368", validCode: "7640", action: "", success: {
            
            completed.fulfill()
        }, failure: {(err) in
             print("err\(err)")
        })
        
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
