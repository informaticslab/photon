//
//  SplitVC.m
//  photon
//
//  Created by jtq6 on 1/16/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "SplitViewManager.h"


@interface SplitViewManager ()

@end

@implementation SplitViewManager


-(id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
    
}

-(ArticleMO *)getSelectedArticle
{
    return self.selArticle;
    
}

-(void)setSelectedArticle:(ArticleMO *)selectedArticle
{
    self.selArticle = selectedArticle;
    DebugLog(@"Selected Article = %@", selectedArticle.title);
    if (self.articleSelectDelegate != nil)
        [self.articleSelectDelegate selectedArticle:selectedArticle];
    
}

-(void)setArticleSelectionDelegate:(id <ArticleSelectionDelegate>)vc
{
    self.articleSelectDelegate = vc;
}

-(void)searchStart
{
    
    [self.articleSelectDelegate noArticleSelected];
}

-(void)searchEnd
{
    
    [self.articleSelectDelegate articleSelected];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
