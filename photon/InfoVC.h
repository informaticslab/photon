//
//  InfoVC.h
//  photon
//
//  Created by jtq6 on 12/2/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoVC : UIViewController
- (IBAction)segCtrlValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *infoVC;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtrlHelpAbout;
@property (weak, nonatomic) IBOutlet UIView *helpVC;

@end
