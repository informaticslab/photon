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
#import <Social/Social.h>
#import "ShareActivityProvider.h"
#import "ShareActivityVC.h"

@interface IssuesViewController ()

@end

NSMutableArray *issues;
Issue *currIssue;

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
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1];
    
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
    cell.textLabel.text = cellIssue.title;
    //descLabel.text = cellIssue.title;
    
    if (cellIssue.unread) {
        cell.imageView.image = [UIImage imageNamed:@"unread_blue_dot"];
        [cell.imageView sizeToFit];        
    } else {
        cell.imageView.image = nil;
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
    ShareActivityVC *shareVC = [[ShareActivityVC alloc] init];
    [self presentViewController:shareVC animated:YES completion:nil];
    
}



@end
