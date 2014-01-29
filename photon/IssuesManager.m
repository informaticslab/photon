//
//  IssuesManager.m
//  photon
//
//  Created by jtq6 on 11/5/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "IssuesManager.h"
#import "Issue.h"
#import "Article.h"


@implementation IssuesManager

-(id)init
{
    if (self = [super init]) {
        
        self.issues = [[NSMutableDictionary alloc]init];
        self.keywords = [[NSMutableDictionary alloc]init];
        
    };

    return self;
    
}

-(id)initWithFeedParser
{
    
    if (self = [super init]) {
        
        self.parsedIssues = [[NSMutableDictionary alloc]init];
        self.keywords = [[NSMutableDictionary alloc]init];
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

-(BOOL)isIssueNew:(Issue *)newIssue
{
    // check if issue exists
    Issue *currIssue = [_issues objectForKey:newIssue.title];
    
    if (currIssue == nil)
        return YES;
    
    return NO;
    
}

-(BOOL)isArticleNew:(Article *)article inIssue:(Issue *)issue
{
    if ([issue numberOfArticles] == 0)
        return YES;
    
    // check if article with this title already exists in current issue
    Article *existingArticle = [issue getArticleWithTitle:article.title];
    
    // if no article with title
    if (existingArticle == nil)
        return YES;
    
    return NO;
    
}

-(BOOL)isArticleNewer:(Article *)article inIssue:(Issue *)issue
{
    // check if article with this title already exists in current issue
    Article *existingArticle = [issue getArticleWithTitle:article.title];
    
    // if no article with title
    if (existingArticle == nil)
        return YES;
    
    return NO;
    
}

-(Issue *)storeNewIssue:(Issue *)newIssue
{
    
    [_issues setObject:newIssue forKey:newIssue.title];
    
    _sortedIssues = [[_issues allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    return newIssue;
    
    
}

-(Issue *)newIssueWithTitle:(NSString *)title
{

    Issue *issue = [[Issue alloc]initWithTitle:title];
    [_issues setObject:issue forKey:title];
    
    return issue;
    
}

-(Issue *)getStoredIssueForIssue:(Issue *)issue
{
    Issue *storedIssue = [_issues objectForKey:issue.title];
     
    return storedIssue;
    
    
}

-(Article *)storeNewArticle:(Article *)newArticle inIssue:(Issue *)issue
{

    return [issue storeArticle:newArticle];
    
}

-(void)addArticleTags:(NSArray *)tags forArticle:(Article *)article
{
    NSMutableArray *articlesWithTag;
    
    for (NSString *tag in tags) {
        if ((articlesWithTag = [_keywords objectForKey:tag]) == nil) {
            articlesWithTag = [[NSMutableArray alloc] initWithObjects:article, nil];
            [_keywords setObject:articlesWithTag forKey:tag];

        } else {
            [articlesWithTag addObject:article];
        }
    }
}


-(void)newArticle:(Article *)article inIssue:(Issue *)issue withTags:(NSArray *)tags version:(NSInteger)ver
{
    Issue *storedIssue = nil;
    Article *storedArticle = nil;
    
    if ([self isIssueNew:issue]) {
        storedIssue = [self storeNewIssue:issue];
    } else {
        storedIssue = [self getStoredIssueForIssue:issue];
        
    }
    // check  article with this title already exists in current issue
    if ([self isArticleNew:article inIssue:storedIssue])
    {
        
        storedArticle = [self storeNewArticle:article inIssue:storedIssue];
        
    } else {
        
        storedArticle = [storedIssue getArticleWithTitle:article.title];
        
        // check if version number is greater than current version
        if (article.version > storedArticle.version) {
            
            // create new article object and replace the old with new
            [issue replaceArticle:storedArticle withArticle:article];
            
        }
    }
    
    [self addArticleTags:tags forArticle:storedArticle];

}


-(Article *)newArticleWithTitle:(NSString *)title inIssue:(Issue *)currIssue revision:(NSInteger)ver
{

    // check if article with this title already exists in current issue
    Article *article = [currIssue getArticleWithTitle:title];
    
    // if no article with title, add article to current issue
    if (article == nil) {
        
        article = [currIssue addArticleWithTitle:title];
        article.issue = currIssue;
        
    }
    
    //
    else {
        
        // check if version number is greater than current version
        if (ver > article.version) {
            
            // create new article object and replace the old with new
            Article *newArticle = [[Article alloc]initWithTitle:title];
            [currIssue replaceArticle:article withArticle:newArticle];
            
        }
    }
    
    return article;
}

-(NSArray *)articlesWithKeyword:(NSString *)keyword
{
    NSArray *articles = [_keywords objectForKey:keyword];
    return articles;
}


-(void)updateFromFeed
{
    [APP_MGR.jsonParser updateFromFeed];
}

-(Issue *)getSortedIssueForIndex:(NSUInteger)index
{
    if ([self.issues count] == 0)
        return nil;
    
    if ([self.sortedIssues count] == 0)
        return nil;
    
    NSString *issueKey = _sortedIssues[index];
    
    return [self.issues objectForKey:issueKey];
    
}


//-(void)loadTestData
//{
//    
//    NSError *err = nil;
//    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Issues" ofType:@"json"];
//    NSArray *testArticles = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
//                                                          options:kNilOptions
//                                                            error:&err];
//    Issue *currIssue = nil;
//    Article *currArticle = nil;
//    NSMutableArray *articlesWithKeyword = nil;
//    NSInteger vers = 0;
//    
//    NSLog(@"Imported Test Issues: %@", testArticles);
//    
//    for (NSDictionary *articleJsonBlob in testArticles)
//    {
//        // get schema version
//        [self parseSchemaVersionFromJson:articleJsonBlob];
//        
//        // get issue from blob
//        Issue *blobIssue = [self parseIssueFromJson:articleJsonBlob];
//        
//        // add new article to current issues
//        currArticle = [self parseArticleFromJson:articleJsonBlob];
//            
//            if (currArticle != nil)
//            {
//                
//            }
//                
//            
//            // get collection of articles for currrent issue
//            NSArray *newKeywords = [articleJsonBlob valueForKey:@"tags"];
//            
//            NSLog(@"tags: %@", newKeywords);
//            for (NSDictionary *keyword in newKeywords) {
//                NSString *currKeyword = [keyword valueForKey:@"tag"];
//                if ((articlesWithKeyword = [_keywords objectForKey:currKeyword]) == nil) {
//                    articlesWithKeyword = [[NSMutableArray alloc] initWithObjects:currArticle, nil];
//                    [_keywords setObject:articlesWithKeyword forKey:currKeyword];
//                    
//                } else {
//                    [articlesWithKeyword addObject:currArticle];
//                }
//                [currArticle.tags addObject:currKeyword];
//            };
//
//    }
//    
//    _issues = [self.parsedIssues allValues];
//    [_parsedIssues removeAllObjects];
//    [_parsedItems removeAllObjects];
//    [_parsedJsonBlobs removeAllObjects];
//    [self dump_parse_stats];
//
//}
//
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
    if (_parsedItems.count == 0) {
        //self.title = @"Failed"; // Show failed message in title
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
}



-(void)parseFeedData
{
    NSError *err = nil;

    Issue *currIssue = nil;
    Article *currArticle = nil;
    NSMutableArray *articlesWithKeyword = nil;
    NSString *verStr = nil;
    NSInteger vers = 0;
    
    int issuesFound = 0;
    int articlesFound = 0;
    int tagsFound = 0;
    int knownFound = 0;
    int addedFound = 0;
    int implicationsFound = 0;
    


    for (NSString *blob in _parsedJsonBlobs)
    {
        id jsonData = [blob dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *issue = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&err];
        
        // create and add issue
        currIssue = [self newIssueWithTitle:[issue valueForKey:@"title"]];
        NSLog(@"Issue title: %@", [issue valueForKey:@"title"]);
        issuesFound++;
        
        if (issuesFound == 1)
            [self.keywords removeAllObjects];
        
        NSLog(@"Version: %@", [issue valueForKey:@"ver"]);
        verStr = [issue valueForKey:@"ver"];
        
        if (verStr == nil)
            vers = 0;
        else
            vers = [verStr integerValue];
            
        
        // get collection of articles for currrent issue
        NSArray *newArticles = [issue valueForKey:@"articles"];
        
        //NSLog(@"Articles: %@", newArticles);
     
        for (NSDictionary *article in newArticles) {
            
            // add new article to current issues
            NSLog(@"\tArticle title: %@", [article valueForKey:@"title"]);
            currArticle = [self newArticleWithTitle:[article valueForKey:@"title"]  inIssue:currIssue revision:vers];
            articlesFound++;
            
            NSLog(@"\tArticle URL: %@", [article valueForKey:@"url"]);
            currArticle.url = [article valueForKey:@"url"];
            
            currArticle.already_know = [article valueForKey:@"already_known"];
            NSLog(@"\tAlready_known: %@", [article valueForKey:@"already_known"]);
            knownFound++;
            
            currArticle.added_by_report = [article valueForKey:@"added_by_report"];
            NSLog(@"\tAdded_by_report: %@", [article valueForKey:@"added_by_report"]);
            addedFound++;
            
            currArticle.implications = [article valueForKey:@"implications"];
            NSLog(@"\tImplications: %@", [article valueForKey:@"implications"]);
            implicationsFound++;
            
            // get collection of articles for currrent issue
            NSArray *newKeywords = [article valueForKey:@"tags"];
            
            NSLog(@"\tTags:");
            for (NSDictionary *keyword in newKeywords) {
                NSString *currKeyword = [keyword valueForKey:@"tag"];
                NSLog(@"\t\ttag:%@", currKeyword);
                if ((articlesWithKeyword = [_keywords objectForKey:currKeyword]) == nil) {
                    articlesWithKeyword = [[NSMutableArray alloc] initWithObjects:currArticle, nil];
                    [_keywords setObject:articlesWithKeyword forKey:currKeyword];
                    
                } else {
                    [articlesWithKeyword addObject:currArticle];
                }
                [currArticle.tags addObject:currKeyword];
                tagsFound++;

            };
        }
    }
    
    _issues = [_parsedIssues allValues];
    [_parsedIssues removeAllObjects];
    [_parsedItems removeAllObjects];
    [_parsedJsonBlobs removeAllObjects];
//    [self dump_parse_stats];
    
}



@end
