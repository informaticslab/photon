//
//  KeywordArticleDetailVC.h
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "ModalViewDelegate.h"

@interface KeywordArticleDetailVC : UIViewController<UISplitViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *btnViewArticle;
@property (weak, nonatomic) Article *article;
@property (weak, nonatomic) IBOutlet UITextView *txtViewArticleTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtViewArticleIssueDate;
@property (weak, nonatomic) IBOutlet UITextView *txtViewArticleIssueVolNum;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) id <ModalViewDelegate> modalDelegate;

- (IBAction)btnViewFullArticleTouchUp:(id)sender;

- (IBAction)btnDoneTouchUp:(UIBarButtonItem *)sender;
@end
