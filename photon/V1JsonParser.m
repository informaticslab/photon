//
//  V1SchemaParser.m
//  photon
//
//  Created by jtq6 on 1/25/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "V1JsonParser.h"
#import "Issue.h"
#import "Article.h"

@implementation V1JsonParser


-(NSInteger)parseContentVersionJson:(NSDictionary *)json
{
    
    NSInteger contentVer = [JsonParserBase integerValueForKey:@"content-ver" inJson:json];
    return contentVer;
}


-(Article *)parseArticleJson:(NSDictionary *)json
{

    NSString *title = [JsonParserBase stringValueForKey:@"title" inJson:json];
    NSString *known = [JsonParserBase stringValueForKey:@"already_known" inJson:json];
    NSString *added = [JsonParserBase stringValueForKey:@"added_by_report" inJson:json];
    NSString *implications = [JsonParserBase stringValueForKey:@"implications" inJson:json];
    
    NSString *url = [JsonParserBase stringValueForKey:@"url" inJson:json];
    Article *parsedArticle = [[Article alloc] initWithTitle:title];
    parsedArticle.already_know = known;
    parsedArticle.added_by_report = added;
    parsedArticle.implications = implications;
    parsedArticle.url = url;
    
    return parsedArticle;
    
}

-(Issue *)parseIssueJson:(NSDictionary *)json
{
    
    NSString *title = [JsonParserBase stringValueForKey:@"issue-date" inJson:json];
    NSInteger vol = [JsonParserBase integerValueForKey:@"issue-vol" inJson:json];
    NSInteger num = [JsonParserBase integerValueForKey:@"issue-no" inJson:json];

    Issue *parsedIssue = [[Issue alloc] initWithDate:title volume:vol number:num];
    
    return parsedIssue;
    
}

-(NSArray *)parseTagsJson:(NSDictionary *)json
{
    
    // get collection of articles for currrent issue
    NSArray *newTags = [json valueForKey:@"tags"];
    
    // if no tags return nil
    if ([newTags count] == 0)
        return nil;
    
    NSMutableArray *parsedTags = [[NSMutableArray alloc] init];
    
    DebugLog(@"\tTags:");
    for (NSDictionary *tag in newTags) {
        NSString *currTag = [tag valueForKey:@"tag"];
        if ([currTag isEqualToString:@"Cancer"])
            DebugLog(@"Found Cancer.");
        DebugLog(@"\t\ttag:%@", currTag);
        [parsedTags addObject:currTag];
    };
    
    return [NSArray arrayWithArray:parsedTags];
    
 }




@end
