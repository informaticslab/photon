//
//  Issue.h
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedArticle.h"

@class FeedArticle;

@interface Issue : NSObject

@property(strong, nonatomic) NSMutableArray *articles;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSDate *date;
@property NSInteger number;
@property NSInteger volume;
@property BOOL unread;

-(id)initWithTitle:(NSString *)title;
-(id)initWithDate:(NSString *)date volume:(NSInteger)vol number:(NSInteger)num;


-(void)updateUnreadArticleStatus;
-(FeedArticle *)storeArticle:(FeedArticle *)newArticle;
-(FeedArticle *)getArticleWithTitle:(NSString *)title;
-(FeedArticle *)addArticleWithTitle:(NSString *)title;
-(void)replaceArticle:(FeedArticle *)oldArticle withArticle:(FeedArticle *)newArticle;
-(NSUInteger)numberOfArticles;


@end
