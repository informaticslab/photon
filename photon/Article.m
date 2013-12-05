//
//  Article.m
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "Article.h"

@implementation Article


-(id)initWithTitle:(NSString *)title
{
    
    if(self= [super init]) {
        
        self.title = title;
        self.tags = [[NSMutableArray alloc]init];
        self.unread = YES;
        
    }
    
    return self;
}

@end
