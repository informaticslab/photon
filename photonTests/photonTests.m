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

BOOL hasDataBeenCleared = NO;

#define expectZeroIssues() XCTAssert([self.issuesMgr.sortedIssues count] == 0, @"The number of sorted issues is not equal to 0.");
#define expectOneIssue() XCTAssert([self.issuesMgr.sortedIssues count] == 1, @"The number of sorted issues is not equal to 1.");
#define expectTwoIssues() XCTAssert([self.issuesMgr.sortedIssues count] == 2, @"The number of sorted issues is not equal to 2.");

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
    [self parseAndPersistTestFile:@"addArticle" ofType:@"json"];
    NSString *expectedResult = @"Test Article - Adding Articles JSON";

    expectOneIssue();
    IssueMO *issue = self.issuesMgr.sortedIssues[0];
    XCTAssert(issue !=nil, @"The first issue does not exist in the sorted issues set.");


    NSArray *articles = [issue.articles allObjects];
    XCTAssertNotNil(articles);
    XCTAssert([articles count] ==1, @"The number of articles in the issue does not equal 1.");
    ArticleMO *savedArticle = [articles objectAtIndex:0];
    XCTAssertTrue([savedArticle.title isEqualToString:expectedResult], @"Expect article title:%@ --- Retrieved title:%@", expectedResult, savedArticle.title);
}

- (void)testDeleteArticle
{
    [self parseAndPersistTestFile:@"deleteCommand" ofType:@"json"];
    
    expectZeroIssues();
}



//  loads two versions of same article and tests that last version is only one saved
- (void)testVersionedArticleSameKeywords
{
    
    [self parseAndPersistTestFile:@"versionedArticleSameKeywords" ofType:@"json"];
    NSString *expectedTitle = @"Versioned Article - Same Keywords";
    NSString *expectedKnown = @"V2 already known";
    NSString *expectedAdded = @"V2 added by report";
    NSString *expectedImplications = @"V2 implications";
    
    expectOneIssue();
    IssueMO *issue = self.issuesMgr.sortedIssues[0];
    XCTAssert(issue !=nil, @"The first issue does not exist in the sorted issues set.");
    
    
    NSArray *articles = [issue.articles allObjects];
    XCTAssertEqual([articles count], 1, @"The number of articles in the issue does not equal 1.");
    XCTAssertNotNil(articles);
    ArticleMO *article = [articles objectAtIndex:0];
    
    // check title
    XCTAssertTrue([article.title isEqualToString:expectedTitle], @"Expect article title:%@ --- Retrieved title:%@", expectedTitle, article.title);
    XCTAssertTrue([article.already_known isEqualToString:expectedKnown], @"Expect already_known field:%@ --- Retrieved already_known:%@", expectedKnown, article.already_known);
    XCTAssertTrue([article.added_by_report isEqualToString:expectedAdded], @"Expect added_by_report field:%@ --- Retrieved added_by_report:%@", expectedAdded, article.added_by_report);
    XCTAssertTrue([article.implications isEqualToString:expectedImplications], @"Expect article implications field:%@ --- Retrieved implications:%@", expectedImplications, article.implications);
    
    
}

//  loads two versions of same article and tests that last version is only one saved
- (void)testVersionedArticleDifferentKeywords
{
    
    [self parseAndPersistTestFile:@"versionedArticleDifferentKeywords" ofType:@"json"];
    NSString *expectedTitle = @"Versioned Article - Different Keywords";
    NSString *expectedKnown = @"V2 already known";
    NSString *expectedAdded = @"V2 added by report";
    NSString *expectedImplications = @"V2 implications";
    
    expectOneIssue();
    IssueMO *issue = self.issuesMgr.sortedIssues[0];
    XCTAssert(issue !=nil, @"The first issue does not exist in the sorted issues set.");
    
    
    NSArray *articles = [issue.articles allObjects];
    XCTAssertEqual([articles count], 1, @"The number of articles in the issue does not equal 1.");
    XCTAssertNotNil(articles);
    ArticleMO *article = [articles objectAtIndex:0];
    
    // check title
    XCTAssertTrue([article.title isEqualToString:expectedTitle], @"Expect article title:%@ --- Retrieved title:%@", expectedTitle, article.title);
    XCTAssertTrue([article.already_known isEqualToString:expectedKnown], @"Expect already_known field:%@ --- Retrieved already_known:%@", expectedKnown, article.already_known);
    XCTAssertTrue([article.added_by_report isEqualToString:expectedAdded], @"Expect added_by_report field:%@ --- Retrieved added_by_report:%@", expectedAdded, article.added_by_report);
    XCTAssertTrue([article.implications isEqualToString:expectedImplications], @"Expect article implications field:%@ --- Retrieved implications:%@", expectedImplications, article.implications);
    
    for (KeywordMO *keyword in self.issuesMgr.keywords) {
        XCTAssertFalse([keyword.text isEqualToString:@"Pregnancy"], @"The keyword Prenancy should not exist in any article.");

    }
    
}


//  parses an unknown attribute in JSON blob
- (void)testUnknownAttribute
{
    
    [self parseAndPersistTestFile:@"unknownAttribute" ofType:@"json"];
    NSString *expectedResult = @"Test Article - Unknown Attribute";
    
    expectOneIssue();
    IssueMO *issue = self.issuesMgr.sortedIssues[0];
    XCTAssert(issue !=nil, @"The first issue does not exist in the sorted issues set.");
    
    
    NSArray *articles = [issue.articles allObjects];
    XCTAssertNotNil(articles);
    XCTAssert([articles count] ==1, @"The number of articles in the issue does not equal 1.");
    ArticleMO *savedArticle = [articles objectAtIndex:0];
    XCTAssertTrue([savedArticle.title isEqualToString:expectedResult], @"Expect article title:%@ --- Retrieved title:%@", expectedResult, savedArticle.title);
    
}




- (void)testParseBundleArticlesPerformance {
    [self measureBlock:^{
        [self.jsonParser loadAndPersistPreloadData];

    }];
}


@end
