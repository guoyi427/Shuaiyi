//
//  OrderTests.swift
//  KoMovie
//
//  Created by Albert on 10/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class OrderTests: XCTestCase {
    
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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testOrderList() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = OrderRequest()
        
        request.requestOrderList(at: 1, success: { (list) in
            
            completed.fulfill()
            
            }) { (err) in
                
                print("err\(err)")
        }
        
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }

    }
    
    
    func testOrderDetail() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = OrderRequest()
        
        request.requestOrderDetail("a1468227610651619636", success: { (order) in
            
            completed.fulfill()
            
            }) { (err) in
                
                 print("err\(err)")
                
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    
    func testOrderMobile() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = OrderRequest()
        
        request.requestOrderMobile({ (mobile) in
            
            completed.fulfill()
            
        }) { (err) in
            
            print("err\(err)")
        }
        
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    
    /// 生成订单
    func testAddOrder() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = OrderRequest()
        
        request.addTicketOrder("", seatNO: "20002973_1773", seatInfo: "(null)_5_12", planID: 119662656, activityID: nil, success: { (order) in
            
            completed.fulfill()
            
            print("\(order?.orderId)")
            
            }) { (err, order) in
                
              print("err\(err), \n\(order)")
        }

        
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    /// 删除订单
    func testOrderDelete() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = OrderRequest()
        
        request.deleteOrder("a1476769510477521382", success: {
            
            completed.fulfill()
            
            }) { (err) in
                
                print("err\(err)")
        }

        
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
        
    }
    
    
    func testOrderComment() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        
        let request = OrderRequest()
        
        request.requestOrderComment(1, success: { (orders, hasMore) in
            
            print("order:\(orders)")
            
            completed.fulfill()
        }, failure: { err in
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
