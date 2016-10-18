//
//  KeywordArticlesTVC.m
//  photon
//
//  Created by jtq6 on 11/19/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordArticlesTVC.h"
#import "ArticleDetails.h"
#import "ShareActionSheet.h"
#import "ContentPagesVC.h"
#import "FullArticleVC.h"
#import "ContentIphoneVC.h"

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
    self.navigationItem.backBarButtonItem = nil;

    
    keywordArticles = [APP_MGR.issuesMgr articlesWithKeyword:_keyword];
    
    if([APP_MGR isDeviceIpad] == NO) {
        
        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
        shareButton.width = 30.0;
        self.navigationItem.rightBarButtonItem = shareButton;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    FeedArticle *rowArticle = keywordArticles[[indexPath row]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    _selectedArticle = keywordArticles[[indexPath row]];
    isArticleSelected = YES;
    
    _selectedArticle.unread = 0;
    IssueMO *selectedArticleIssue = _selectedArticle.issue;
    [selectedArticleIssue updateUnreadArticleStatus];
    
    [_issue updateUnreadArticleStatus];
    
    if ([APP_MGR isDeviceIpad] == YES) {
        [APP_MGR.splitVM setSelectedArticle:_selectedArticle];
        [APP_MGR.splitVM searchEnd];
    }
    else
        [self performSegueWithIdentifier:@"pushKeywordContentIphoneView" sender:nil];
    
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
    if([segue.identifier isEqualToString:@"pushKeywordContentIphoneView"]) {
        ContentIphoneVC *contentVC = segue.destinationViewController;
        contentVC.article = _selectedArticle;
        contentVC.issue = _issue;
    }
}


@end
