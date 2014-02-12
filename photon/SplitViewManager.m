//
//  SplitVC.m
//  photon
//
//  Created by jtq6 on 1/16/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "SplitViewManager.h"
#import "ArticleSelectionDelegate.h"


@interface SplitViewManager ()

@end

@implementation SplitViewManager


-(id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
    
}


-(void)setArticleSelectionDelegate:(ContentIpadVC *)vc
{
    self.issueArticlesTVC.articleSelectDelegate = vc;

}

-(Article *)getSelectedArticle
{
    return self.issueArticlesTVC.article;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
