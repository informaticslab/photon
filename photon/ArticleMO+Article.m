//
//  ArticleMO+Article.m
//  photon
//
//  Created by jtq6 on 3/7/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "ArticleMO+Article.h"

@implementation ArticleMO (FeedArticle)



-(void)initWithTitle:(NSString *)title
{
        self.title = title;
        self.unread = [NSNumber numberWithBool:YES];
}

-(void)initWithTitle:(NSString *)title version:(NSInteger)ver
{
    
        self.title = title;
        self.unread = [NSNumber numberWithBool:YES];
        self.version = [NSNumber numberWithInteger:ver];
    
}


@end
