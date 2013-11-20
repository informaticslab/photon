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

-(id)initWithTestData
{
    if (self = [super init]) {
        
        self.issues = [[NSMutableArray alloc]init];
        self.keywords = [[NSMutableDictionary alloc]init];
        [self loadTestData];
        
    };

    return self;
    
}

-(Issue *)newIssueWithTitle:(NSString *)title
{
    Issue *newIssue = [[Issue alloc]initWithTitle:title];
    
    [_issues addObject:newIssue];
    
    return newIssue;
    
}

-(Article *)newArticleWithTitle:(NSString *)title inIssue:(Issue *)currIssue
{
    Article *newArticle = [[Article alloc] initWithTitle:title];
    [currIssue.articles addObject:newArticle];
    newArticle.issue = currIssue;
    return newArticle;
                           
}

-(NSArray *)articlesWithKeyword:(NSString *)keyword
{
    NSArray *articles = [_keywords objectForKey:keyword];
    return articles;
}

                           
-(void)loadTestData
{
    
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Issues" ofType:@"json"];
    NSArray *testIssues = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                          options:kNilOptions
                                                            error:&err];
    Issue *currIssue = nil;
    Article *currArticle = nil;
    NSMutableArray *articlesWithKeyword = nil;
    
    NSLog(@"Imported Test Issues: %@", testIssues);
    
    for (NSDictionary *issue in testIssues)
    {
        // create and add issue
        currIssue = [self newIssueWithTitle:[issue valueForKey:@"title"]];
        NSLog(@"Issue title: %@", [issue valueForKey:@"title"]);

        // get collection of articles for currrent issue
        NSArray *newArticles = [issue valueForKey:@"articles"];
        
        NSLog(@"articles: %@", newArticles);
        for (NSDictionary *article in newArticles) {
            
            // add new article to current issues
            NSLog(@"title: %@", [article valueForKey:@"title"]);
            currArticle = [self newArticleWithTitle:[article valueForKey:@"title"]  inIssue:currIssue];
            
            currArticle.already_know = [article valueForKey:@"already_known"];
            NSLog(@"already_known: %@", [article valueForKey:@"already_known"]);
            
            currArticle.added_by_report = [article valueForKey:@"added_by_report"];
            NSLog(@"added_by_report: %@", [article valueForKey:@"added_by_report"]);
            
            currArticle.implications = [article valueForKey:@"implications"];
            NSLog(@"implications: %@", [article valueForKey:@"implications"]);
            
            // get collection of articles for currrent issue
            NSArray *newKeywords = [article valueForKey:@"keywords"];
            
            NSLog(@"tags: %@", newKeywords);
            for (NSDictionary *keyword in newKeywords) {
                NSString *currKeyword = [keyword valueForKey:@"keyword"];
                if ((articlesWithKeyword = [_keywords objectForKey:currKeyword]) == nil) {
                    articlesWithKeyword = [[NSMutableArray alloc] initWithObjects:currArticle, nil];
                    [_keywords setObject:articlesWithKeyword forKey:currKeyword];
                    
                } else {
                    [articlesWithKeyword addObject:currArticle];
                }
                [currArticle.tags addObject:currKeyword];
            };
        }
    }
}

@end