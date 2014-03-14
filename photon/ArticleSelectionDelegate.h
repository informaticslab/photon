//
//  ArticleSelectionDelegate.h
//  photon
//
//  Created by Greg on 2/7/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArticleMO;

@protocol ArticleSelectionDelegate <NSObject>

@required
-(void)selectedArticle:(ArticleMO *)selArticle;
-(void)noArticleSelected;
-(void)articleSelected;

@end
