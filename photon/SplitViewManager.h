//
//  SplitVC.h
//  photon
//
//  Created by jtq6 on 1/16/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueArticlesTVC.h"
#import "ContentPagesiPadVC.h"
#import "ContentIpadVC.h"
#import "Article.h"

@interface SplitViewManager : UISplitViewController

@property(weak, nonatomic) IssueArticlesTVC *issueArticlesTVC;
@property(weak, nonatomic) ContentPagesiPadVC *contentPagesiPadVC;
@property(weak, nonatomic) ContentIpadVC *contentIpadVC;
@property(weak, nonatomic) Article *selectedArticle;

-(void)setArticleSelectionDelegate:(ContentIpadVC *)vc;
-(Article *)getSelectedArticle;

@end
