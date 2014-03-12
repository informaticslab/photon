//
//  ContentPagesVC.h
//  photon
//
//  Created by jtq6 on 12/31/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IssueMO+Issue.h"
#import "ArticleMO+Article.h"

@interface ContentPagesVC : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property(nonatomic, weak) IssueMO *issue;
@property(nonatomic, weak) ArticleMO *article;



- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageHeaders;
@property (strong, nonatomic) NSArray *pageText;
@property (strong, nonatomic) NSArray *navbarTitles;
@property (strong, nonatomic) NSArray *icons;


@end
