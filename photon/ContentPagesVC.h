//
//  ContentPagesVC.h
//  photon
//
//  Created by jtq6 on 12/31/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"
#import "Article.h"

@interface ContentPagesVC : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property(nonatomic, weak) Issue *issue;
@property(nonatomic, weak) Article *article;



- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageHeaders;
@property (strong, nonatomic) NSArray *pageText;
@property (strong, nonatomic) NSArray *navbarTitles;


@end
