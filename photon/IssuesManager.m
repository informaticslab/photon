//
//  IssuesManager.m
//  photon
//
//  Created by jtq6 on 11/5/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "IssuesManager.h"
#import "IssueMO+Issue.h"
#import "ArticleMO+Article.h"
#import "KeywordMO.h"
#import "KeywordSearchResults.h"

@implementation IssuesManager

NSManagedObjectModel *model;
NSManagedObjectContext *context;

unsigned long db_issue_cnt;
unsigned long db_article_cnt;
unsigned long db_keyword_cnt;


-(id)init
{
    if (self = [super init]) {
        
        model = APP_MGR.managedObjectModel;
        context = APP_MGR.managedObjectContext;
        
        NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"GetAllIssues"] copy];
        
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                       ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedIssues = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ([fetchedIssues  count] == 0) {
            DebugLog(@"Issues Manager has no stored issues.");
            self.hasIssues = NO;
        } else
            self.hasIssues = YES;
    
        self.sortedIssues = fetchedIssues;
        self.issues = [[NSMutableDictionary alloc]init];
        
        [self getAllKeywords];
        [self removeDuplicateKeywords];
        [self updateDbStats];
        [self dumpDbStats];

    };

    return self;
    
}

-(void)dumpDbStats
{
    DebugLog(@"---DB Stats---: ");
    DebugLog(@"DB Issues: %lu", db_issue_cnt);
    DebugLog(@"DB Articles: %lu", db_article_cnt);
    DebugLog(@"DB Keywords: %lu", db_keyword_cnt);
}

-(NSString *)dbStatsString
{
    
    return [NSString stringWithFormat:@"DB stats: issues = %lu, articles = %lu, keywords = %lu", db_issue_cnt, db_article_cnt, db_keyword_cnt];
}

-(void)updateDbStats
{
    db_issue_cnt = self.sortedIssues.count;
    db_article_cnt = 0;
    for (IssueMO *issue in self.sortedIssues) {
        db_article_cnt += issue.articles.count;
    }
    db_keyword_cnt = self.keywords.count;
    
}


-(void)reloadKeywords
{

    NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"GetAllKeywords"] copy];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] == 0) {
        DebugLog(@"Issues Manager has no stored keywords.");
    }
    
    self.keywords = fetchedObjects;
    
}

-(void)reloadIssues
{
    NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"GetAllIssues"] copy];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:NO
                                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] == 0) {
        DebugLog(@"Issues Manager has no stored issues.");
    }
    
    self.sortedIssues = fetchedObjects;
    
}


-(void)reloadData
{
    
    [self reloadIssues];
    [self reloadKeywords];
    [self updateDbStats];
    [self dumpDbStats];
    
}


-(void)clearAllData
{
    [APP_MGR clearDatabase];
    
}


#pragma mark - Issue methods
-(IssueMO *)createNewIssue:(Issue *)newIssue
{
    
    IssueMO *issue = (IssueMO *)[NSEntityDescription
                                 insertNewObjectForEntityForName:@"IssueMO"
                                 inManagedObjectContext:context];
    
    
    issue.date = newIssue.date;
    issue.volume = [NSNumber numberWithInteger:newIssue.volume];
    issue.number = [NSNumber numberWithInteger:newIssue.number];
    
    [APP_MGR saveContext];
    
    return issue;
    
    
}

-(IssueMO *)getStoredIssueForIssue:(Issue *)newIssue
{
    
    NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            newIssue.date, @"DATE", [NSNumber numberWithInteger:newIssue.volume], @"VOLUME",
                                            [NSNumber numberWithInteger:newIssue.number], @"NUMBER", nil];
    
    NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"GetIssueWithDateVolumeNumber" substitutionVariables:substitutionDictionary];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] == 0 ) {
        DebugLog(@"Issues Manager has no issues with date = %@, volume = %ld, number = %ld", newIssue.date, (long)newIssue.volume, (long)newIssue.number);
        return nil;
    }
    else if([fetchedObjects count] == 1)
        return (IssueMO *)[fetchedObjects objectAtIndex:0];
    else
        return nil;

}

-(BOOL)isIssueNew:(Issue *)newIssue
{
    
    IssueMO *issue = [self getStoredIssueForIssue:newIssue];
    
    if (issue ==nil)
        return YES;
    else
        return NO;
    
}


-(IssueMO *)getSortedIssueForIndex:(NSUInteger)index
{
    if ([self.sortedIssues count] == 0)
        return nil;
    
    IssueMO *issue = (IssueMO *)_sortedIssues[index];
    
    return issue;
    
}


#pragma mark - Article methods
-(BOOL)isArticleNew:(FeedArticle *)article inIssue:(IssueMO *)issue
{
    
    if ([issue.articles count] == 0)
        return YES;
    
    // check if article with this title already exists in current issue
    ArticleMO *existingArticle = [issue getArticleWithTitle:article.title];
    
    // if no article with title
    if (existingArticle == nil)
        return YES;
    
    return NO;
    
}


-(ArticleMO *)createNewArticle:(FeedArticle *)newArticle inIssue:(IssueMO *)issue
{
    
    ArticleMO *article = (ArticleMO *)[NSEntityDescription
                                 insertNewObjectForEntityForName:@"ArticleMO"
                                 inManagedObjectContext:context];
    
    [article initWithTitle:newArticle.title version:newArticle.version];
    article.issue = issue;
    article.implications = newArticle.implications;
    article.added_by_report = newArticle.added_by_report;
    article.already_known = newArticle.already_know;
    article.url = newArticle.url;
    [APP_MGR saveContext];
    return article;
    

}

-(void)deleteArticle:(FeedArticle *)article inIssue:(Issue *)issue
{
    
    IssueMO *storedIssue = nil;
    ArticleMO *storedArticle = nil;
    
    // if issue does not exist just return, else get stored issue
    if ([self isIssueNew:issue]) {
        return;
    } else {
        storedIssue = [self getStoredIssueForIssue:issue];
    }

    // issue exists, see if article does, if not return
    if ([self isArticleNew:article inIssue:storedIssue] == YES)
        return;
    
        
    // check if article with this title already exists in current issue
    storedArticle = [storedIssue getArticleWithTitle:article.title];
        
    // if no article with this title then return
    if (storedArticle == nil)
        return;
    
    // remove article from keyword objects
    [self deleteArticleFromKeywords:storedArticle];
    
    // now delete article
    [storedIssue deleteArticle:storedArticle];
    
    if ([storedIssue.articles count] == 0)
        [APP_MGR.managedObjectContext deleteObject:storedIssue];
    
    [APP_MGR saveContext];
    

}


-(void)newArticle:(FeedArticle *)article inIssue:(Issue *)issue withTags:(NSArray *)tags
{

    IssueMO *storedIssue = nil;
    ArticleMO *storedArticle = nil;
    
    if ([self isIssueNew:issue]) {
        storedIssue = [self createNewIssue:issue];
    } else {
        storedIssue = [self getStoredIssueForIssue:issue];
        
    }
    // check  article with this title already exists in current issue
    if ([self isArticleNew:article inIssue:storedIssue])
    {
        
        storedArticle = [self createNewArticle:article inIssue:storedIssue];
        [self addArticleKeywords:tags forArticle:storedArticle];
        
    } else {
        
        storedArticle = [storedIssue getArticleWithTitle:article.title];
        NSInteger storedVersion = storedArticle.version.integerValue;
        
        
        // check if version number is greater than current version
        if (article.version > storedVersion ) {
            
            // create new article object and replace the old with new
            [self updateArticle:storedArticle withArticle:article];
            [self updatedKeywords:tags fromArticle:storedArticle];
            
        }
    }
    
    [APP_MGR saveContext];

}

-(void)updateArticle:(ArticleMO *)storedArticle withArticle:(FeedArticle *)updatedArticle
{
    storedArticle.implications = updatedArticle.implications;
    storedArticle.added_by_report = updatedArticle.added_by_report;
    storedArticle.already_known = updatedArticle.already_know;
    storedArticle.url = updatedArticle.url;
    storedArticle.version = [NSNumber numberWithInteger:updatedArticle.version ];
    storedArticle.unread = [NSNumber numberWithBool:YES];
    [APP_MGR saveContext];

}



#pragma mark - Keyword methods
-(void)getAllKeywords
{
    
    NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"GetAllKeywords"] copy];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedKeywords = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([fetchedKeywords count] == 0) {
        DebugLog(@"Issues Manager has no stored keywords.");
    }
    
    self.keywords = fetchedKeywords;
    
}

// case insensitive keyword search
-(KeywordMO *)getKeywordWithText:(NSString *)searchText
{
    NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            searchText, @"TEXT", nil];
    
    NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"GetKeywordsWithText" substitutionVariables:substitutionDictionary];    
    NSError *error = nil;
    NSArray *matchedKeywords = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([matchedKeywords count] == 0) {
        DebugLog(@"Issues Manager has no keywords matching text: %@", searchText);
        return nil;
    }
    else if([matchedKeywords count] == 1)
        return (KeywordMO *)[matchedKeywords objectAtIndex:0];
    else {
        DebugLog(@"Issues Manager has no keywords matching text: %@", searchText);
        return nil;
    }
    
    
}


// this method was written to remove the duplicate tags that occur due to a bug in the very first
// release in the Apple App Store, version 1.0.0.
-(void)removeDuplicateKeywords
{
    BOOL foundDups = NO;
    NSString *lastDuplicateKeyword = @"";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger duplicateKeywordsRemoved = [defaults integerForKey:@"RemoveKeywordDuplicatesV1"];
    
    // return if duplicates have been removed
    if (duplicateKeywordsRemoved == 1)
        return;
    
    
    // go through all the keywords that were loaded at init
    // and check for duplicates
    for (KeywordMO *currKeyword in self.keywords) {
        
        KeywordSearchResults *kwSearchResults = [[KeywordSearchResults alloc] initAndSearchForKeyword:currKeyword.text];
        
        // if keyword is duplicate and we have already merged them than delete KeywordMO
        if ([currKeyword.text isEqualToString:lastDuplicateKeyword]) {
            [context deleteObject:currKeyword];
        }
        
        
        // if keyword found more than once, remove duplicates and set flag
        else if (kwSearchResults.fetchCount > 1 ) {
            DebugLog(@"Issues Manager found duplicate keywords for keyword = %@.", currKeyword.text);
            
            [kwSearchResults mergeDuplicateKeywords];
            foundDups = YES;
            lastDuplicateKeyword = currKeyword.text;
        }
        
    }
    
    // if we found dups than refresh keyword collection
    if (foundDups)
        [self getAllKeywords];
    
    // set flag indicating remove duplicates has been run
    [defaults setInteger:1 forKey:@"RemoveKeywordDuplicatesV1"];
    [defaults synchronize];
    
    
}


-(KeywordMO *)createNewKeyword:(NSString *)text inArticle:(ArticleMO *)article
{
    
    KeywordMO *keyword = (KeywordMO *)[NSEntityDescription
                                       insertNewObjectForEntityForName:@"KeywordMO"
                                       inManagedObjectContext:context];
    
    keyword.text = text;
    [keyword addArticlesObject:article];
    [APP_MGR saveContext];
    [self reloadKeywords];
    return keyword;
}

-(void)removeArticle:(ArticleMO *)article fromKeyword:(NSString *)keyword
{
    KeywordMO *keywordMO = [self getKeywordWithText:keyword];
    
    if (keywordMO == nil) {
        DebugLog(@"No KeywordMO with text %@ exists.", keyword);
        return;
    }
    
    [keywordMO removeArticlesObject:article];
    
    if (keywordMO.articles.count == 0) {
        [context deleteObject:keywordMO];
    }
    
    [APP_MGR saveContext];

}


-(void)deleteArticleFromKeywords:(ArticleMO *)article
{

    // get existing stored keywords for article
    NSMutableSet *storedKeywords = [self keywordsForArticle:article];
    
    // remove article reference to stored keywords
    for (NSString *currKeyword in storedKeywords)
        [self removeArticle:article fromKeyword:currKeyword];

    
}


-(void)updatedKeywords:(NSArray *)latestKeywords fromArticle:(ArticleMO *)article
{

    KeywordMO *keywordMO = nil;
    NSMutableSet *feedKeywords = [[NSMutableSet alloc] initWithArray:latestKeywords];
    
    // get existing stored keywords for article
    NSMutableSet *storedKeywords = [self keywordsForArticle:article];
    
    // add new keywords from feed
    // if they are not already in stored keywords
    for (NSString *currKeyword in feedKeywords) {
        // do quick case sensitive search first
        if ([storedKeywords containsObject:currKeyword])
            continue;
        // do case insensitive search and store new case formatted keyword if match
        else if ((keywordMO = [self getKeywordWithText:currKeyword]) != nil) {
            keywordMO.text = currKeyword;
            [APP_MGR saveContext];
            continue;
        }
        else
            [self createNewKeyword:currKeyword inArticle:article];
        
    }
    
    // delete keywords that are stored
    // if they are not in feed
    for (NSString *currKeyword in storedKeywords) {
        if ([feedKeywords containsObject:currKeyword])
            continue;
        else
            [self removeArticle:article fromKeyword:currKeyword];
        
    }

}


-(NSArray *)articlesWithKeyword:(KeywordMO *)keyword
{
    
    return [keyword.articles allObjects];
    
}


// returns NSMutableSet for KeywordMO for
-(NSMutableSet *)keywordsForArticle:(ArticleMO *)storedArticle
{
    NSMutableSet *articleKeywords = [[NSMutableSet alloc] init];
    
    for (KeywordMO *storedKeyword in self.keywords) {
        if ([storedKeyword.articles containsObject:storedArticle] ) {
            [articleKeywords addObject:storedKeyword.text];
        }
    }

    return articleKeywords;

}


-(void)addArticleKeywords:(NSArray *)tags forArticle:(ArticleMO *)article
{
    KeywordMO *keywordMO;
    
    // for all 
    for (NSString *tag in tags) {
        
        // do case insensisive search
        if ((keywordMO = [self getKeywordWithText:tag]) == nil) {
            keywordMO = [self createNewKeyword:tag inArticle:article];
        
        } else {
            [keywordMO addArticlesObject:article];
            // always store the lastest case of keyword text
            keywordMO.text = tag;
        }
    }
}

@end
