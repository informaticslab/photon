//
//  InfoVC.m
//  photon
//
//  Created by jtq6 on 12/2/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "InfoVC.h"


@implementation InfoVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Information";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    doneButton.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = doneButton;
    _infoVC.hidden = NO;
    _helpVC.hidden = YES;
    [self.view bringSubviewToFront:_infoVC];


}


- (IBAction)btnReadUserAgreementTouchUp:(id)sender {
    
    if (APP_MGR.isDeviceIpad)
        [self.popoverViewDelegate didTouchReadUserAgreementButton];
    else
        [self performSegueWithIdentifier:@"displayEulaSegue" sender:nil];
    
    
}




- (void)donePressed:(id)sender
{
 
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segCtrlValueChanged:(id)sender {
    
    if (_segCtrlHelpAbout.selectedSegmentIndex == 0) {
        _infoVC.hidden = NO;
        _helpVC.hidden = YES;
        [self.view bringSubviewToFront:_infoVC];
    } else if (_segCtrlHelpAbout.selectedSegmentIndex == 1) {
        _helpVC.hidden = NO;
        _infoVC.hidden = YES;
        [self.view bringSubviewToFront:_helpVC];
    }

}
@end
