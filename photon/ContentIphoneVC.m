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
    
    self.grayedOutContentView.hidden = YES;
    self.fullArticleContentView.hidden = NO;
    
    
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Summary";
    self.navigationItem.accessibilityLabel = @"Summary of Article";
    
    
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
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.accessibilityHint = @"Double tap to access information about MMWR Express.";
    infoButton.accessibilityLabel = @"MMWR Express Info";

    
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setLeftBarButtonItem:modalButton animated:YES];
    
    
    self.navigationItem.rightBarButtonItems  = @[shareButton, modalButton];
    
    [self.childSummaryIphoneVC.txtvKnownText setScrollEnabled:YES];
    [self.childSummaryIphoneVC.txtvKnownText setUserInteractionEnabled:YES];
    self.childSummaryIphoneVC.txtvKnownText.delegate = self;
    self.childSummaryIphoneVC.txtvKnownText.showsVerticalScrollIndicator = YES;
    self.childSummaryIphoneVC.txtvKnownText.text = self.contentText;
    
    [self.childSummaryIphoneVC.txtvAddedText setScrollEnabled:YES];
    [self.childSummaryIphoneVC.txtvAddedText setUserInteractionEnabled:YES];
    self.childSummaryIphoneVC.txtvAddedText.delegate = self;
    self.childSummaryIphoneVC.txtvAddedText.showsVerticalScrollIndicator = YES;
    self.childSummaryIphoneVC.txtvAddedText.text = self.contentText;
    
    [self.childSummaryIphoneVC.txtvImplicationsText setScrollEnabled:YES];
    [self.childSummaryIphoneVC.txtvImplicationsText setUserInteractionEnabled:YES];
    self.childSummaryIphoneVC.txtvImplicationsText.delegate = self;
    self.childSummaryIphoneVC.txtvImplicationsText.showsVerticalScrollIndicator = YES;
    self.childSummaryIphoneVC.txtvImplicationsText.text = self.contentText;
    
    [self.childSummaryIphoneVC.txtvArticleTitle setScrollEnabled:YES];
    [self.childSummaryIphoneVC.txtvArticleTitle setUserInteractionEnabled:YES];
    self.childSummaryIphoneVC.txtvArticleTitle.delegate = self;
    self.childSummaryIphoneVC.txtvArticleTitle.showsVerticalScrollIndicator = YES;
    self.childSummaryIphoneVC.txtvArticleTitle.text = self.contentText;
    

    self.parentViewController.navigationItem.title = self.navbarTitle;
    
    // Setup the popover for use from the navigation bar.
//    InfoVC *content = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPopoverVC"];
//
//	self.infoPopoverController = [[UIPopoverController alloc] initWithContentViewController:content];
//	self.infoPopoverController.popoverContentSize = CGSizeMake(400., 540.);
//	self.infoPopoverController.delegate = self;
//    content.popoverViewDelegate = self;

    [self selectedArticle:self.article];
    
    self.scrollView.contentSize = self.containerView.frame.size;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"embedFullArticleView"]) {
        self.childFullArticleVC = (FullArticleVC *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"embedSummaryIphoneView"]) {
        self.childSummaryIphoneVC = (SummaryIphoneVC *) [segue destinationViewController];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
   
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
	//[self.infoPopoverController presentPopoverFromRect:tappedButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	// Set the last button tapped to the current button that was tapped.
	//self.lastTappedButton = sender;
}

-(void)didTouchReadUserAgreementButton
{
    
    // dismiss popover
    //[self.infoPopoverController dismissPopoverAnimated:YES];
    [self presentEulaModalView];
    
    
}

- (IBAction)segCtrlFullSummary:(id)sender {
    
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    
    if (segCtrl.selectedSegmentIndex == 0) {
        self.fullArticleContentView.hidden = NO;
    } else if (segCtrl.selectedSegmentIndex == 1) {
        self.fullArticleContentView.hidden = YES;
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
    if (selArticle == nil)
        return;

    DebugLog(@"Article title is %@", self.article.title);
    

    _article = selArticle;
    
    [self.childFullArticleVC loadUrl:_article.url];

    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.childSummaryIphoneVC.txtvKnownText.text = _article.already_known;
    self.childSummaryIphoneVC.txtvKnownText.font = font;
    self.childSummaryIphoneVC.txtvKnownText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);

    
    self.childSummaryIphoneVC.txtvAddedText.text = _article.added_by_report;
    self.childSummaryIphoneVC.txtvAddedText.font = font;
    self.childSummaryIphoneVC.txtvAddedText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    
    self.childSummaryIphoneVC.txtvImplicationsText.text = _article.implications;
    self.childSummaryIphoneVC.txtvImplicationsText.font = font;
    self.childSummaryIphoneVC.txtvImplicationsText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    
    self.childSummaryIphoneVC.txtvArticleTitle.text = _article.title;
    self.childSummaryIphoneVC.txtvArticleTitle.font = APP_MGR.tableFont;
    self.childSummaryIphoneVC.txtvArticleTitle.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", @"Summary of Article with title ", self.article.title];
    
    // track page
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SUMMARY inSection:SC_SECTION_SUMMARY];


    
    
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


#pragma mark - Popover controller delegates

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // If a popover is dismissed, set the last button tapped to nil.
    //self.lastTappedButton = nil;
}

@end
