//
//  IssueArticlesTVC.m
//  photon
//
//  Created by jtq6 on 11/7/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "IssueArticlesTVC.h"
#import "ArticleDetails.h"
#import "TopicsTVC.h"
#import "ShareActivityVC.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = _issue.number;
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = 30.0;
    self.navigationItem.rightBarButtonItem  = shareButton;

}

- (void)share:(id)sender
{
    // display the options for sharing
    ShareActivityVC *shareVC = [[ShareActivityVC alloc] initToShareApp];
    [self presentViewController:shareVC animated:YES completion:nil];
   
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
    // return the number of rows in the section.
    return [_issue.articles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *rowArticle = _issue.articles[[indexPath row]];
    NSString *title = rowArticle.title;

    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    CGSize titleTextSize = CGSizeMake(0.0, 0.0);
    
    if (title != nil)
        titleTextSize = [title sizeWithFont:APP_MGR.tableFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return  titleTextSize.height + (2 * CELL_PADDING);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueArticlesCell" forIndexPath:indexPath];
    
    // configure the cell...
    Article *rowArticle = _issue.articles[[indexPath row]];

    cell.textLabel.font = APP_MGR.tableFont;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.textLabel.text = rowArticle.title;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.imageView.image = [UIImage imageNamed:@"unread_blue_dot"];
    [cell.imageView sizeToFit];
    if (rowArticle.unread) {
        cell.imageView.hidden = NO;
    } else {
        cell.imageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    currArticle = _issue.articles[[indexPath row]];
    currArticle.unread = NO;
    [self.issue updateUnreadArticleStatus];
    [self.tableView reloadData];
    [self performSegueWithIdentifier:@"pushTopics" sender:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushTopics"])
    {
        TopicsTVC *topicsVC = segue.destinationViewController;
        topicsVC.article = currArticle;
        topicsVC.issue = _issue;
        
    }
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
