//
//  TopicAddedVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "TopicAddedVC.h"

@interface TopicAddedVC ()

@end

@implementation TopicAddedVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _txtView.text = _article.added_by_report;
    _txtView.font = APP_MGR.textFont;

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
}

- (void)viewDidLayoutSubviews
{
    _txtView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.txtView sizeToFit];
    [_txtView setTextContainerInset:UIEdgeInsetsMake(10, 20, 10, 20)];
    
}


- (void)share:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
