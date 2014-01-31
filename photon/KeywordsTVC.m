//
//  KeywordsTVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordsTVC.h"
#import "KeywordArticlesTVC.h"
#import "ShareActionSheet.h"

@interface KeywordsTVC ()

@end

@implementation KeywordsTVC

ShareActionSheet *shareAS;


NSArray *searchResults;
NSMutableArray *allKeywords;
NSString *selectedKeyword;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Custom initialization
    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
    item.image = [UIImage imageNamed:@"search_tab_inactive"];
    item.selectedImage = [UIImage imageNamed:@"search_tab_active"];
    allKeywords = [[NSMutableArray alloc] init];
    [allKeywords addObjectsFromArray:[[APP_MGR.issuesMgr.keywords allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1];
    self.navigationItem.title = @"MMWR Express";

    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.style = UIBarButtonItemStyleBordered;
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(feedDataUpdateNotification:)
     name:@"FeedDataUpdated"
     object:nil];
    
    self.isSearching = NO;
    
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
   [self.searchDisplayController initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchDisplayController.delegate = self;
    
    self.searchDisplayController.searchResultsDataSource = self;
    
    self.searchDisplayController.searchResultsDelegate = self;
    
    
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (self.isSearching == YES)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
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
}

-(void)feedDataUpdateNotification:(NSNotification *)pNotification
{
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    self.isSearching = YES;

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    // set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // check for diffs between ios 6 & 7
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)])
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0];
    else {
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0]];
    }
    
    self.navigationController.navigationBar.translucent = NO;
    return;
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.isSearching = NO;


    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
    return;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [searchResults count];

    // Return the number of rows in the section.
    return [APP_MGR.issuesMgr.keywords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KeywordsCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView)
        cell.textLabel.text = searchResults[[indexPath row]];
    else
        cell.textLabel.text = allKeywords[[indexPath row]];
    
    cell.textLabel.font = APP_MGR.tableFont;

    return cell;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    searchResults = [allKeywords filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    // [self.navigationController pushViewController:detailViewController animated:YES];
    if (tableView == self.searchDisplayController.searchResultsTableView)
        selectedKeyword = searchResults[[indexPath row]];
    else
        selectedKeyword = allKeywords[[indexPath row]];
        
    [self performSegueWithIdentifier:@"pushKeywordArticles" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushKeywordArticles"])
    {
        KeywordArticlesTVC *keywordArticlesTVC = segue.destinationViewController;
        keywordArticlesTVC.keyword = selectedKeyword;
    }
}

@end
