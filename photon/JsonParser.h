//
//  JsonParser.h
//  photon
//
//  Created by jtq6 on 1/26/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssuesManager.h"


@interface JsonParser : NSObject<MWFeedParserDelegate>

-(NSInteger)parseJsonBlob:(NSDictionary *)json;

@property(nonatomic, strong) NSMutableDictionary *parsedIssues;
@property(nonatomic, strong) NSMutableDictionary *parsedKeywords;
@property(nonatomic, strong) MWFeedParser *feedParser;
@property(nonatomic, strong) NSMutableArray *parsedItems;
@property(nonatomic, strong) NSMutableArray *parsedJsonBlobs;
@property(nonatomic, strong) NSArray *schemaParsers;



-(id)init;
-(id)initWithFeedParser;
-(void)updateFromFeed;
-(void)parseTestData;


@end
