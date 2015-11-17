//
//  IssuesManager.h
//  photon
//
//  Created by jtq6 on 11/5/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonParser.h"
#import "IssueMO+Issue.h"
#import "KeywordMO.h"

@interface IssuesManager : NSObject

@property(nonatomic, strong) NSMutableDictionary *issues;
@property(nonatomic, strong) NSArray *sortedIssues;
@property(nonatomic, strong) NSArray *keywords;
@property BOOL hasIssues;


-(id)init;


-(NSArray *)articlesWithKeyword:(KeywordMO *)keyword;
-(void)newArticle:(FeedArticle *)article inIssue:(Issue *)issue withTags:(NSArray *)tags;
-(IssueMO *)getSortedIssueForIndex:(NSUInteger)index;
-(void)reloadData;
-(void)clearAllData;

@end
