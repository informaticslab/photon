//
//  TopicsTVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "TopicsTVC.h"
#import "TopicKnownVC.h"
#import "TopicAddedVC.h"
#import "TopicImplicationsVC.h"

@interface TopicsTVC ()

@end

@implementation TopicsTVC

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
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = -1.0;
    
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(help:)];
    helpButton.width = -1.0;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushTopicKnown"])
    {
        TopicKnownVC *topicKnownVC = segue.destinationViewController;
        topicKnownVC.article = _article;
        topicKnownVC.issue = _issue;
        
    }
    
    else if([segue.identifier isEqualToString:@"pushTopicAdded"])
    {
        TopicAddedVC *topicAddedVC = segue.destinationViewController;
        topicAddedVC.article = _article;
        topicAddedVC.issue = _issue;
        
    }
    
    else if([segue.identifier isEqualToString:@"pushTopicImplications"])
    {
        TopicImplicationsVC *topicImplicationsVC = segue.destinationViewController;
        topicImplicationsVC.article = _article;
        topicImplicationsVC.issue = _issue;
        
    }
}



@end
