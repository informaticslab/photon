//
//  IssuesManager.h
//  photon
//
//  Created by jtq6 on 11/5/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssuesManager : NSObject

@property(nonatomic, strong) NSMutableArray *issues;
@property(nonatomic, strong) NSMutableDictionary *keywords;


-(id)initWithTestData;
-(NSArray *)articlesWithKeyword:(NSString *)keyword;


@end
