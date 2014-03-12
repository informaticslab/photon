//
//  SplitVC.h
//  photon
//
//  Created by jtq6 on 1/16/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueArticlesTVC.h"
#import "KeywordArticlesTVC.h"
#import "ContentPagesiPadVC.h"
#import "ContentIpadVC.h"
#import "ArticleMO+Article.h"
#import "ArticleSelectionDelegate.h"

@interface SplitViewManager : UISplitViewController

@property(weak, nonatomic) IssueArticlesTVC *issueArticlesTVC;
@property(weak, nonatomic) KeywordArticlesTVC *keywordArticlesTVC;
@property(weak, nonatomic) ContentPagesiPadVC *contentPagesiPadVC;
@property(weak, nonatomic) ContentIpadVC *contentIpadVC;
@property(weak, nonatomic) ArticleMO *selArticle;
@property(weak, nonatomic) id <ArticleSelectionDelegate> articleSelectDelegate;

-(void)setArticleSelectionDelegate:(ContentIpadVC *)vc;
-(ArticleMO *)getSelectedArticle;
-(void)setSelectedArticle:(ArticleMO *)selArticle;
-(void)searchStart;
-(void)searchEnd;

@end
