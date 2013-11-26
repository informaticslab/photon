//
//  TopicImplicationsVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "TopicImplicationsVC.h"

@interface TopicImplicationsVC ()

@end

@implementation TopicImplicationsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _txtView.text = _article.implications;
    _txtView.font = APP_MGR.textFont;

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
//    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, 700)];

    
    
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
