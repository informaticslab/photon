//
//  HelpVC.m
//  photon
//
//  Created by jtq6 on 12/2/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()

@end

@implementation HelpVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    _scrollView.scrollEnabled = YES;
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_scrollView setContentSize:(CGSizeMake(320, 727))];
////[_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
//                                                            attribute:NSLayoutAttributeBottom
//                                                            relatedBy:NSLayoutRelationEqual
//                                                               toItem:_scrollView
//                                                            attribute:NSLayoutAttributeBottom
//                                                           multiplier:1.0
//                                                             constant:0]];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
