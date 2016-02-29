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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
 

    self.navigationItem.title = @"Article Details";
    _txtViewArticleTitle.text = _article.title;
    _txtViewArticleTitle.textAlignment = NSTextAlignmentCenter;
    _txtViewArticleTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy";

    _txtViewArticleIssueDate.text = [NSString stringWithFormat:@"Published on %@",[formatter stringFromDate:_article.issue.date]];
    _txtViewArticleIssueDate.textAlignment = NSTextAlignmentCenter;
    _txtViewArticleIssueDate.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    
    _txtViewArticleIssueVolNum.text = [NSString stringWithFormat:@"Volume %@, Number %@", _article.issue.volume, _article.issue.number];
    _txtViewArticleIssueVolNum.textAlignment = NSTextAlignmentCenter;
    _txtViewArticleIssueVolNum.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_DETAILS inSection:SC_SECTION_DETAILS];

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

- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




- (IBAction)btnViewFullArticleTouchUp:(id)sender {
    
    if (APP_MGR.isDeviceIpad)
        [self.popoverViewDelegate didClickFullArticleButton];
    else
        [self performSegueWithIdentifier:@"pushViewFullArticle" sender:nil];


}

- (IBAction)btnDoneTouchUp:(UIBarButtonItem *)sender {
    
    [self.popoverViewDelegate didClickDoneButton];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushViewFullArticle"])
    {
      //  FullArticleVC *fullArticleVC = segue.destinationViewController;
        //fullArticleVC.url = _article.url;
        
    }
    

}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Articles", @"Articles");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}



@end
