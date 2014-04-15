//
//  IpadTabBarController.m
//  photon
//
//  Created by jtq6 on 3/14/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "IpadTabBarController.h"

@interface IpadTabBarController ()
@property NSUInteger lastSelectedIndex;
@end

@implementation IpadTabBarController

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
    self.delegate = self;
    self.lastSelectedIndex = 0;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if (self.selectedIndex != _lastSelectedIndex) {
        _lastSelectedIndex = self.selectedIndex;
        [APP_MGR.splitVM searchStart];

        
    }
    
}
@end
