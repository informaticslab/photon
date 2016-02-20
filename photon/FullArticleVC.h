//
//  FullArticleVC.h
//  photon
//
//  Created by jtq6 on 11/26/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullArticleVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

-(void)loadUrl:(NSString *)url;

@end
