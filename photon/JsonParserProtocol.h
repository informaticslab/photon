//
//  SchemaParser.h
//  photon
//
//  Created by jtq6 on 1/25/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Issue;
@class Article;

@protocol JsonParserProtocol <NSObject>

-(Article *)parseArticleJson:(NSDictionary *)json;
-(Issue *)parseIssueJson:(NSDictionary *)json;
-(NSArray *)parseTagsJson:(NSDictionary *)json;
-(NSInteger)parseContentVersionJson:(NSDictionary *)json;

@end
