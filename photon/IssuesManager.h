//
//  IssuesManager.h
//  photon
//
//  Created by jtq6 on 11/5/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@interface IssuesManager : NSObject<MWFeedParserDelegate>

@property(nonatomic, strong) NSMutableDictionary *parsedIssues;
@property(nonatomic, strong) NSArray *issues;
@property(nonatomic, strong) NSMutableDictionary *keywords;
@property(nonatomic, strong) MWFeedParser *feedParser;
@property(nonatomic, strong) NSMutableArray *parsedItems;
@property(nonatomic, strong) NSMutableArray *parsedJsonBlobs;

-(id)initWithTestData;
-(id)initWithFeedParser;
-(void)updateFromFeed;

-(NSArray *)articlesWithKeyword:(NSString *)keyword;


@end
