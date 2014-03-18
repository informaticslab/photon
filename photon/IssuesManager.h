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


-(id)init;


-(NSArray *)articlesWithKeyword:(KeywordMO *)keyword;
-(void)newArticle:(Article *)article inIssue:(Issue *)issue withTags:(NSArray *)tags version:(NSInteger)ver;
-(IssueMO *)getSortedIssueForIndex:(NSUInteger)index;
-(void)reloadData;

@end
