//
//  TopicKnownVC.h
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"
#import "Article.h"

#define TOPIC_KNOWN 0
#define TOPIC_ADDED 1
#define TOPIC_IMPLICATIONS 2


@interface TopicVC : UIViewController <UITextViewDelegate>

@property(nonatomic, weak) Issue *issue;
@property(nonatomic, weak) Article *article;
@property NSInteger mode;

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIScrollView *topicScrollView;

@property (weak, nonatomic) IBOutlet UITextField *txtfSourceArticleHeading;
@property (weak, nonatomic) IBOutlet UITextView *txtvSourceArticle;

@property (weak, nonatomic) IBOutlet UITextView *txtView;

@property (weak, nonatomic) IBOutlet UIButton *btnViewFullArticle;

- (IBAction)btFullArticleTouchUp:(id)sender;

@end
