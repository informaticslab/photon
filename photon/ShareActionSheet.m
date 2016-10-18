//
//  ShareActionSheet.m
//  photon
//
//  Created by jtq6 on 12/13/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ShareActionSheet.h"
#import <Social/Social.h>
#import "WPSAlertController.h"

@implementation ShareActionSheet


- (id)initToShareArticleUrl:(NSString *)articleUrl fromVC:(UIViewController *)parentVC
{
    
    if (articleUrl == nil ) {
        self.shareText = @"I’m using CDC’s MMWR Express mobile app. Learn more about it here:";
        self.shareUrl = @"http://www.cdc.gov/mmwr/mmwr_expresspage.html";
        self.shareSubject = @"MMWR Express App";
    } else {
        
        self.shareText = @"MMWR Weekly article via CDC’s MMWR Express mobile app.";
        self.shareUrl = articleUrl;
        self.shareSubject = @"MMWR Weekly Article";
        
        
    }
    self.parentVC = parentVC;

//    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", @"Message", @"Twitter", @"Facebook", nil];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Share" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Mail" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Mail button tapped
        [self showMailSheet];

        [self.parentVC dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Message button tapped
        [self showMessageSheet];
        [self.parentVC dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Twitter button tapped
        [self showTweetSheet];
        [self.parentVC dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self showFacebookSheet];
        [self.parentVC dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self.parentVC dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    


    // Present action sheet.
    [self.parentVC presentViewController:actionSheet animated:YES completion:nil];

    return self;
    
}


-(void)showView
{
    //[self.actionSheet showInView:self.parentVC.view];
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SHARE inSection:SC_SECTION_SHARE];

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
        DebugLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [self.parentVC presentViewController:tweetSheet animated:NO completion:^{
        DebugLog(@"Tweet sheet has been presented.");
    }];
    
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SHARE_TWITTER inSection:SC_SECTION_SHARE];


    
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
        DebugLog(@"Unable to add the URL!");
    }
    
    //  Presents the Tweet Sheet to the user
    [self.parentVC presentViewController:fbSheet animated:NO completion:^{
        DebugLog(@"FaceBook sheet has been presented.");
    }];
    
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SHARE_FACEBOOK inSection:SC_SECTION_SHARE];

    
    
}

- (void)showMailSheet
{
    if ([MFMailComposeViewController canSendMail]){
        
        //NSString *bodyText = [NSString stringWithFormat: @"%@<a href=\"%@\">%@</a>", self.shareText, self.shareUrl, self.shareUrl];
        

        
        NSMutableString *body = [NSMutableString string];
        // add HTML before the link here with line breaks (\n)
        [body appendString:@"<html><body>\n"];
        [body appendString:@"</br><div><p>"];
        [body appendString:self.shareText];
        [body appendString:@"</p></div>\n"];
        [body appendString:@"<div><a href=\""];
        [body appendString:self.shareUrl];
        [body appendString:@"\">"];
        [body appendString:self.shareUrl];
        [body appendString:@"</a></div></body></html>"];
        DebugLog(@"Share URL for mail is : %@", self.shareUrl);
     
        self.mailVC = [[MFMailComposeViewController alloc] init];
        self.mailVC.mailComposeDelegate = self;
        [self.mailVC setMessageBody:body isHTML:YES];
        [self.mailVC setSubject:self.shareSubject];
        
        [self.parentVC presentViewController:self.mailVC animated:YES completion:nil];
        [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SHARE_MAIL inSection:SC_SECTION_SHARE];

        
    } else {
        
        [WPSAlertController presentOkayAlertWithTitle:@"Error" message:@"There isn't a mail account setup on the device."];

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
        [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_SHARE_MESSAGE inSection:SC_SECTION_SHARE];

    } else {
        
        [WPSAlertController presentOkayAlertWithTitle:@"Error" message:@"This device does not support messaging or it is not currently configured to send messages."];
        
    }
    
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DebugLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            DebugLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            DebugLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            DebugLog(@"Mail sent failure: %@", [error localizedDescription]);
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
            DebugLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            DebugLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            DebugLog(@"Result: SMS sending failed");
            break;
        default:
            DebugLog(@"Result: SMS not sent");
            break;
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.msgVC dismissViewControllerAnimated:YES completion:NULL];
}




@end
