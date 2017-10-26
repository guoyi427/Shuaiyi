//
//  UploadTests.m
//  KoMovie
//
//  Created by Albert on 26/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKZBaseRequestParams.h"
#import "Constants.h"
#import "ClubRequest.h"
@interface UploadTests : XCTestCase

@end

@implementation UploadTests

- (void)setUp {
    [super setUp];
    
    K_REQUEST_ENC_SALT = [NSMutableString stringWithString:kKsspKey];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testUploadImage
{
    UIImage *image = [UIImage imageNamed:@"sns_publish_audio"];
    NSArray *arr = @[image];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"complet"];
    
    ClubRequest *request = [ClubRequest new];
    [request uploadPictures:arr success:^(NSArray * _Nullable posts) {
        
        [expectation fulfill];
        
    } failure:^(NSError * _Nullable err) {
        NSLog(@"err");
        
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
