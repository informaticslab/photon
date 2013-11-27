//
//  KeywordArticleDetailVC.h
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface KeywordArticleDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnViewArticle;
@property (weak, nonatomic) Article *article;
@property (weak, nonatomic) IBOutlet UITextView *txtViewArticleDetails;
- (IBAction)btnViewFullArticleTouchUp:(id)sender;

@end
