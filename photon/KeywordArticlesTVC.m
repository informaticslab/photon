//
//  KeywordArticlesTVC.m
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordArticlesTVC.h"
#import "KeywordArticleDetailVC.h"
#import "ArticleDetails.h"
#import "ShareActionSheet.h"
#import "ContentPagesVC.h"

#define CELL_TEXT_LABEL_WIDTH 230.0
#define CELL_PADDING 10.0



@implementation KeywordArticlesTVC

ShareActionSheet *shareAS;
BOOL isArticleSelected;


NSArray *keywordArticles;

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
    APP_MGR.splitVM.keywordArticlesTVC = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = _keyword;
    keywordArticles = [APP_MGR.issuesMgr articlesWithKeyword:_keyword];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = 30.0;
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [APP_MGR.splitVM searchStart];
    if (isArticleSelected == NO) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
        _selectedArticle = _issue.articles[[indexPath row]];
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        [APP_MGR.splitVM searchEnd];

    }

    
}



- (void)share:(id)sender
{
    // display the options for sharing
    shareAS = [[ShareActionSheet alloc] initToShareApp:self];
    [shareAS showView];
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
    // Return the number of rows in the section.
    return [keywordArticles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *rowArticle = keywordArticles[[indexPath row]];
    NSString *title = rowArticle.title;
    
    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    CGSize titleTextSize = CGSizeMake(0.0, 0.0);
    
    if (title != nil)
        titleTextSize = [title sizeWithFont:APP_MGR.tableFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return  titleTextSize.height + (2 * CELL_PADDING);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KeywordArticlesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure the cell...
    Article *rowArticle = keywordArticles[[indexPath row]];
    
    cell.textLabel.font = APP_MGR.tableFont;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text = rowArticle.title;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    _selectedArticle = keywordArticles[[indexPath row]];
    isArticleSelected = YES;

    
    if ([APP_MGR isDeviceIpad] == YES) {
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        [APP_MGR.splitVM searchEnd];
    }
    else
        [self performSegueWithIdentifier:@"pushContentPagesFromKeyword" sender:nil];
    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    _selectedArticle = keywordArticles[[indexPath row]];
    [self performSegueWithIdentifier:@"pushKeywordArticleDetails" sender:nil];
    
}

#pragma mark - Modal Views


- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"pushKeywordArticleDetails"])
    {
        KeywordArticleDetailVC *keywordArticleDetailVC = segue.destinationViewController;
        keywordArticleDetailVC.article = _selectedArticle;
        if ([APP_MGR isDeviceIpad] == YES) {
            keywordArticleDetailVC.modalDelegate = self;
        }

    } else if ([segue.identifier isEqualToString:@"pushContentPagesFromKeyword"]) {
        ContentPagesVC *contentVC = segue.destinationViewController;
        contentVC.article = _selectedArticle;
        contentVC.issue = _selectedArticle.issue;
    }
}


@end
