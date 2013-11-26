//
//  TopicKnownVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "TopicKnownVC.h"

@interface TopicKnownVC ()

@end

@implementation TopicKnownVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _txtView.text = _article.already_know;
    _txtView.font = APP_MGR.textFont;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = -1.0;
    
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

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
