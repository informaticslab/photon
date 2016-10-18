//
//  KeywordArticlesTVC.h
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleMO+Article.h"
#import "ArticleSelectionDelegate.h"
#import "ModalViewDelegate.h"
#import "IssueMO+Issue.h"
#import "KeywordMO.h"
#import "PopoverViewDelegate.h"


@interface KeywordArticlesTVC : UITableViewController<UIPopoverControllerDelegate, PopoverViewDelegate, ModalViewDelegate>

@property(weak, nonatomic) KeywordMO *keyword;
@property(nonatomic, weak) ArticleMO *selectedArticle;
@property(nonatomic, weak) IssueMO *issue;


- (void)didDismissModalView;


@end
