//
//  Issue.m
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//
#import "Issue.h"

@implementation Issue

-(id)initWithTitle:(NSString *)title
{
    
    if (self = [super init]) {
        
        self.title = title;
        self.articles = [[NSMutableArray alloc] init];
        self.unread = YES;
        NSArray *titleSplit = [title componentsSeparatedByString:@"/"];
        if ([titleSplit count] == 3) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            self.date = [formatter dateFromString:titleSplit[0]];
            self.volume = [titleSplit[1] integerValue];
            self.number = [titleSplit[2] integerValue];
        }
    }
    
    return self;
}

-(id)initWithDate:(NSString *)dateString volume:(NSInteger)vol number:(NSInteger)num
{
    
    if (self= [super init]) {
        
        self.unread = YES;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        self.date = [formatter dateFromString:dateString];
        self.title = dateString;
        self.volume = vol;
        self.number = num;
        self.articles = [[NSMutableArray alloc] init];
        
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

-(Article *)getArticleWithTitle:(NSString *)title
{

    if (_articles.count == 0)
        return nil;
    
    for (Article *article in _articles) {
        if ([article.title isEqualToString:title])
            return article;
    }
    
    return nil;
    
}

-(Article *)addArticleWithTitle:(NSString *)title
{
    Article *newArticle = [[Article alloc] initWithTitle:title];
    
    [_articles addObject:newArticle];
    
    return newArticle;
    
}

-(Article *)storeArticle:(Article *)newArticle
{
    
    [_articles addObject:newArticle];
    newArticle.issue = self;
    return newArticle;
    
}


-(void)replaceArticle:(Article *)oldArticle withArticle:(Article *)newArticle
{
    NSUInteger oldIndex = [_articles indexOfObject:oldArticle];
    
    [_articles replaceObjectAtIndex:oldIndex withObject:newArticle];
    
}


-(NSUInteger)numberOfArticles
{
    return [_articles count];
    
}

@end
