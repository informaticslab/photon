//
//  IssueMO+Issue.h
//  photon
//
//  Created by jtq6 on 3/7/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "IssueMO.h"
#import "FeedArticle.h"
#import "ArticleMO.h"

@interface IssueMO (Issue)

-(void)initWithDate:(NSString *)date volume:(NSNumber *)vol number:(NSNumber *)num;


-(void)updateUnreadArticleStatus;
-(ArticleMO *)getArticleWithTitle:(NSString *)title;
-(FeedArticle *)addArticleWithTitle:(NSString *)title;
-(void)updateArticle:(ArticleMO *)oldArticle withArticle:(FeedArticle *)newArticle;
-(NSUInteger)numberOfArticles;


@end
