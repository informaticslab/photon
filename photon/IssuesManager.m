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
#import "IssueMO+Issue.h"
#import "ArticleMO+Article.h"
#import "KeywordMO.h"


@implementation IssuesManager

NSManagedObjectModel *model;
NSManagedObjectContext *context;



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
        NSArray *fetchedObjects = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"Issues Manager has no stored issues.");
        }
    
        self.sortedIssues = fetchedObjects;
        self.issues = [[NSMutableDictionary alloc]init];

        fetchRequest = [[model fetchRequestTemplateForName:@"GetAllKeywords"] copy];
        
        // Specify how the fetched objects should be sorted
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        error = nil;
        fetchedObjects = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"Issues Manager has no stored keywords.");
        }
        
        
        self.keywords = fetchedObjects;
        
    };

    return self;
    
}

-(void)reloadData
{
    
    NSFetchRequest *fetchRequest = [[model fetchRequestTemplateForName:@"GetAllIssues"] copy];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Issues Manager has no stored issues.");
    }
    
    self.sortedIssues = fetchedObjects;
    
    fetchRequest = [[model fetchRequestTemplateForName:@"GetAllKeywords"] copy];
    
    // Specify how the fetched objects should be sorted
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text"
                                                 ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    error = nil;
    fetchedObjects = [APP_MGR.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Issues Manager has no stored keywords.");
    }
    
    
    self.keywords = fetchedObjects;
    
    
    
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
    
    if (fetchedObjects == nil) {
        NSLog(@"Issues Manager has no issues with date = %@, volume = %ld, number = %ld", newIssue.date, (long)newIssue.volume, (long)newIssue.number);
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
-(BOOL)isArticleNew:(Article *)article inIssue:(IssueMO *)issue
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


-(ArticleMO *)createNewArticle:(Article *)newArticle inIssue:(IssueMO *)issue
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


-(void)newArticle:(Article *)article inIssue:(Issue *)issue withTags:(NSArray *)tags version:(NSInteger)ver
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
        
    } else {
        
        storedArticle = [storedIssue getArticleWithTitle:article.title];
        
        // check if version number is greater than current version
        if (article.version > storedArticle.version.integerValue ) {
            
            // create new article object and replace the old with new
            [storedIssue replaceArticle:storedArticle withArticle:article];
            
        }
    }
    
    [self addArticleKeywords:tags forArticle:storedArticle];

}

#pragma mark - Keyword methods
-(KeywordMO *)createNewKeyword:(NSString *)text inArticle:(ArticleMO *)article
{
    
    KeywordMO *keyword = (KeywordMO *)[NSEntityDescription
                                       insertNewObjectForEntityForName:@"KeywordMO"
                                       inManagedObjectContext:context];
    
    keyword.text = text;
    [keyword addArticlesObject:article];
    
    [APP_MGR saveContext];
    return keyword;
}



-(NSArray *)articlesWithKeyword:(KeywordMO *)keyword
{
    
    return [keyword.articles allObjects];
    
}


-(KeywordMO *)getKeywordWithText:(NSString *)text
{
    
    NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            text, @"TEXT", nil];
    
    NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"GetKeywordWithText" substitutionVariables:substitutionDictionary];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Issues Manager has no keyword with text = %@.", text);
        return nil;
    }
    else if([fetchedObjects count] == 1)
        return (KeywordMO *)[fetchedObjects objectAtIndex:0];
    else
        return nil;
    
}

-(void)addArticleKeywords:(NSArray *)tags forArticle:(ArticleMO *)article
{
    KeywordMO *keywordMO;
    
    for (NSString *tag in tags) {
        
        if ((keywordMO = [self getKeywordWithText:tag]) == nil) {
            keywordMO = [self createNewKeyword:tag inArticle:article];
        
        } else {
            [keywordMO addArticlesObject:article];
            
        }
    }
}





@end
