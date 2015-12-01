//
//  SupportVC.h
//  photon
//
//  Created by Greg Ledbetter on 11/30/15.
//  Copyright © 2015 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SupportVC : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)btnEmailSupportTouchUp:(id)sender;
@property(nonatomic, strong) MFMailComposeViewController *mail;

@end
