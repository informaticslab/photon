//
//  KeywordMO.m
//  photon
//
//  Created by jtq6 on 3/12/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordMO.h"
#import "ArticleMO.h"


@implementation KeywordMO

@dynamic text;
@dynamic articles;

-(NSString *)debugDescription
{
    
    NSString *returnString = [NSString stringWithFormat:@"Keyword text=%@", self.text];
    return returnString;
    
}

@end
