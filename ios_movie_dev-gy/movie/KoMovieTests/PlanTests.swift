//
//  PlanTests.swift
//  KoMovie
//
//  Created by Albert on 13/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class PlanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPlanList() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = PlanRequest()
        request.requestPlanList(388087, inCineam: 336, success: { (list) in
            completed.fulfill()
            }) { (err) in
                print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    func testMutiplePlanList() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = PlanRequest()
        
        request.requestPlanList(1397643, inCineams: ["2312","336","335"], success:  { (list) in
            completed.fulfill()
        }) { (err) in
            print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testPlanDetail() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = PlanRequest()
        
        request.requestPlanDetail("100508284", success: { (plan) in
            
            completed.fulfill()
            
            }) { (err) in
                
                print("err\(err)")
        }
        
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    
    func testSeatList() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = PlanRequest()
        
        
        request.requestCinemaSeat(2210, planId: 119662654, hallId: "2621", success: { (seats) in
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
