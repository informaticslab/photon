//
//  JsonParser.m
//  photon
//
//  Created by jtq6 on 1/26/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "JsonParser.h"
#import "ArticleMO+Article.h"
#import "IssueMO+Issue.h"
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

#define OLD_FEED @"https://t.cdc.gov/feed.aspx?feedid=100"
#define NEW_FEED @"https://prototype.cdc.gov/api/v2/resources/media/"

#define OLD_FEED_ID @"100"
#define RSS_FEED_ID @"338387" // Clay's version which is a clone of production feed as of ~ 10/6/2017
#define DEV_FEED_ID @"338384" // Peter's version which has far fewer article, use this one when adding tests so don't pollute the other dev feed.

// feed params
#define FROM_DATE @"fromdatemodified="

-(id)init
{
    if (self = [super init]) {
        
        self.parsedIssues = [[NSMutableDictionary alloc]init];
        self.parsedKeywords = [[NSMutableDictionary alloc]init];
        self.parsedItems  = [[NSMutableArray alloc] init];
        self.parsedJsonBlobs  = [[NSMutableArray alloc] init];
        
        // set date time formatter for last feed read parameter
        self.dateFormatter = [[NSDateFormatter alloc]init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [self.dateFormatter setLocale:enUSPOSIXLocale];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

        V1JsonParser *v1 = [[V1JsonParser alloc] init];
        _schemaParsers = @[v1];
        
        //        NSURL *feedURL = [NSURL URLWithString:@"http://t.cdc.gov/feed.aspx?feedid=100&&fromdate=2014-05-01"];
        NSURL *feedURL = [NSURL URLWithString:@"http://t.cdc.gov/feed.aspx?feedid=100"];
        // NSURL *feedURL = [NSURL URLWithString:@"http://t.cdc.gov/feed.aspx?feedid=105"];
        _feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        _feedParser.delegate = self;
        _feedParser.feedParseType = ParseTypeFull; // parse feed info and all items
        _feedParser.connectionType = ConnectionTypeAsynchronously;
        
    };
    
    return self;
    
}

-(void)setFeedUrl
{
    NSURL *feedURL = nil;
    
    NSDate *lastReadDate = [APP_MGR getLastFeedRead];
    if (lastReadDate != nil) {
        NSString *lastReadDateStr = [self.dateFormatter stringFromDate:lastReadDate];
        feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&%@&%@", NEW_FEED, RSS_FEED_ID, FROM_DATE, lastReadDateStr]];

        NSLog(@"Last feed read date = %@", lastReadDateStr);
        
    } else {
        feedURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", NEW_FEED, RSS_FEED_ID]];
        NSLog(@"No last feed read date");

    }
    NSLog(@"Feed URL = %@", feedURL);

    [_feedParser setUrl:feedURL];
    
}


-(void)updateFromFeed
{
    [self setFeedUrl];
    [_feedParser parse];
}


-(id)getParserForSchemaVersion:(NSInteger)schemaVersion
{
    if ( (schemaVersion > 0) && (schemaVersion < [self.schemaParsers count]) ) {
        DebugLog(@"");
    }
    return self.schemaParsers[schemaVersion-1];
}


-(void)parseAndPersistJsonBlobs:(NSArray *)jsonBlobs
{
    Issue *currIssue = nil;
    FeedArticle *currArticle = nil;
    NSArray *tags = nil;
    NSInteger schemaVer = 0;
    NSInteger contentVer = 0;
    
    for (NSDictionary *articleJsonBlob in jsonBlobs)
    {
        // get schema version
        schemaVer = [JsonParserBase parseSchemaVersionFromJson:articleJsonBlob];
        
        
        // only support schema version 1 now
        if ( schemaVer == 1 ) {
            
            id <JsonParserProtocol> versionParser = [self getParserForSchemaVersion:schemaVer];
            
            // get issue from blob
            currIssue = [versionParser parseIssueJson:articleJsonBlob];
            
            // add article info
            currArticle = [versionParser parseArticleJson:articleJsonBlob];
            
            // check for delete command and delete article
            if ([versionParser isDeleteCommandInJson:articleJsonBlob]) {
                
                // delete the article from the database
                [APP_MGR.issuesMgr deleteArticle:currArticle inIssue:currIssue];
                
            } else {
                
                
                // get content version and set article object version
                contentVer = [versionParser parseContentVersionJson:articleJsonBlob];
                currArticle.version = contentVer;
                
                // get collection of tags for currrent article
                tags = [versionParser parseTagsJson:articleJsonBlob];
                
                [APP_MGR.issuesMgr newArticle:currArticle inIssue:currIssue withTags:tags];
                
            }
            
        }
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
    FeedArticle *currArticle = nil;
    NSArray *tags = nil;
    NSInteger schemaVer = 0;
    NSInteger contentVer = 0;
    
    
    DebugLog(@"Starting to parse feed data............................");
    
    for (NSString *blob in _parsedJsonBlobs)
    {
        
        id jsonData = [blob dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *articleJsonBlob = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
        
        
        // get schema version
        schemaVer = [JsonParserBase parseSchemaVersionFromJson:articleJsonBlob];
        
        // only support schema version 1 now
        if ( schemaVer == 1 ) {
            
            id <JsonParserProtocol> versionParser = [self getParserForSchemaVersion:schemaVer];
            
            // get issue from blob
            currIssue = [versionParser parseIssueJson:articleJsonBlob];
            
            //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            //[formatter setDateFormat:@"YYYY-MM-dd"];
            //DebugLog(@"Found issue from feed with date %@, volume %ld, number = %ld", currIssue.title, (long)currIssue.volume, (long)currIssue.number);
            
            // add article info
            currArticle = [versionParser parseArticleJson:articleJsonBlob];
            
            // check for delete command and delete article
            if ([versionParser isDeleteCommandInJson:articleJsonBlob]) {
                
                // delete the article from the database
                [APP_MGR.issuesMgr deleteArticle:currArticle inIssue:currIssue];
                
            } else {
                
                // get content version and store it on article object
                contentVer = [versionParser parseContentVersionJson:articleJsonBlob];
                currArticle.version = contentVer;
                
                // get collection of tags for currrent article
                tags = [versionParser parseTagsJson:articleJsonBlob];
                
                [APP_MGR.issuesMgr newArticle:currArticle inIssue:currIssue withTags:tags];
                
            }
        }
    }
    
    DebugLog(@"Finished parsing feed data............................");
    
    [APP_MGR.issuesMgr reloadData];
    [APP_MGR setLastFeedRead];
    
    [_parsedIssues removeAllObjects];
    [_parsedItems removeAllObjects];
    [_parsedJsonBlobs removeAllObjects];
    
}


-(void) dump_parse_stats
{
    
    DebugLog(@"Issues found = %d", issuesFound);
    DebugLog(@"Articles found = %d", articlesFound);
    DebugLog(@"Tags found = %d", tagsFound);
    DebugLog(@"Known found = %d", knownFound);
    DebugLog(@"Added found = %d", addedFound);
    DebugLog(@"Implication found = %d", implicationsFound);
    
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
    DebugLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    DebugLog(@"Parsed Feed Info: “%@”", info.title);
    //self.title = info.title;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    DebugLog(@"Parsed Feed Item: “%@”", item.title);
    if (item)
    {
        [_parsedItems addObject:item];
        [_parsedJsonBlobs addObject:item.summary];
    }
    
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    DebugLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self parseFeedData];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FeedDataUpdated"
     object:self];
    
}


- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    DebugLog(@"Finished Parsing With Error: %@", error);
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
