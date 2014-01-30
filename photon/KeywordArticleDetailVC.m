//
//  KeywordArticleDetailVC.m
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordArticleDetailVC.h"
#import "ArticleDetails.h"
#import "FullArticleVC.h"
#import "ShareActionSheet.h"

ShareActionSheet *shareAS;



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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = -1.0;
    self.navigationItem.rightBarButtonItem = shareButton;

    self.navigationItem.title = @"Article Details";
    _txtViewArticleTitle.text = _article.title;
    _txtViewArticleTitle.textAlignment = NSTextAlignmentCenter;
    _txtViewArticleTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18];

    _txtViewArticleIssueDate.text = [NSString stringWithFormat:@"Published on %@",_article.issue.title];
    _txtViewArticleIssueDate.textAlignment = NSTextAlignmentCenter;
    _txtViewArticleIssueDate.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    _txtViewArticleIssueVolNum.text = [NSString stringWithFormat:@"Volume %d, Number %d", _article.issue.volume, _article.issue.number];
    _txtViewArticleIssueVolNum.textAlignment = NSTextAlignmentCenter;
    _txtViewArticleIssueVolNum.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share:(id)sender
{
    // display the options for sharing
    shareAS = [[ShareActionSheet alloc] initToShareArticleUrl:self.article.url fromVC:self];
    [shareAS showView];
    
}




- (IBAction)btnViewFullArticleTouchUp:(id)sender {
    
    [self performSegueWithIdentifier:@"pushViewFullArticle" sender:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushViewFullArticle"])
    {
        FullArticleVC *fullArticleVC = segue.destinationViewController;
        fullArticleVC.url = _article.url;
        
    }
}

@end
