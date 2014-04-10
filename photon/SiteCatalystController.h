//
//  SiteCatalystController.h
//  photon
//
//  Created by jtq6 on 4/9/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NSMutableData *_responseData;



@interface SiteCatalystController : NSObject <NSURLConnectionDelegate>

//NSMutableData *_responseData;

-(void)trackEvent:(NSString *)event withContentTitle:(NSString *)title inSection:(NSString *)section;
-(void)trackAppLaunchEvent;


@end
