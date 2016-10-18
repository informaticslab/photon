//
//  SupportVC.m
//  photon
//
//  Created by Greg Ledbetter on 11/30/15.
//  Copyright © 2015 Informatics Research and Development Lab. All rights reserved.
//

#import "SupportVC.h"
#import "WPSAlertController.h"

@interface SupportVC ()

@end

@implementation SupportVC


- (void)viewDidLoad {
    
    [super viewDidLoad];


}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnEmailSupportTouchUp:(id)sender {

    if ([MFMailComposeViewController canSendMail])
    {
        self.mail = [[MFMailComposeViewController alloc] init];
        [self.mail.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];

        
        self.mail.mailComposeDelegate = self;
        [self.mail setSubject:@"App Support Request: MMWR Express for iOS"];
        NSString *messageBody = [NSString stringWithFormat:@"\n\n\nApp name:  MMWR Express for iOS \nApp version:  %@  \nDevice model:  %@ \nSystem name:  %@ \nSystem version:  %@", [APP_MGR getAppVersion], [APP_MGR getDeviceModel], [APP_MGR getDeviceSystemName], [APP_MGR getDeviceSystemVersion]];
        [self.mail setMessageBody:messageBody isHTML:NO];
        [self.mail setToRecipients:@[@"informaticslab@cdc.gov"]];

        [self presentViewController:self.mail animated:YES completion:NULL];

    }
    else
    {
        
        NSLog(@"This device cannot send email");
        [WPSAlertController presentOkayAlertWithTitle:@"Error" message:@"There isn't a mail account setup on the device."];

    }

    

}
@end
