//
//  Issue.m
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "Issue.h"
#import "Article.h"

@implementation Issue

-(id)initWithTitle:(NSString *)title
{
    
    if(self= [super init]) {
        
        self.title= title;
        self.articles = [[NSMutableArray alloc] init];
        self.unread = YES;
        NSArray *titleSplit = [_title componentsSeparatedByString:@"/"];
        if ([titleSplit count] == 3) {
            self.date = titleSplit[0];
            self.volume = titleSplit[1];
            self.number = titleSplit[2];
        }

    }
    
    return self;
}

-(void)updateUnreadArticleStatus
{
    int unreadCount = 0;
    
    for (Article *article in _articles)
        if (article.unread)
            unreadCount++;
    
    if (unreadCount > 0)
        self.unread = YES;
    else
        self.unread = NO;
    
}

@end
