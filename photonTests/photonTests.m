//
//  photonTests.m
//  photonTests
//
//  Created by jtq6 on 11/1/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JsonParser.h"
#import "IssuesManager.h"
#import "Debug.h"

@interface photonTests : XCTestCase

@property (strong, nonatomic) IssuesManager *issuesMgr;
@property (strong, nonatomic) JsonParser *jsonParser;

@end

@implementation photonTests

#define expectOneIssue() XCTAssert([self.issuesMgr.sortedIssues count] == 1, @"The number of sorted issues is not equal to 1.");

- (void)setUp
{
    [super setUp];
    self.issuesMgr = APP_MGR.issuesMgr;
    self.jsonParser = APP_MGR.jsonParser;
    [self.issuesMgr clearAllData];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)parseAndPersistTestFile:(NSString *)resourcePath ofType:(NSString*)resourceType
{
    NSString *testFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:resourceType];
    NSError *err = nil;
    NSArray *testJsonBlobs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:testFilePath]
                                                             options:kNilOptions
                                                               error:&err];
    
    XCTAssertNotNil(testFilePath);
    
    [self.jsonParser parseAndPersistJsonBlobs:testJsonBlobs];
    
}


- (void)testThatEnvironmentIsReady
{
    
    XCTAssertNotNil(self.issuesMgr, @"No IssuesManager");
    XCTAssertNotNil(self.jsonParser, @"No JsonParser");
    
}

- (void)testAddArticle
{
    [self parseAndPersistTestFile:@"addArticles" ofType:@"json"];
    NSString *expectedResult = @"Test Article - Adding Articles JSON";

    expectOneIssue();
    IssueMO *issue = self.issuesMgr.sortedIssues[0];
    XCTAssert(issue !=nil, @"The first issue does not exist in the sorted issues set.");


    NSArray *articles = [issue.articles allObjects];
    XCTAssertNotNil(articles);
    ArticleMO *savedArticle = [articles objectAtIndex:0];
    XCTAssertTrue([savedArticle.title isEqualToString:expectedResult], @"Strings are not equal %@ %@", expectedResult, savedArticle.title);
}

@end
