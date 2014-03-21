//
//  ShareActivityProvider.m
//  photon
//
//  Created by jtq6 on 12/3/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ShareActivityProvider.h"

@implementation ShareActivityProvider

// Create the default sharing string
NSString *twitterString;
NSString *facebookString;
NSString *mailString;
NSString *messageString;

-(id)initToShareApp
{
    self = [super init];
    
    if (self ) {
        
        NSString *shareString = @"I’m using CDC’s MMWR Express mobile app.  Learn more about it at: http://www.cdc.gov/mmwr";
        facebookString = mailString = messageString = shareString;
        twitterString = @"I’m using CDC’s MMWR Express mobile app.  Learn more about it at: http://www.cdc.gov/mmwr";
        
    }
    
    return self;
}

-(id)initToShareArticle
{

    self = [super init];
    
    if (self ) {
        NSString *shareString = @"MMWR Weekly article via CDC’s MMWR Express mobile app.";
        facebookString = mailString = messageString = twitterString = shareString;
    }
    
    return self;
    
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
   
    // Log out the activity type that we are sharing with
    NSLog(@"%@", activityType);
    NSString *shareString;
    
    // customize the sharing string for facebook, twitter
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        shareString = facebookString;
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        shareString = twitterString;
    } else if ([activityType isEqualToString:UIActivityTypeMail]) {
        shareString = mailString;
    } else if ([activityType isEqualToString:UIActivityTypeMessage]) {
        shareString = messageString;
    }
    
    return shareString;

}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end
