//
//  RegistrationClient.m
//  MMWRPush
//
//  Created by Greg on 7/8/15.
//  Copyright (c) 2015 bitBrill. All rights reserved.
//

#import "RegistrationClient.h"
#import <UIKit/UIKit.h>

/*
 * Utils: Add this section before your class implementation
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}


@implementation RegistrationClient

-(id)initWithToken:(NSData *)deviceToken
{
    
    self = [super init];
    if (self) {
        self.token = deviceToken;
        [self sendRegistration];
        
    }
    return self;
}


- (void)sendRegistration
{
    /* Configure session, choose between:
     * defaultSessionConfiguration
     * ephemeralSessionConfiguration
     * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     Create iOS Device (POST http://192.168.1.16:8000/device/apns/
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://mmwr.gsledbetter.webfactional.com/device/apns/"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    // Headers
    [request addValue:@"Basic aW9zLWRldmljZTpkMG50cHVzaG0z" forHTTPHeaderField:@"Authorization"];
    
    // convert token into string hex
    NSString *deviceToken = [[[self.token.description stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Formatted token = %@", deviceToken);
    
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceId = [identifierForVendor UUIDString];
    NSLog(@"Device ID for vendor = %@", deviceId);


    // Form URL-Encoded Body
    NSDictionary* bodyParameters = @{
                                     @"registration_id": deviceToken,
                                     @"device_id": deviceId,
                                     @"name": @"ios-device",
                                     @"active": @"true",
                                     };
    request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}




@end
