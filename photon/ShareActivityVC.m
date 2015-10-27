//
//  ShareActivityVC.m
//  photon
//
//  Created by jtq6 on 12/3/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ShareActivityVC.h"
#import "ShareActivityProvider.h"


// Create the custom activity provider
ShareActivityProvider *shareActivityProvider;
// get the image we want to share
UIImage *shareImage;
// Prepare the URL we want to share
NSURL *shareUrl;

// put the activity provider (for the text), the image, and the URL together in an array
NSArray *activityProviders;


@implementation ShareActivityVC

- (id)initWithActivityProvider
{
    
        // Create the activity view controller passing in the activity provider, image and url we want to share along with the additional source we want to appear (google+)
        self = [super initWithActivityItems:activityProviders applicationActivities:nil];
        
        // tell the activity view controller which activities should NOT appear
        self.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList];
        
        // display the options for sharing
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        

    return self;
}

- (id)initToShareApp
{
    
    // Create the custom activity provider
    shareActivityProvider = [[ShareActivityProvider alloc] initToShareApp];
    
    // get the image we want to share
    // shareImage = [UIImage imageNamed:@"about_icon"];
    shareImage = nil;
    
    // Prepare the URL we want to share
    // shareUrl = [NSURL URLWithString:@"http://www.cdc.gov/mmwr"];
    
    activityProviders = @[shareActivityProvider];;
    shareUrl = nil;
    self = [self initWithActivityProvider];
    
    [self setValue:@"MMWR Express" forKey:@"subject"];
    
    return self;

}

- (id)initToShareArticleUrl:(NSString *)articleUrl
{
    
    // Create the custom activity provider
    shareActivityProvider = [[ShareActivityProvider alloc] initToShareArticle];
    
    // get the image we want to share
    //shareImage = [UIImage imageNamed:@"about_icon"];
    shareImage = nil;
    
    // Prepare the URL we want to share
    shareUrl = [NSURL URLWithString:articleUrl];
    
    activityProviders = @[shareActivityProvider, shareUrl];
    self = [self initWithActivityProvider];
    
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UIButton appearanceWhenContainedIn:[UIActivityViewController class], nil] setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
