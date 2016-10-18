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
@property(nonatomic, strong) MFMailComposeViewController *mailVC;
@property(nonatomic, strong) MFMessageComposeViewController *msgVC;
@property(nonatomic, strong) NSString *shareText;
@property(nonatomic, strong) NSString *htmlText;
@property(nonatomic, strong) NSString *shareUrl;
@property(nonatomic, strong) NSString *shareSubject;


//- (id)initToShareApp:(UIViewController *)parentVC;
- (id)initToShareArticleUrl:(NSString *)articleUrl fromVC:(UIViewController *)parentVC;
-(void)showView;

@end
