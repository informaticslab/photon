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

@end
