//
//  ContentIpadVC.m
//  photon
//
//  Created by jtq6 on 1/14/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "ContentIpadVC.h"

@interface ContentIpadVC ()

@end

@implementation ContentIpadVC

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
    self.navigationItem.title = @"Summary";

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // check for diffs between ios 6 & 7
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)])
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0];
    else {
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0]];
    }
    
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

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Articles", @"Articles");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


@end
