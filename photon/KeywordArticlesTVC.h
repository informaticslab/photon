//
//  KeywordArticlesTVC.h
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "ArticleSelectionDelegate.h"

@interface KeywordArticlesTVC : UITableViewController

@property(weak, nonatomic) NSString *keyword;
@property(nonatomic, weak) Article *selectedArticle;

@end
