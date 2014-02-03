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
#import "KeywordArticleDetailVC.h"

ShareActionSheet *shareAS;
Issue *currIssue;
Article *currArticle;

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

    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"MMWR Express";
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:0];
    item.image = [UIImage imageNamed:@"issue_tab_icon_inactive"];
    item.selectedImage = [UIImage imageNamed:@"issue_tab_icon_active"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = 30.0;
    self.navigationItem.rightBarButtonItem  = shareButton;

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
    //    [self.tableView reloadData];
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
    return [APP_MGR.issuesMgr.issues count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of rows in the section.
    currIssue = [APP_MGR.issuesMgr getSortedIssueForIndex:section];

    return [currIssue.articles count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    currIssue = [APP_MGR.issuesMgr getSortedIssueForIndex:section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMM dd, yyyy";
    return [NSString stringWithFormat:@"%@                          Vol %d No %d", [formatter stringFromDate:currIssue.date], currIssue.volume, currIssue.number];
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
    currIssue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];

    currArticle = currIssue.articles[[indexPath row]];
    NSString *title = currArticle.title;

    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    CGSize titleTextSize = CGSizeMake(0.0, 0.0);
    
    if (title != nil)
        titleTextSize = [title sizeWithFont:APP_MGR.tableFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return  titleTextSize.height + (2 * CELL_PADDING);
}


-(void)myAction:(id)sender
{
    
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
    currIssue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    currArticle = currIssue.articles[[indexPath row]];
    
    cell.textLabel.font = APP_MGR.tableFont;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text = currArticle.title;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.imageView.image = [UIImage imageNamed:@"unread_blue_dot"];
    [cell.imageView sizeToFit];
    if (currArticle.unread) {
        cell.imageView.hidden = NO;
    } else {
        cell.imageView.hidden = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Navigation logic may go here. Create and push another view controller.
    currIssue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    currArticle = currIssue.articles[[indexPath row]];
    currArticle.unread = NO;

    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.issue updateUnreadArticleStatus];
    [self performSegueWithIdentifier:@"pushContentPageViews" sender:nil];
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    currIssue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
    currArticle = currIssue.articles[[indexPath row]];
    [self performSegueWithIdentifier:@"pushArticleDetails" sender:nil];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushContentPageViews"]) {
        ContentPagesVC *contentVC = segue.destinationViewController;
        contentVC.article = currArticle;
        contentVC.issue = currIssue;
        
    } else if([segue.identifier isEqualToString:@"pushArticleDetails"]) {
        KeywordArticleDetailVC *keywordArticleDetailVC = segue.destinationViewController;
        keywordArticleDetailVC.article = currArticle;
    }

}


-(void)feedDataUpdateNotification:(NSNotification *)pNotification
{
    // NSLog(@"Received notification in CondomUsageRiskChart = %@",(NSString*)[pNotification object]);
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

}




@end
