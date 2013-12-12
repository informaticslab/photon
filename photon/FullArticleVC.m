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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    _spinner.hidesWhenStopped = YES;

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
    
}

- (void)webViewDidFinishLoad:(UIWebView *)localWebView
{
    
    [_spinner performSelectorInBackground: @selector(stopAnimating) withObject: nil];

}

@end
