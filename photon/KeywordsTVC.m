//
//  KeywordsTVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordsTVC.h"
#import "KeywordArticlesTVC.h"

@interface KeywordsTVC ()

@end

@implementation KeywordsTVC

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
    item.image = [UIImage imageNamed:@"subject_tab_icon_inactive"];
    item.selectedImage = [UIImage imageNamed:@"subject_tab_icon_active"];
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
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help_icon"] style:UIBarButtonItemStyleBordered target:self action:@selector(help:)];
    
    self.navigationItem.rightBarButtonItems  = [NSArray arrayWithObjects:helpButton, shareButton, nil];
    
    
}

- (void)share:(id)sender
{
    
}

- (void)help:(id)sender
{
    
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






/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
