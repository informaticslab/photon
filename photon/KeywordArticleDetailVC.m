//
//  KeywordArticleDetailVC.m
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordArticleDetailVC.h"
#import "ArticleDetails.h"

@interface KeywordArticleDetailVC ()

@end

@implementation KeywordArticleDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CALayer *btnLayer = [_btnViewArticle layer];
    self.navigationItem.title = @"Article Details";
    _txtViewArticleDetails.text = _article.issue.title;
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushArticleDetailsForKeywordArticleDetail"])
    {
        ArticleDetails *articleDetailsVC = segue.destinationViewController;
        articleDetailsVC.article = _article;
        articleDetailsVC.issue = _article.issue;
        
    }
}



@end
