//
//  ShareActionSheet.h
//  photon
//
//  Created by jtq6 on 12/13/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShareActionSheet : NSObject <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property(nonatomic, weak) UIViewController *parentVC;
@property(nonatomic, strong) UIActionSheet *actionSheet;
@property(nonatomic, strong) MFMailComposeViewController *mailVC;
@property(nonatomic, strong) MFMessageComposeViewController *msgVC;



- (id)initToShareApp:(UIViewController *)parentVC;
-(void)showView;


@end
