//
//  ContentIpadVC.h
//  photon
//
//  Created by jtq6 on 1/14/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ContentIpadVC : UIViewController <UISplitViewControllerDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property NSUInteger pageIndex;
@property NSString *headerText;
@property NSString *contentText;
@property NSString *imageName;
@property (weak, nonatomic) NSString *navbarTitle;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UITextView *txtvContentText;
@property (weak, nonatomic) Article *article;
@property (weak, nonatomic) Issue *issue;


@end
