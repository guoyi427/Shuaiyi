//
//  UserRequestTests.swift
//  KoMovie
//
//  Created by Albert on 28/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class UserRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        
        request.login("15201256034", password: "123456", site: SiteType.init(1), success: { (userLogin) in
            completed.fulfill()
            }) { (err) in
              print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }

    }
    
    
    func testLogout() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        
        request.logout({ 
             completed.fulfill()
            }) { (err) in
              print("err\(err)")
        }
                
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    func testHomePageBG() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        
        request.requestUserHomePageBg(83419, success: { (url) in
            
            completed.fulfill()
            
            }) { (err) in
                print("err\(err)")
                
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    
    func testHXUsers() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        request.requestHXUsers("4025719", success: { (users) in
            
            completed.fulfill()
            
            }) { (err) in
               print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    func testUserDetail() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        
        request.requestUserDetail({ (user) in
            
             completed.fulfill()
            
            }) { (err) in
                
               print("err\(err)")
                
        }
        

        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    
    func testUserBind() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        
        request.requestUserBindList({ (bind) in
            
            completed.fulfill()
            
            }) { (err) in
                print("err\(err)")
        }
        
        
        self.waitForExpectations(timeout: 20) { (err) in
            
        }
        
    }
    
    func testRequestMessageCount() {
        
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = UserRequest()
        
        request.requestMessageCount(83419, success: { (invite, coupon, comment, article) in
            
            completed.fulfill()
            }) { (err) in
                
                print("err\(err)")
                
        }
        
        
        self.waitForExpectations(timeout: 20) { (err) in
            
        }
        
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
