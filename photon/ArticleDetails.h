//
//  ArticleDetails.h
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueMO+Issue.h"
#import "ArticleMO+Article.h"

@interface ArticleDetails : UIViewController

@property(nonatomic, weak) Issue *issue;
@property(nonatomic, weak) Article *article;

@end
