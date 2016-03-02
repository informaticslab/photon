//
//  IssueMO+Issue.m
//  photon
//
//  Created by jtq6 on 3/7/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "IssueMO+Issue.h"
#import "ArticleMO+Article.h"

@implementation IssueMO (Issue)



-(void)initWithDate:(NSString *)dateString volume:(NSNumber *)vol number:(NSNumber *)num
{
    
    self.unread = [NSNumber numberWithBool:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.date = [formatter dateFromString:dateString];
    self.title = dateString;
    self.volume = vol;
    self.number = num;
    
}


-(void)updateUnreadArticleStatus
{
    int unreadCount = 0;
    
    for (ArticleMO *article in self.articles)
        if (article.unread)
            unreadCount++;
    
    if (unreadCount > 0)
        self.unread = [NSNumber numberWithBool:YES];
    else
        self.unread = [NSNumber numberWithBool:NO];
    [APP_MGR saveContext];
    
}

-(ArticleMO *)getArticleWithTitle:(NSString *)title
{
    
    if (self.articles.count == 0)
        return nil;
    
    for (ArticleMO *article in self.articles) {
        if ([article.title isEqualToString:title])
            return article;
    }
    
    return nil;
    
}

-(ArticleMO *)addArticleWithTitle:(NSString *)title
{
    ArticleMO *newArticle = (ArticleMO *)[NSEntityDescription
                                          insertNewObjectForEntityForName:@"ArticleMO"
                                          inManagedObjectContext:self.managedObjectContext];
    [newArticle initWithTitle:title];
    newArticle.issue = self;
    
    return newArticle;
    
}


-(void)deleteArticle:(ArticleMO *)article
{
    // delete article from set of articles
    NSMutableSet *articles = [NSMutableSet setWithSet:self.articles];
    [articles removeObject:article];
    self.articles = articles;
    
    //delete article managed object
    [APP_MGR.managedObjectContext deleteObject:article];

    return;
}




-(void)updateArticle:(ArticleMO *)storedArticle withArticle:(FeedArticle *)updatedArticle
{
    storedArticle.implications = updatedArticle.implications;
    storedArticle.added_by_report = updatedArticle.added_by_report;
    storedArticle.already_known = updatedArticle.already_know;
    storedArticle.url = updatedArticle.url;
    [APP_MGR saveContext];
    
}


-(NSUInteger)numberOfArticles
{
    
    return [self.articles count];
    
}


@end
