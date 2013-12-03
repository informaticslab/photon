//
//  ShareActivityVC.m
//  photon
//
//  Created by jtq6 on 12/3/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ShareActivityVC.h"
#import "ShareActivityProvider.h"

@interface ShareActivityVC ()

@end

@implementation ShareActivityVC

- (id)init
{
    
        // Create the custom activity provider
        ShareActivityProvider *shareActivityProvider = [[ShareActivityProvider alloc] init];
        // get the image we want to share
        UIImage *shareImage = [UIImage imageNamed:@"about_icon"];
        // Prepare the URL we want to share
        NSURL *shareUrl = [NSURL URLWithString:@"http://www.cdc.gov/mmwr/mmwr_wk/wk_cvol.html"];
        
        // put the activity provider (for the text), the image, and the URL together in an array
        NSArray *activityProviders = @[shareActivityProvider, shareImage, shareUrl];
        
        // Create the activity view controller passing in the activity provider, image and url we want to share along with the additional source we want to appear (google+)
        self = [super initWithActivityItems:activityProviders applicationActivities:nil];
        
        // tell the activity view controller which activities should NOT appear
        self.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList];
        
        // display the options for sharing
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
