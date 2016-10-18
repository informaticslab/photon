//
//  FullArticleVC.m
//  photon
//
//  Created by jtq6 on 11/26/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "FullArticleVC.h"
#import "WPSAlertController.h"

@implementation FullArticleVC



- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.webView.delegate = self;
    _spinner.hidesWhenStopped = YES;

}

-(void)viewDidAppear:(BOOL)animated
{
//    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_FULL inSection:SC_SECTION_DETAILS];

}

-(void)loadUrl:(NSString *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning
{
    
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];

}

- (void)webViewDidStartLoad:(UIWebView *)localWebView
{
    
    [_spinner performSelectorInBackground: @selector(startAnimating) withObject: nil];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [_spinner performSelectorInBackground: @selector(stopAnimating) withObject: nil];
    // Failed but some items parsed, so show and inform of error    
    [WPSAlertController presentOkayAlertWithTitle:@"Could Not Display Full Article" message:@"The Internet connection appears to be offline. Please check the connection, and try again."];

    
}

- (void)webViewDidFinishLoad:(UIWebView *)localWebView
{
    
    [_spinner performSelectorInBackground: @selector(stopAnimating) withObject: nil];

}

@end
