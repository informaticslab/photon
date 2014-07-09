//
//  KeywordSearchResults.h
//  photon
//
//  Created by jtq6 on 7/8/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordSearchResults : NSObject

@property(nonatomic, strong)NSArray *fetchedKeywordMOs;
@property NSUInteger fetchCount;

-(id)initAndSearchForKeyword:(NSString *)text;
-(void)mergeDuplicateKeywords;


@end
