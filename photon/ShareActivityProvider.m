//
//  ShareActivityProvider.m
//  photon
//
//  Created by jtq6 on 12/3/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ShareActivityProvider.h"

@implementation ShareActivityProvider


- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
   
    // Log out the activity type that we are sharing with
    NSLog(@"%@", activityType);
    
    // Create the default sharing string
    NSString *shareString = @"Share MMWR Express";
    
    // customize the sharing string for facebook, twitter
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        shareString = [NSString stringWithFormat:@"Attention Facebook: %@", shareString];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        shareString = [NSString stringWithFormat:@"Attention Twitter: %@", shareString];
    }
    
    return shareString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end
