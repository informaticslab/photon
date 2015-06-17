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
#import "FullArticleVC.h"

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
    
    self.navigationItem.title = _keyword.text;
    self.navigationItem.accessibilityLabel =  [NSString stringWithFormat:@"%@ %@",@"List of articles containing search term", _keyword.text ];

    keywordArticles = [APP_MGR.issuesMgr articlesWithKeyword:_keyword];
    
    if([APP_MGR isDeviceIpad] == NO) {

        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        shareButton.width = 30.0;
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //[self updateArticleSelection];
//    if (_selectedArticle == nil) {
//        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//        _issue = [APP_MGR.issuesMgr getSortedIssueForIndex:[indexPath section]];
//        _selectedArticle = _issue.articles[[indexPath row]];
//
//    }
//
//    [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
//    [APP_MGR.splitVM searchEnd];
//    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SEARCH_KEYWORD_ARTICLES inSection:SC_SECTION_SEARCH];

}

-(void)updateArticleSelection
{
    
    // select first row if device is iPad
    if ([APP_MGR isDeviceIpad] == YES) {
        if ([APP_MGR.issuesMgr.issues count] != 0) {
            
            if (_selectedArticle == nil) {
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                _selectedArticle = keywordArticles[[indexPath row]];
                if (_selectedArticle != nil) {
                    isArticleSelected = YES;
                }
            }
        }
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        [APP_MGR.splitVM searchEnd];

    }
    
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



- (void)share:(id)sender
{
    // display the options for sharing
    shareAS = [[ShareActionSheet alloc] initToShareArticleUrl:self.selectedArticle.url fromVC:self];
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
    CGRect textRect = [title boundingRectWithSize:constraintSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:APP_MGR.tableFont}
                                         context:nil];
    
    return  textRect.size.height + (2 * CELL_PADDING);
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KeywordArticlesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // configure the cell...
    ArticleMO *rowArticle = keywordArticles[[indexPath row]];
    
    // main content of cell
    cell.textLabel.font = APP_MGR.tableFont;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text = rowArticle.title;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.isAccessibilityElement = YES;
    cell.textLabel.accessibilityHint = @"Double tap to display content in summary view";
    cell.textLabel.accessibilityTraits = UIAccessibilityTraitButton;

    // accessory view of cell
    cell.accessoryView.isAccessibilityElement = YES;
    cell.accessoryView.accessibilityHint = @"Double tap to get more info about the article.";
    cell.accessoryView.accessibilityLabel = @"More Info.";
    cell.accessoryView.accessibilityTraits = UIAccessibilityTraitButton;

    
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

    _selectedArticle.unread = 0;
    IssueMO *selectedArticleIssue = _selectedArticle.issue;
    [selectedArticleIssue updateUnreadArticleStatus];
    
    [_issue updateUnreadArticleStatus];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"FeedDataUpdated"
     object:self];


    if ([APP_MGR isDeviceIpad] == YES) {
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        [APP_MGR.splitVM searchEnd];
    }
    else
        [self performSegueWithIdentifier:@"pushContentPagesFromKeyword" sender:nil];
    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    ArticleMO *rowArticle = keywordArticles[[indexPath row]];
    _selectedArticle = rowArticle;
    
    if ([APP_MGR isDeviceIpad] == YES) {
        

    
    KeywordArticleDetailVC *content = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverArticleDetails"];
    content.article = rowArticle;
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

    } else {
        [self performSegueWithIdentifier:@"pushKeywordArticleDetails" sender:nil];

        
    }
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
    } else if([segue.identifier isEqualToString:@"modalFullArticle"]) {
        FullArticleVC *fullArticleVC = segue.destinationViewController;
        fullArticleVC.url = _selectedArticle.url;
        fullArticleVC.modalDelegate = self;
    }

}


@end
