//
//  ArticleSelectionDelegate.h
//  photon
//
//  Created by Greg on 2/7/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Article;

@protocol ArticleSelectionDelegate <NSObject>

@required
-(void)selectedArticle:(Article *)selArticle;

@end
