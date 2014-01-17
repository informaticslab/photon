//
//  Issue.h
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@class Article;

@interface Issue : NSObject

@property(strong, nonatomic) NSMutableArray *articles;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSDate *date;
@property(strong, nonatomic) NSString *number;
@property(strong, nonatomic) NSString *volume;
@property BOOL unread;

-(id)initWithTitle:(NSString *)title;
-(void)updateUnreadArticleStatus;
-(Article *)getArticleWithTitle:(NSString *)title;
-(Article *)addArticleWithTitle:(NSString *)title;
-(void)replaceArticle:(Article *)oldArticle withArticle:(Article *)newArticle;

@end
