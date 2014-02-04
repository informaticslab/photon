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
    
    //_sortedIssues = [[_issues allKeys] sortedArrayUsingSelector:@selector(compare:options::)];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO selector:@selector(localizedCompare:)];
    _sortedIssues = [[_issues allKeys]  sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
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


-(Issue *)getSortedIssueForIndex:(NSUInteger)index
{
    if ([self.issues count] == 0)
        return nil;
    
    if ([self.sortedIssues count] == 0)
        return nil;
    
    NSString *issueKey = _sortedIssues[index];
    
    return [self.issues objectForKey:issueKey];
    
}

-(Article *)getLatestArticle
{
    Issue *latestIssue = (Issue *)self.sortedIssues[0];
    
    if (latestIssue != nil) {
        Article *latestArticle = latestIssue.articles[0];
        if (latestArticle != nil) {
            return latestArticle;
        }
    }
    
    return nil;
    
}



@end
