//
//  ShareActionSheet.m
//  photon
//
//  Created by jtq6 on 12/13/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ShareActionSheet.h"
#import <Social/Social.h>

@implementation ShareActionSheet


- (id)initToShareApp:(UIViewController *)parentVC
{
    
    self.shareText = @"I’m using CDC’s MMWR Express mobile app. Learn more about it here:";
    self.shareUrl = @"http://www.cdc.gov/mmwr/";
    self.shareSubject = @"MMWR Express App";
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", @"Message", @"Twitter", @"Facebook", nil];
    
    self.parentVC = parentVC;
    return self;
    
}

- (id)initToShareArticleUrl:(NSString *)articleUrl fromVC:(UIViewController *)parentVC
{
    self.shareText = @"MMWR Weekly article via CDC’s MMWR Express mobile app.";
    self.shareUrl = articleUrl;
    self.shareSubject = @"MMWR Weekly Article";
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", @"Message", @"Twitter", @"Facebook", nil];
    
    self.parentVC = parentVC;
    return self;
    
}


-(void)showView
{
    [self.actionSheet showInView:self.parentVC.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        // Mail
        case 0:
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [self showMailSheet];
        break;
        // Message
        case 1:
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
            [self showMessageSheet];
        break;
        // Twitter
        case 2:
            [self showTweetSheet];
        break;
        // Facebook
        case 3:
            [self showFacebookSheet];
        break;
    }

}

- (void)showTweetSheet
{
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
            //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
            break;
            //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
            break;
        }
    };
    
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText:self.shareText];
    
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet addURL:[NSURL URLWithString:self.shareUrl]]){
        NSLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [self.parentVC presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];

    
}

- (void)showFacebookSheet
{
    SLComposeViewController *fbSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeFacebook];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    fbSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    //  Set the initial body
    [fbSheet setInitialText:self.shareText];
    
    if (![fbSheet addURL:[NSURL URLWithString:self.shareUrl]]){
        NSLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [self.parentVC presentViewController:fbSheet animated:NO completion:^{
        NSLog(@"FaceBook sheet has been presented.");
    }];
    
    
    
}

- (void)showMailSheet
{
    if ([MFMailComposeViewController canSendMail]){
        
        //NSString *bodyText = [NSString stringWithFormat: @"%@<a href=\"%@\">%@</a>", self.shareText, self.shareUrl, self.shareUrl];
        
        NSString *bodyText = [NSString stringWithFormat: @"I’m using CDC’s MMWR Express mobile app. Learn more about it here:"];

        
        NSMutableString *body = [NSMutableString string];
        // add HTML before the link here with line breaks (\n)
        [body appendString:@"<html><body>\n"];
        [body appendString:@"</br><div><p>I’m using CDC’s MMWR\n"];
        [body appendString:@"Express mobile app. Learn more\n"];
        [body appendString:@"about it here:</p></div>\n"];
        [body appendString:@"<div><a href=\"http://www.cdc.gov/mmwr\">http://www.cdc.gov/mmwr</a></div></body></html>"];
        NSLog(@"Share URL for mail is : %@", bodyText);
     
        self.mailVC = [[MFMailComposeViewController alloc] init];
        self.mailVC.mailComposeDelegate = self;
        [self.mailVC setMessageBody:body isHTML:YES];
        [self.mailVC setSubject:self.shareSubject];
        
        [self.parentVC presentViewController:self.mailVC animated:YES completion:nil];
        
    } else {
        
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There isn't a mail account setup on the device." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        
        [anAlert addButtonWithTitle:@"Cancel"];
        [anAlert show];
    }
    
    
}

- (void)showMessageSheet
{
    
    NSString *bodyText = [NSString stringWithFormat: @"%@ %@", self.shareText, self.shareUrl];
    
    if ([MFMessageComposeViewController canSendText]) {
        
        self.msgVC = [[MFMessageComposeViewController alloc] init];
        self.msgVC.messageComposeDelegate = self;
        [self.msgVC setBody:bodyText];
        [self.parentVC presentViewController:self.msgVC animated:YES completion:nil];
    } else {
        
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not support messaging or it is not currently configured to send messages." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
        [anAlert addButtonWithTitle:@"Cancel"];
        [anAlert show];
        
    }
    
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [self.mailVC dismissViewControllerAnimated:YES completion:nil];

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS sending failed");
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.msgVC dismissViewControllerAnimated:YES completion:NULL];
}




@end
