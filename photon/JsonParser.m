//
//  JsonParser.m
//  photon
//
//  Created by jtq6 on 1/26/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "JsonParser.h"
#import "Article.h"
#import "Issue.h"
#import "V1JsonParser.h"

#import "NSString+HTML.h"
#import "MWFeedParser.h"

@implementation JsonParser

int issuesFound = 0;
int articlesFound = 0;
int tagsFound = 0;
int knownFound = 0;
int addedFound = 0;
int implicationsFound = 0;



-(id)init
{
    if (self = [super init]) {
        
        self.parsedIssues = [[NSMutableDictionary alloc]init];
        self.parsedKeywords = [[NSMutableDictionary alloc]init];
        V1JsonParser *v1 = [[V1JsonParser alloc] init];
        _schemaParsers = @[v1];
        
    };
    
    return self;
    
}

-(id)initWithFeedParser
{
    
    if (self = [super init]) {
        
        self.parsedIssues = [[NSMutableDictionary alloc]init];
        self.parsedKeywords = [[NSMutableDictionary alloc]init];
        self.parsedItems  = [[NSMutableArray alloc] init];
        self.parsedJsonBlobs  = [[NSMutableArray alloc] init];
        
        NSURL *feedURL = [NSURL URLWithString:@"http://t.cdc.gov/feed.aspx?feedid=100"];
        
        _feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        _feedParser.delegate = self;
        _feedParser.feedParseType = ParseTypeFull; // parse feed info and all items
        _feedParser.connectionType = ConnectionTypeAsynchronously;
        [_feedParser parse];
        
    };
    
    return self;
    
}


-(void)updateFromFeed
{
    [_feedParser parse];
}


-(id)getParserForSchemaVersion:(NSInteger)schemaVersion
{
    if ( (schemaVersion > 0) && (schemaVersion < [self.schemaParsers count]) ) {
        NSLog(@"");
    }
    return self.schemaParsers[schemaVersion-1];
}


-(void)parseTestData
{
    
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Issues" ofType:@"json"];
    NSArray *testJsonBlobs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                            options:kNilOptions
                                                              error:&err];
    Issue *currIssue = nil;
    Article *currArticle = nil;
    NSArray *tags = nil;
    NSInteger schemaVer = 0;
    NSInteger contentVer = 0;
    
    NSLog(@"Imported Test Issues: %@", testJsonBlobs);
    
    for (NSDictionary *articleJsonBlob in testJsonBlobs)
    {
        // get schema version
        schemaVer = [JsonParserBase parseSchemaVersionFromJson:articleJsonBlob];
        
        id <JsonParserProtocol> versionParser = [self getParserForSchemaVersion:schemaVer];
        
        // get issue from blob
        currIssue = [versionParser parseIssueJson:articleJsonBlob];
        
        // add article info
        currArticle = [versionParser parseArticleJson:articleJsonBlob];
        
        // get content version
        contentVer = [versionParser parseContentVersionJson:articleJsonBlob];
        
        // get collection of tags for currrent article
        tags = [versionParser parseTagsJson:articleJsonBlob];
        
        [APP_MGR.issuesMgr newArticle:currArticle inIssue:currIssue withTags:tags version:contentVer];
        
        
        
    }
    
}

-(void) dump_parse_stats
{
    
    NSLog(@"Issues found = %d", issuesFound);
    NSLog(@"Articles found = %d", articlesFound);
    NSLog(@"Tags found = %d", tagsFound);
    NSLog(@"Known found = %d", knownFound);
    NSLog(@"Added found = %d", addedFound);
    NSLog(@"Implication found = %d", implicationsFound);
    
    issuesFound = 0;
    articlesFound = 0;
    tagsFound = 0;
    knownFound = 0;
    addedFound = 0;
    implicationsFound = 0;
    
    
}






@end
