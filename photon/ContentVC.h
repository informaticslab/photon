//
//  ContentVC.h
//  photon
//
//  Created by jtq6 on 12/31/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentVC : UIViewController

@property NSUInteger pageIndex;
@property NSString *headerText;
@property NSString *contentText;

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UITextView *txtvContentText;


@end
