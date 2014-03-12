//
//  IssueMO+Issue.h
//  photon
//
//  Created by jtq6 on 3/7/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "IssueMO.h"
#import "Article.h"
#import "ArticleMO.h"

@interface IssueMO (Issue)

-(void)initWithDate:(NSString *)date volume:(NSNumber *)vol number:(NSNumber *)num;


-(void)updateUnreadArticleStatus;
-(Article *)storeArticle:(Article *)newArticle;
-(ArticleMO *)getArticleWithTitle:(NSString *)title;
-(Article *)addArticleWithTitle:(NSString *)title;
-(void)replaceArticle:(ArticleMO *)oldArticle withArticle:(Article *)newArticle;
-(NSUInteger)numberOfArticles;


@end
