//
//  FirstViewController.m
//  photon
//
//  Created by jtq6 on 11/1/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "IssuesViewController.h"
#import "IssueArticlesTVC.h"
#import "Issue.h"
#import "ShareActionSheet.h"

@interface IssuesViewController ()

@end

ShareActionSheet *shareAS;


NSMutableArray *issues;
Issue *currIssue;
#define CELL_TEXT_LABEL_WIDTH 230.0
#define CELL_PADDING 20.0

@implementation IssuesViewController

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
        //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0]];
    }
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = shareButton;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)refresh:(id)sender
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Issue *cellIssue = APP_MGR.issuesMgr.issues[[indexPath row]];
    
    NSString *title = cellIssue.title;
    
    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    CGSize titleTextSize = CGSizeMake(0.0, 0.0);
    
    if (title != nil)
    titleTextSize = [title sizeWithFont:APP_MGR.tableFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return  titleTextSize.height + (2 * CELL_PADDING);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [APP_MGR.issuesMgr.issues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IssueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSInteger index = [indexPath row];
    //    UILabel *descLabel = (UILabel *)[cell.contentView viewWithTag:1];
    
    Issue *cellIssue = APP_MGR.issuesMgr.issues[index];
    cell.textLabel.font = APP_MGR.tableFont;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = cellIssue.title;
    
    //descLabel.text = cellIssue.title;
    
    cell.imageView.image = [UIImage imageNamed:@"unread_blue_dot"];
    [cell.imageView sizeToFit];
    if (cellIssue.unread) {
        cell.imageView.hidden = NO;
    } else {
        cell.imageView.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    // [self.navigationController pushViewController:detailViewController animated:YES];
    currIssue = APP_MGR.issuesMgr.issues[[indexPath row]];
    [currIssue updateUnreadArticleStatus];
    [self.tableView reloadData];
    [self performSegueWithIdentifier:@"pushIssueArticles" sender:nil];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"pushIssueArticles"])
    {
        IssueArticlesTVC *issueArticlesTVC = segue.destinationViewController;
        issueArticlesTVC.issue = currIssue;
    }
    
}


- (void)share:(id)sender
{
    // display the options for sharing
    shareAS = [[ShareActionSheet alloc] initToShareApp:self];
    [shareAS showView];
}


@end
