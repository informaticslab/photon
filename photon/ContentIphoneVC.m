//
//  ContentIphoneVC.m
//  photon
//
//  Created by jtq6 on 1/14/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "ContentIphoneVC.h"
#import "ShareActionSheet.h"
#import "InfoVC.h"

@implementation ContentIphoneVC


ShareActionSheet *shareAS;
UIFont *font;

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
    self.navigationItem.title = @"Summary";
    self.navigationItem.accessibilityLabel = @"Summary of Article";
    font = [UIFont fontWithName:@"HelveticaNeue" size:15];

    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ipad_detail_navbar"] forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // check for diffs between ios 6 & 7
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)])
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0];
    else {
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0]];
    }
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = 30.0;
    
    
    self.navigationItem.rightBarButtonItems  = @[shareButton];
    
    [self.txtvKnownText setScrollEnabled:NO];
    [self.txtvKnownText setUserInteractionEnabled:YES];
    self.txtvKnownText.delegate = self;
    self.txtvKnownText.showsVerticalScrollIndicator = YES;
    self.txtvKnownText.text = self.contentText;
    
    [self.txtvAddedText setScrollEnabled:NO];
    [self.txtvAddedText setUserInteractionEnabled:YES];
    self.txtvAddedText.delegate = self;
    self.txtvAddedText.showsVerticalScrollIndicator = YES;
    self.txtvAddedText.text = self.contentText;
    
    [self.txtvImplicationsText setScrollEnabled:NO];
    [self.txtvImplicationsText setUserInteractionEnabled:YES];
    self.txtvImplicationsText.delegate = self;
    self.txtvImplicationsText.showsVerticalScrollIndicator = YES;
    self.txtvImplicationsText.text = self.contentText;
    
   self.summaryScrollView.translatesAutoresizingMaskIntoConstraints  = NO;

    self.parentViewController.navigationItem.title = self.navbarTitle;
    
    // Setup the popover for use from the navigation bar.
//    InfoVC *content = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPopoverVC"];
//
//	self.infoPopoverController = [[UIPopoverController alloc] initWithContentViewController:content];
//	self.infoPopoverController.popoverContentSize = CGSizeMake(400., 540.);
//	self.infoPopoverController.delegate = self;
//    content.popoverViewDelegate = self;

    [self selectedArticle:self.article];
    
    
    if ([APP_MGR isSummaryDefaultArticleView] == YES) {
        self.segCtrlArticleView.selectedSegmentIndex = 1;
        [self selectSummaryView];
    } else {
        self.segCtrlArticleView.selectedSegmentIndex = 0;
        [self selectFullArticleView];

    }
}

-(void)viewDidLayoutSubviews {
    
    CGSize sizeThatFitsTextView = [self.txtvKnownText sizeThatFits:CGSizeMake(self.txtvKnownText.frame.size.width, MAXFLOAT)];
    self.txtvKnownTextHeightConstraint.constant = sizeThatFitsTextView.height + 10;

    sizeThatFitsTextView = [self.txtvAddedText sizeThatFits:CGSizeMake(self.txtvAddedText.frame.size.width, MAXFLOAT)];
    self.txtvAddedTextHeightConstraint.constant = sizeThatFitsTextView.height + 10;

    sizeThatFitsTextView = [self.txtvImplicationsText sizeThatFits:CGSizeMake(self.txtvImplicationsText.frame.size.width, MAXFLOAT)];
    self.txtvImplicationsTextHeightConstraint.constant = sizeThatFitsTextView.height + 10;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedFullArticleIphoneView"]) {
        self.childFullArticleVC = (FullArticleVC *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"embedSummaryIphoneView"]) {
        self.childSummaryIphoneVC = (SummaryIphoneVC *) [segue destinationViewController];
    }
}


-(void)flashScrollingIndicators
{
    
    [self.summaryScrollView flashScrollIndicators];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self flashScrollingIndicators];
//    CGSize containerSize = self.containerView.frame.size;
//    CGSize scrollContentSize = CGSizeMake(containerSize.width, containerSize.height + 60.0);
//    self.summaryScrollView.contentSize = scrollContentSize;
    
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


-(void)didTouchReadUserAgreementButton
{
    
    // dismiss popover
    //[self.infoPopoverController dismissPopoverAnimated:YES];
    [self presentEulaModalView];
    
    
}

-(void)selectSummaryView
{
    self.fullArticleContainer.hidden = YES;
    self.summaryScrollView.hidden = NO;
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SUMMARY inSection:SC_SECTION_ARTICLE];
    
}


-(void)selectFullArticleView
{
    self.fullArticleContainer.hidden = NO;
    self.summaryScrollView.hidden = YES;
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_FULL inSection:SC_SECTION_ARTICLE];
    
    
}


- (IBAction)segCtrlFullSummary:(id)sender {
    
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    
    if (segCtrl.selectedSegmentIndex == 0) {
        [self selectFullArticleView];
    } else if (segCtrl.selectedSegmentIndex == 1) {
        [self selectSummaryView];
    }
    
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

-(void)setKnownText:(NSString *)text
{
    
    self.txtvKnownText.text = text;
    self.txtvKnownText.font = font;
    self.txtvKnownText.textContainerInset = UIEdgeInsetsMake(3,3,3,3);
    
}

-(void)setAddedText:(NSString *)text
{
    
    self.txtvAddedText.text = text;
    self.txtvAddedText.font = font;
    self.txtvAddedText.textContainerInset = UIEdgeInsetsMake(3,3,3,3);
    
}


-(void)setImplicationsText:(NSString *)text
{
    
    self.txtvImplicationsText.text = text;
    self.txtvImplicationsText.font = font;
    self.txtvImplicationsText.textContainerInset = UIEdgeInsetsMake(3,3,3,3);

}



-(void)selectedArticle:(ArticleMO *)selArticle
{
    
    if (selArticle == nil)
        return;

    DebugLog(@"Article title is %@", self.article.title);
    

    _article = selArticle;
    
    [self.childFullArticleVC loadUrl:_article.url];

    [self setKnownText:_article.already_known];
    [self setAddedText:_article.added_by_report];
    [self setImplicationsText:_article.implications];
    
    self.navigationItem.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", @"Summary of Article with title ", self.article.title];
    
    // track page
//    if (self.segCtrlArticleView.selectedSegmentIndex == 0) {
//        [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_FULL inSection:SC_SECTION_SUMMARY];
//        
//    } else {
//        [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SUMMARY inSection:SC_SECTION_SUMMARY];
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
