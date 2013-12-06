//
//  FullArticleVC.m
//  photon
//
//  Created by jtq6 on 11/26/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "FullArticleVC.h"

@interface FullArticleVC ()

@end

@implementation FullArticleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
