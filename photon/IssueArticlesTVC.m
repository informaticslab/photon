//
//  IssueArticlesTVC.m
//  photon
//
//  Created by jtq6 on 11/7/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "IssueArticlesTVC.h"
#import "ArticleDetails.h"
#import "ShareActionSheet.h"
#import "ContentPagesVC.h"
#import "ContentPagesiPadVC.h"
#import "ContentIphoneVC.h"
#import "KeywordArticleDetailVC.h"
#import "FullArticleVC.h"

#import "AppDelegate.h"

#define CELL_TEXT_LABEL_WIDTH 230.0
#define CELL_PADDING 10.0

@interface ArticleCell : UITableViewCell {}
@end
@implementation ArticleCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0,0,32,32);
    //self.imageView.bounds
}
@end

@implementation IssueArticlesTVC

ShareActionSheet *shareAS;
bool didViewJustLoad;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (APP_MGR.agreedWithEula == FALSE) {
        [self presentEulaModalView];
    }
    
    
    //set up splitview managment
    APP_MGR.splitVM.issueArticlesTVC = self;
    
    
    // Do any additional setup after loading the view, typically from a nib.
    if([APP_MGR isDeviceIpad] == YES)
        self.navigationItem.title = @"MMWR Articles";
    else
        self.navigationItem.title = @"MMWR Express";
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.accessibilityLabel =  @"List of MMWR Articles";
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.image = [UIImage imageNamed:@"issue_tab_icon_inactive"];
    item.selectedImage = [UIImage imageNamed:@"issue_tab_icon_active"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ipad_master_navbar"] forBarMetrics:UIBarMetricsDefault];
    if ([APP_MGR isDeviceIpad] == NO) {
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        shareButton.width = 30.0;
        shareButton.accessibilityHint = @"Double tap to open share view to share the app with others.";
        shareButton.accessibilityLabel = @"Share";
        self.navigationItem.rightBarButtonItem  = shareButton;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        
    }
    //[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName ]];
    
    // check for diffs between ios 6 & 7
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)])
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0];
    else {
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0]];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(feedDataUpdateNotification:)
     name:@"FeedDataUpdated"
     object:nil];
    
    if ([APP_MGR isDeviceIpad] == YES) {
        [self updateArticleSelection];
    }
    
    didViewJustLoad = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    if (didViewJustLoad == YES) {
        didViewJustLoad = NO;
    } else {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        if (indexPath) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
        }
    }
    
    [APP_MGR.usageTracker trackNavigationEvent:SC_SECTION_ARTICLES inSection:SC_PAGE_TITLE_LIST];

    
}


- (void)presentEulaModalView
{
    static BOOL alwaysShowEula = FALSE;
    
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


- (void)share:(id)sender
{
    // display the options for sharing
    if (APP_MGR.isDeviceIpad)
        shareAS = [[ShareActionSheet alloc] initToShareArticleUrl:self.selectedArticle.url fromVC:self];
    else
        shareAS = [[ShareActionSheet alloc] initToShareArticleUrl:nil fromVC:self];
    [shareAS showView];
    
}

- (IBAction)refresh:(id)sender
{
    UIRefreshControl *refreshControl = (UIRefreshControl *)sender;
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating articles..."];
    
    [APP_MGR.jsonParser updateFromFeed];
    //[self.tableView reloadData];
    //[self.refreshControl endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [APP_MGR.issuesMgr.sortedIssues count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of rows in the section.
    _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:section];
    
    return [_issue.articles count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy";
    return [NSString stringWithFormat:@"%@   --   Vol %@ No %@", [formatter stringFromDate:_issue.date], _issue.volume, _issue.number];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 36.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // orange is 253, 242, 213 blue is 234, 240, 248
    header.contentView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:240.0/255.0 blue:248.0/255.0 alpha:1];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    NSArray *articles = [_issue.articles allObjects];
    
    _article = [articles objectAtIndex:[indexPath row]];
    NSString *title = _article.title;
    
    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    
    CGRect textRect = [title boundingRectWithSize:constraintSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:APP_MGR.tableFont}
                                          context:nil];
    
    return  textRect.size.height + (2 * CELL_PADDING);

}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
    return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueArticlesCell" forIndexPath:indexPath];
    
    // configure the cell...
    _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    NSArray *articles = [_issue.articles allObjects];
    _article = [articles objectAtIndex:[indexPath row]];
    
    cell.textLabel.font = APP_MGR.tableFont;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text = _article.title;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.isAccessibilityElement = YES;
    cell.accessoryView.isAccessibilityElement = YES;
    cell.textLabel.accessibilityHint = @"Double tap to display content in summary view";
    cell.textLabel.accessibilityTraits = UIAccessibilityTraitButton;
    cell.accessoryView.accessibilityHint = @"Double tap to get more info about the article.";
    cell.accessoryView.accessibilityLabel = @"More Info.";
    cell.accessoryView.accessibilityTraits = UIAccessibilityTraitButton;
    
    cell.imageView.image = [UIImage imageNamed:@"unread_dot"];
    [cell.imageView sizeToFit];
    if (_article.unread) {
        cell.imageView.hidden = NO;
        cell.imageView.isAccessibilityElement = YES;
        cell.imageView.accessibilityTraits = UIAccessibilityTraitImage;
        cell.imageView.accessibilityLabel = @"Unread article blue dot";
    } else {
        cell.imageView.hidden = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    NSArray *articles = [_issue.articles allObjects];
    _selectedArticle = [articles objectAtIndex:[indexPath row]];
    _selectedArticle.unread = 0;
    
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [_issue updateUnreadArticleStatus];
    
    
    if ([APP_MGR isDeviceIpad] == YES) {
        
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        
    }
    else
        //[self performSegueWithIdentifier:@"pushContentPageViews" sender:nil];
        [self performSegueWithIdentifier:@"pushContentIphoneView" sender:nil];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [APP_MGR.splitVM searchEnd];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushContentPageViews"]) {
        ContentPagesVC *contentVC = segue.destinationViewController;
        contentVC.article = _article;
        contentVC.issue = _issue;
    }
    else if([segue.identifier isEqualToString:@"pushContentIphoneView"]) {
        ContentIphoneVC *contentVC = segue.destinationViewController;
        contentVC.article = _article;
        contentVC.issue = _issue;

        
    }
    else if([segue.identifier isEqualToString:@"pushContentPageIpadViews"]) {
        ContentIpadVC *contentVC = segue.destinationViewController;
        contentVC.article = _article;
        contentVC.issue = _issue;
        
    }
    else if([segue.identifier isEqualToString:@"pushArticleDetails"]) {
        KeywordArticleDetailVC *keywordArticleDetailVC = segue.destinationViewController;
        keywordArticleDetailVC.article = _article;
        if ([APP_MGR isDeviceIpad] == YES) {
            keywordArticleDetailVC.modalDelegate = self;
        }
    }
    else if([segue.identifier isEqualToString:@"modalFullArticle"]) {
        FullArticleVC *fullArticleVC = segue.destinationViewController;
        //fullArticleVC.url = _article.url;
    }
    
}


- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)didClickDoneButton;
{
    
    // dismiss popover
    [self.detailViewPopover dismissPopoverAnimated:YES];
    
}

-(void)didClickFullArticleButton
{
    
    // dismiss popover
    [self.detailViewPopover dismissPopoverAnimated:YES];
    [self performSegueWithIdentifier:@"modalFullArticle" sender:nil];
    
    
}

-(void)updateArticleSelection
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    // select first row if device is iPad
    if ([APP_MGR isDeviceIpad] == YES) {
        if ([APP_MGR.issuesMgr.sortedIssues count] != 0) {
            
            if (_selectedArticle == nil) {
                
                //NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
                if (_issue != nil) {
                    NSArray *articles = [_issue.articles allObjects];
                    _selectedArticle = [articles objectAtIndex:[indexPath row]];
                }
            }
        }
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        [APP_MGR.splitVM searchEnd];
    }
    
}


-(void)feedDataUpdateNotification:(NSNotification *)pNotification
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [self updateArticleSelection];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	// If a popover is dismissed, set the last button tapped to nil.
	//self.lastTappedButton = nil;
    [self.detailViewPopover dismissPopoverAnimated:YES];
    
}






@end
