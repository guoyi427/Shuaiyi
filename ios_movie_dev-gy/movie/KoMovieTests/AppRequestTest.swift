//
//  AppRequestTest.swift
//  KoMovie
//
//  Created by Albert on 21/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import XCTest

class AppRequestTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        K_REQUEST_ENC_SALT = NSMutableString.init(string: kKsspKey)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testAppSplasheRequest() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: AppRequest = AppRequest()
        
        request.requestSplashSuccess({ (splashe) in
            completed.fulfill()
        }) { (err) in
            print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    
    func testAppVersionRequest() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: AppRequest = AppRequest()
        
        request.requestAppVersionSuccess({ (version) in
            completed.fulfill()
        }) { (err) in
            print("err\(err)")
        }
        
        waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    
    func testAppUploadLog() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: AppRequest = AppRequest()
        
        request.uploadLog("", success: {
            
            completed.fulfill()
            }) { (err) in
              print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testAppRequestMenus() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: AppRequest = AppRequest()
        
        request.requestMenus(0, success: { (menus) in
            
            completed.fulfill()
            }) { (err) in
              print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testAppBanners() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: AppRequest = AppRequest()
        
        request.requestBanners( 36, targetID:232, targetType: 16,success: { (banners) in
            
            completed.fulfill()
            }) { (err) in
               print("err\(err)")
        }
        
        self.waitForExpectations(timeout: 10) { (err) in
            
        }
    }
    
    func testCityListRequest() {
        let completed:XCTestExpectation = self.expectation(description: "completed")
        let request: CityRequest = CityRequest()
        
        request.requestCityListSuccess({ (cityList, indexes) in
            
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
