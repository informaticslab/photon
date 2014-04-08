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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    APP_MGR.splitVM.contentIpadVC = self;
    [APP_MGR.splitVM setArticleSelectionDelegate:self];
    self.grayedOutContentView.hidden = YES;
    
    
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
    
    
    
    [self.txtvKnownText setScrollEnabled:YES];
    [self.txtvKnownText setUserInteractionEnabled:YES];
    self.txtvKnownText.delegate = self;
    self.txtvKnownText.showsVerticalScrollIndicator = YES;
    self.txtvKnownText.text = self.contentText;
    
    [self.txtvAddedText setScrollEnabled:YES];
    [self.txtvAddedText setUserInteractionEnabled:YES];
    self.txtvAddedText.delegate = self;
    self.txtvAddedText.showsVerticalScrollIndicator = YES;
    self.txtvAddedText.text = self.contentText;
    
    [self.txtvImplicationsText setScrollEnabled:YES];
    [self.txtvImplicationsText setUserInteractionEnabled:YES];
    self.txtvImplicationsText.delegate = self;
    self.txtvImplicationsText.showsVerticalScrollIndicator = YES;
    self.txtvImplicationsText.text = self.contentText;
    
    [self.txtvArticleTitle setScrollEnabled:YES];
    [self.txtvArticleTitle setUserInteractionEnabled:YES];
    self.txtvArticleTitle.delegate = self;
    self.txtvArticleTitle.showsVerticalScrollIndicator = YES;
    self.txtvArticleTitle.text = self.contentText;
    

    self.parentViewController.navigationItem.title = self.navbarTitle;
    
    // Setup the popover for use from the navigation bar.
    InfoVC *content = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPopoverVC"];

	self.infoPopoverController = [[UIPopoverController alloc] initWithContentViewController:content];
	self.infoPopoverController.popoverContentSize = CGSizeMake(400., 540.);
	self.infoPopoverController.delegate = self;
    content.popoverViewDelegate = self;

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self selectedArticle:[APP_MGR.splitVM getSelectedArticle]];
    
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
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    _article = selArticle;
    
    self.txtvKnownText.text = _article.already_known;
    self.txtvKnownText.font = font;
    self.txtvKnownText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);

    
    self.txtvAddedText.text = _article.added_by_report;
    self.txtvAddedText.font = font;
    self.txtvAddedText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    
    self.txtvImplicationsText.text = _article.implications;
    self.txtvImplicationsText.font = font;
    self.txtvImplicationsText.textContainerInset = UIEdgeInsetsMake(5,5,5,5);
    
    self.txtvArticleTitle.text = _article.title;
    self.txtvArticleTitle.font = APP_MGR.tableFont;
    self.txtvArticleTitle.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", @"Summary of Article with title ", self.article.title];

    
    
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
