//
//  ContentIpadVC.m
//  photon
//
//  Created by jtq6 on 1/14/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "ContentIpadVC.h"
#import "ShareActionSheet.h"
#import "InfoVC.h"

@implementation ContentIpadVC

ShareActionSheet *shareAS;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLayoutSubviews{
    
    //CGSize containerSize = self.containerView.frame.size;
    NSInteger height = self.txtvAddedText.contentSize.height + self.txtvKnownText.contentSize.height + self.txtvImplicationsText.contentSize.height + self.txtvArticleTitle.contentSize.height + 300;
//    CGSize scrollContentSize = CGSizeMake(containerSize.width, height);
    self.summaryScrollView.contentSize = CGSizeMake(self.summaryScrollView.contentSize.width, height);
    DebugLog(@"Content view width = %.2f", self.summaryScrollView.contentSize.width);
    DebugLog(@"Scrollview height = %lu", (unsigned long)height);
    

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    APP_MGR.splitVM.contentIpadVC = self;
    [APP_MGR.splitVM setArticleSelectionDelegate:self];
    self.grayedOutContentView.hidden = YES;
    self.fullArticleContentView.hidden = NO;
    
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Summary";
    self.navigationItem.accessibilityLabel = @"Summary of Article";
    
    
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1];

    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = 30.0;
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.accessibilityHint = @"Double tap to access information about MMWR Express.";
    infoButton.accessibilityLabel = @"MMWR Express Info";

    
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setLeftBarButtonItem:modalButton animated:YES];
    
    
    self.navigationItem.rightBarButtonItems  = @[shareButton, modalButton];
    
    
    
    [self.txtvKnownText setScrollEnabled:NO];
    [self.txtvKnownText setUserInteractionEnabled:YES];
    self.txtvKnownText.delegate = self;
    self.txtvKnownText.showsVerticalScrollIndicator = YES;
    self.txtvKnownText.text = self.contentText;
    [self.txtvKnownText sizeToFit];
    [self.txtvKnownText layoutIfNeeded];
    
    [self.txtvAddedText setScrollEnabled:NO];
    [self.txtvAddedText setUserInteractionEnabled:YES];
    self.txtvAddedText.delegate = self;
    self.txtvAddedText.showsVerticalScrollIndicator = YES;
    self.txtvAddedText.text = self.contentText;
    [self.txtvAddedText sizeToFit];
    [self.txtvAddedText layoutIfNeeded];
    

    [self.txtvImplicationsText setScrollEnabled:NO];
    [self.txtvImplicationsText setUserInteractionEnabled:YES];
    self.txtvImplicationsText.delegate = self;
    self.txtvImplicationsText.showsVerticalScrollIndicator = YES;
    self.txtvImplicationsText.text = self.contentText;
    [self.txtvImplicationsText sizeToFit];
    [self.txtvImplicationsText layoutIfNeeded];

    [self.txtvArticleTitle setScrollEnabled:NO];
    [self.txtvArticleTitle setUserInteractionEnabled:YES];
    self.txtvArticleTitle.delegate = self;
    self.txtvArticleTitle.showsVerticalScrollIndicator = YES;
    self.txtvArticleTitle.text = self.contentText;
    [self.txtvArticleTitle sizeToFit];
    [self.txtvArticleTitle layoutIfNeeded];


    self.parentViewController.navigationItem.title = self.navbarTitle;
    
    // Setup the popover for use from the navigation bar.
    InfoVC *content = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPopoverVC"];

	self.infoPopoverController = [[UIPopoverController alloc] initWithContentViewController:content];
	self.infoPopoverController.popoverContentSize = CGSizeMake(400., 540.);
	self.infoPopoverController.delegate = self;
    content.popoverViewDelegate = self;

    if ([APP_MGR isSummaryDefaultArticleView] == YES) {
        self.segCtrlArticleView.selectedSegmentIndex = 1;
        [self selectSummaryView];

    } else {
        self.segCtrlArticleView.selectedSegmentIndex = 0;
        [self selectFullArticleView];
    }

    DebugLog(@"ContentIPadVC viewDidLoad() called");

}

-(void)flashScrollingIndicators
{
    
    [self.txtvKnownText flashScrollIndicators];
    [self.txtvAddedText flashScrollIndicators];
    [self.txtvImplicationsText flashScrollIndicators];
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedFullArticleView"]) {
        self.childFullArticleVC = (FullArticleVC *) [segue destinationViewController];
     }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self selectedArticle:[APP_MGR.splitVM getSelectedArticle]];
    DebugLog(@"ContentIPadVC viewWillAppear() called");


}


-(void)viewDidAppear:(BOOL)animated
{
    DebugLog(@"ContentIPadVC viewDidAppear() called");

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


- (IBAction)infoButtonAction:(UIBarButtonItem *)sender
{
	// Set the sender to a UIButton.
	UIButton *tappedButton = (UIButton *)sender;
	
	// Present the popover from the button that was tapped in the detail view.
	[self.infoPopoverController presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	// Set the last button tapped to the current button that was tapped.
	//self.lastTappedButton = sender;
}

-(void)didTouchReadUserAgreementButton
{
    
    // dismiss popover
    [self.infoPopoverController dismissPopoverAnimated:YES];
    [self presentEulaModalView];
    
    
}

-(void)selectSummaryView
{
    self.fullArticleContentView.hidden = YES;
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SUMMARY inSection:SC_SECTION_ARTICLE];
    
}


-(void)selectFullArticleView
{
    self.fullArticleContentView.hidden = NO;
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_FULL inSection:SC_SECTION_ARTICLE];
    
    
}



- (IBAction)segCtrlFullSummary:(id)sender {
    
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    
    if (segCtrl.selectedSegmentIndex == 0) {
        [self selectFullArticleView];
    } else if (segCtrl.selectedSegmentIndex == 1) {
        [self selectSummaryView];
        [self flashScrollingIndicators];
    }
    if (self.article != nil)
        self.grayedOutContentView.hidden = YES;
    else
        self.grayedOutContentView.hidden = NO;
    
}


- (void)presentEulaModalView
{
    static BOOL alwaysShowEula = TRUE;
    
    if (APP_MGR.agreedWithEula == TRUE && alwaysShowEula == FALSE)
        return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@",
                             [appInfo objectForKey:@"CFBundleShortVersionString"],
                             [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed] || alwaysShowEula) {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        DebugLog(@"Data saved");
        DebugLog(@"%@", currVersion);
        
        //
        [self performSegueWithIdentifier:@"displayEulaSegue" sender:self];
    }
    
    
}


-(void)selectedArticle:(ArticleMO *)selArticle
{
    DebugLog(@"ContentIPadVC selectedArticle() called");

    if (selArticle == nil)
        return;

    DebugLog(@"Article title is %@", self.article.title);
    

    _article = selArticle;
    
    [self.childFullArticleVC loadUrl:_article.url];

    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.txtvKnownText.text = _article.already_known;
    self.txtvKnownText.font = font;
    self.txtvKnownText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    [self.txtvKnownText sizeToFit];
    [self.txtvKnownText setNeedsDisplay];

    
    self.txtvAddedText.text = _article.added_by_report;
    self.txtvAddedText.font = font;
    self.txtvAddedText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    [self.txtvAddedText sizeToFit];
    [self.txtvAddedText setNeedsDisplay];

    self.txtvImplicationsText.text = _article.implications;
    self.txtvImplicationsText.font = font;
    self.txtvImplicationsText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    [self.txtvImplicationsText sizeToFit];
    [self.txtvImplicationsText setNeedsDisplay];

    self.txtvArticleTitle.text = _article.title;
    self.txtvArticleTitle.font = APP_MGR.tableFont;
    self.txtvArticleTitle.textAlignment = NSTextAlignmentCenter;
    [self.txtvArticleTitle sizeToFit];
    [self.txtvArticleTitle setNeedsDisplay];
    

    self.navigationItem.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", @"Summary of Article with title ", self.article.title];
    [self.containerView setNeedsDisplay];

    
    
//    // track page
//    if (self.segCtrlArticleView.selectedSegmentIndex == 0) {
//        [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_FULL inSection:SC_SECTION_SUMMARY];
//
//    } else {
//        [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SUMMARY inSection:SC_SECTION_SUMMARY];
//    }

    // now with all the content setup, calculate and set scrollview size
    [self flashScrollingIndicators];
//    float sizeOfContent = 0;
//    UIView *lastView = [self.summaryScrollView.subviews lastObject];
//    UIView *lastView = self.containerView;
//
//    NSInteger width = lastView.frame.origin.y;
//    NSInteger height = lastView.frame.size.height;
//    sizeOfContent = width+height;
//    self.summaryScrollView.contentSize = CGSizeMake(self.summaryScrollView.frame.size.width, sizeOfContent);
    

    
    
//    DebugLog(@"lastview width = %lu, height = %lu", (unsigned long)width, (unsigned long)height);
//    DebugLog(@"Scrollview content size = %.2f", sizeOfContent);
//    DebugLog(@"Scrollview content size = %.2f", sizeOfContent);

    
}

-(void)noArticleSelected
{
    
    self.grayedOutContentView.hidden = NO;
    self.article = nil;
    self.navigationItem.accessibilityLabel = @"Summary of Article. No article is currently selected.";

}


-(void)articleSelected
{
    
    self.grayedOutContentView.hidden = YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Popover controller delegates

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // If a popover is dismissed, set the last button tapped to nil.
    //self.lastTappedButton = nil;
}

@end
