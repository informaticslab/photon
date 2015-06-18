//
//  Article.m
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "FeedArticle.h"

@implementation FeedArticle


-(id)initWithTitle:(NSString *)title
{
    
    if(self= [super init]) {
        
        self.title = title;
        self.unread = YES;
        
    }
    
    return self;
    
}

-(id)initWithTitle:(NSString *)title version:(NSInteger)ver
{

    if(self= [super init]) {
        
        self.title = title;
        self.unread = YES;
        self.version = ver;
        
    }
    
    return self;

}

@end
