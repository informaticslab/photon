//
//  IssueArticlesTVC.h
//  photon
//
//  Created by jtq6 on 11/7/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueMO+Issue.h"
#import "ArticleMO+Article.h"
#import "ArticleSelectionDelegate.h"
#import "ModalViewDelegate.h"
#import "PopoverViewDelegate.h"

@interface IssueArticlesTVC : UITableViewController <UIPopoverControllerDelegate, PopoverViewDelegate, ModalViewDelegate>

@property(nonatomic, weak) IssueMO *issue;
@property(nonatomic, weak) ArticleMO *article;
@property(nonatomic, weak) ArticleMO *selectedArticle;
@property (nonatomic, strong) UIPopoverController *detailViewPopover;

- (IBAction)refresh:(id)sender;
- (void)didDismissModalView;

@end
