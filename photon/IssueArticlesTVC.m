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
    
    //set up splitview managment
    APP_MGR.splitVM.issueArticlesTVC = self;

    
    // Do any additional setup after loading the view, typically from a nib.
    if([APP_MGR isDeviceIpad] == YES)
        self.navigationItem.title = @"MMWR Articles";
    else
        self.navigationItem.title = @"MMWR Express";
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.image = [UIImage imageNamed:@"issue_tab_icon_inactive"];
    item.selectedImage = [UIImage imageNamed:@"issue_tab_icon_active"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ipad_master_navbar"] forBarMetrics:UIBarMetricsDefault];
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
    
    //self.navigationItem.title = _issue.number;
    if ([APP_MGR isDeviceIpad] == NO) {
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        shareButton.width = 30.0;
        self.navigationItem.rightBarButtonItem  = shareButton;
        
    }
    else {
        [self updateArticleSelection];
    }
    
    didViewJustLoad = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //[self updateArticleSelection];
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
    
}

- (void)share:(id)sender
{
    // display the options for sharing
    shareAS = [[ShareActionSheet alloc] initToShareApp:self];
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
    return [NSString stringWithFormat:@"%@                          Vol %@ No %@", [formatter stringFromDate:_issue.date], _issue.volume, _issue.number];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 32.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 4.0f;
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
    CGSize titleTextSize = CGSizeMake(0.0, 0.0);
    
    if (title != nil)
        titleTextSize = [title sizeWithFont:APP_MGR.tableFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return  titleTextSize.height + (2 * CELL_PADDING);
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
    
    cell.imageView.image = [UIImage imageNamed:@"unread_dot"];
    [cell.imageView sizeToFit];
    if (_article.unread) {
        cell.imageView.hidden = NO;
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
    _selectedArticle.unread = NO;
    

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [_issue updateUnreadArticleStatus];


    if ([APP_MGR isDeviceIpad] == YES) {
        
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
    
    }
    else
        [self performSegueWithIdentifier:@"pushContentPageViews" sender:nil];
        
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [APP_MGR.splitVM searchEnd];

    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    NSArray *articles = [_issue.articles allObjects];
    _article = [articles objectAtIndex:[indexPath row]];
    
    KeywordArticleDetailVC *content = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverArticleDetails"];
    content.article = _article;
    content.modalDelegate = self;
    content.popoverViewDelegate = self;

	// Setup the popover for use from the navigation bar.
	self.detailViewPopover = [[UIPopoverController alloc] initWithContentViewController:content];
	self.detailViewPopover.popoverContentSize = CGSizeMake(400., 358.);
	self.detailViewPopover.delegate = self;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    // Present the popover from the button that was tapped in the detail view.
    [self.detailViewPopover presentPopoverFromRect:cell.bounds inView:cell.contentView
                     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    //[self performSegueWithIdentifier:@"pushArticleDetails" sender:nil];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushContentPageViews"]) {
        ContentPagesVC *contentVC = segue.destinationViewController;
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
        fullArticleVC.url = _article.url;
        fullArticleVC.modalDelegate = self;
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
