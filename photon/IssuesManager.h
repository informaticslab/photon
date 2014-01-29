//
//  IssuesManager.h
//  photon
//
//  Created by jtq6 on 11/5/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonParser.h"
#import "Issue.h"

@interface IssuesManager : NSObject

@property(nonatomic, strong) NSMutableDictionary *parsedIssues;
@property(nonatomic, strong) NSMutableDictionary *issues;
@property(nonatomic, strong) NSArray *sortedIssues;
@property(nonatomic, strong) NSMutableDictionary *keywords;
@property(nonatomic, strong) NSMutableArray *parsedItems;
@property(nonatomic, strong) NSMutableArray *parsedJsonBlobs;

-(id)init;


-(NSArray *)articlesWithKeyword:(NSString *)keyword;
-(Article *)newArticleWithTitle:(NSString *)title inIssue:(Issue *)currIssue revision:(NSInteger)ver;
-(void)newArticle:(Article *)article inIssue:(Issue *)issue withTags:(NSArray *)tags version:(NSInteger)ver;
-(Issue *)getSortedIssueForIndex:(NSUInteger)index;


@end
