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
#import "IssueMO+Issue.h"

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
        self.parsedItems  = [[NSMutableArray alloc] init];
        self.parsedJsonBlobs  = [[NSMutableArray alloc] init];

        V1JsonParser *v1 = [[V1JsonParser alloc] init];
        _schemaParsers = @[v1];
        
        NSURL *feedURL = [NSURL URLWithString:@"http://t.cdc.gov/feed.aspx?feedid=100"];
        _feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        _feedParser.delegate = self;
        _feedParser.feedParseType = ParseTypeFull; // parse feed info and all items
        _feedParser.connectionType = ConnectionTypeAsynchronously;
        
        
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


-(void)parseAndPersistJsonBlobs:(NSArray *)jsonBlobs
{
    Issue *currIssue = nil;
    Article *currArticle = nil;
    NSArray *tags = nil;
    NSInteger schemaVer = 0;
    NSInteger contentVer = 0;
    
    NSLog(@"Imported Test Issues: %@", jsonBlobs);
    
    for (NSDictionary *articleJsonBlob in jsonBlobs)
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
    
    
    //
    [APP_MGR.issuesMgr reloadData];
    
}



-(void)parseAndPersistTestData
{
    
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Issues" ofType:@"json"];
    NSArray *testJsonBlobs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                             options:kNilOptions
                                                               error:&err];
    
    [self parseAndPersistJsonBlobs:testJsonBlobs];
    
    
}

-(void)loadAndPersistPreloadData
{
    
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"PreloadIssues" ofType:@"json"];
    NSArray *preloadJsonBlobs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                             options:kNilOptions
                                                               error:&err];
    
    [self parseAndPersistJsonBlobs:preloadJsonBlobs];
    
    
}

-(void)parseFeedData
{
    NSError *err = nil;
    
    Issue *currIssue = nil;
    Article *currArticle = nil;
    NSArray *tags = nil;
    NSInteger schemaVer = 0;
    NSInteger contentVer = 0;
    

    
    for (NSString *blob in _parsedJsonBlobs)
    {
        id jsonData = [blob dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *articleJsonBlob = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
        
        
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
    [APP_MGR.issuesMgr reloadData];

    [_parsedIssues removeAllObjects];
    [_parsedItems removeAllObjects];
    [_parsedJsonBlobs removeAllObjects];
    
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

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	//self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item)
    {
        [_parsedItems addObject:item];
        [_parsedJsonBlobs addObject:item.summary];
    }
    
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self parseFeedData];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FeedDataUpdated"
     object:self];
    
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (error.code == 2) {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Update Articles"
                                                        message:@"The Internet connection appears to be offline. Please check the connection, and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                        message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    //[self updateTableWithParsedItems];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FeedDataUpdated"
     object:self];
    

}









@end
