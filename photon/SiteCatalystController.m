//
//  SiteCatalystController.m
//  photon
//
//  Created by jtq6 on 4/9/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "SiteCatalystController.h"

@implementation SiteCatalystController

NSString *cdcServer = @"https://tools.cdc.gov/metrics.aspx?";
NSString *localServer = @"https://localhost:5000/metrics?";
NSString *commonConstParams = @"c8=Mobile App&c51=Standalone&c52=MMWR Express&c5=eng&channel=IIU";
NSString *prodConstParams = @"reportsuite=cdcsynd";
NSString *debugConstParams = @"reportsuite=devcdc";
NSURLConnection *conn;


#pragma mark NSURLConnection Delegate Methods

-(void)trackEvent:(NSString *)event withContentTitle:(NSString *)title inSection:(NSString *)section
{
    NSString *deviceModel, *deviceOsName, *deviceOsVers, *deviceParams;
    NSString *sectionInfo, *appVersion, *server, *appInfoParams, *pageName;
    NSString *deviceOnline, *constParams, *metricUrl, *encodedURL, *eventInfo;
    
    DebugLog(@"In trackEvent");
    
    // these first change most often depending on version and if debug is true
    appVersion = [APP_MGR getAppVersion ];
    BOOL debug = NO;
    BOOL debugLocal = NO;
    
    // server information
    server = debugLocal ? localServer : cdcServer;
    
    // device info
    deviceModel = [APP_MGR getDeviceModel];
    deviceOsName = [APP_MGR getDeviceSystemName];
    deviceOsVers = [APP_MGR getDeviceSystemVersion];
    deviceParams = [NSString stringWithFormat:@"c54=%@&c55=%@&c56=%@", deviceOsName, deviceOsVers, deviceModel];
    
    // application info
    appInfoParams = [NSString stringWithFormat:@"c53=%@", appVersion];
    
    // set event param
    eventInfo = [NSString stringWithFormat:@"c58=%@", event];
    
    // set section param
    sectionInfo = [NSString stringWithFormat:@"c59=%@", section];
    
    // page information
    pageName = [NSString stringWithFormat:@"contenttitle=%@", title];
    
    // device online status
    deviceOnline = @"c57=1";
    
    constParams = [NSString stringWithFormat:@"%@&%@", (debug ? debugConstParams : prodConstParams), commonConstParams];
    
    metricUrl = [NSString stringWithFormat:@"%@%@&%@&%@&%@&%@&%@&%@",server, constParams, deviceParams, appInfoParams, deviceOnline, eventInfo, sectionInfo, pageName];
    encodedURL = [NSString stringWithFormat:@"%@", [metricUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self postSCEvent:encodedURL];
    DebugLog(@"metric URL = %@",metricUrl);
    
}

-(void)trackAppLaunchEvent
{
    [self trackEvent:SC_EVENT_APP_LAUNCH withContentTitle:SC_PAGE_TITLE_LAUNCH inSection:SC_SECTION_ARTICLES];
    
}

-(void)trackNavigationEvent:(NSString *)pageTitle inSection:(NSString *)section
{
    [self trackEvent:SC_EVENT_NAV_SECTION withContentTitle:pageTitle inSection:section];
    
}

-(void)postSCEvent:(NSString *)scString
{
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:scString]];
    
    // Specify that it will be a POST request
    [request setHTTPMethod:@"GET"];
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = @"";
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBodyData];
    
    // Create url connection and fire request
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    DebugLog(@"Site Catalyst Connection Finished");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    DebugLog(@"Site Catalyst Connection Error = %@", error);
}



@end
