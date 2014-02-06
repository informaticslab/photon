//
//  ContentVC.m
//  photon
//
//  Created by jtq6 on 12/31/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ContentVC.h"

NSDictionary *regTextAttributes;

@interface ContentVC ()

@end

@implementation ContentVC

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
    
    self.lblHeader.text = self.headerText;
    [self.txtvContentText setScrollEnabled:YES];
    [self.txtvContentText setUserInteractionEnabled:YES];
    self.txtvContentText.delegate = self;
    self.txtvContentText.showsVerticalScrollIndicator = YES;
    self.txtvContentText.text = self.contentText;
    self.txtvContentText.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.icon.image = [UIImage imageNamed:_imageName];

    self.parentViewController.navigationItem.title = self.navbarTitle;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
