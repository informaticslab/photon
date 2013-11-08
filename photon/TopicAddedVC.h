//
//  TopicAddedVC.h
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"
#import "Article.h"


@interface TopicAddedVC : UIViewController
@property(nonatomic, weak) Issue *issue;
@property(nonatomic, weak) Article *article;

@property (weak, nonatomic) IBOutlet UITextView *txtView;

@end
