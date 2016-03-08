//
//  SiteCatalystController.h
//  photon
//
//  Created by jtq6 on 4/9/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NSMutableData *_responseData;

#define SC_EVENT_APP_LAUNCH @"Application:Launch"
#define SC_EVENT_NAV_SECTION @"Navigation:Section"
#define SC_EVENT_INFO_BUTTON @"Info:Button"
#define SC_EVENT_SHARE_BUTTON @"Share:Button"
#define SC_EVENT_INFO_BROWSE @"Info:Browse"

#define SC_SECTION_ARTICLES @"Articles"
#define SC_SECTION_SEARCH @"Search"
#define SC_SECTION_SHARE @"Share"
#define SC_SECTION_ABOUT @"About"
#define SC_SECTION_HELP @"Help"
#define SC_SECTION_EULA @"Eula"
#define SC_SECTION_SUMMARY @"Summary"
#define SC_SECTION_DETAILS @"Article-Details"
#define SC_SECTION_ARTICLE @"Article View"



#define SC_PAGE_TITLE_LAUNCH @"MMWR Express"
#define SC_PAGE_TITLE_INFO @"Information"
#define SC_PAGE_TITLE_ABOUT @"About"
#define SC_PAGE_TITLE_HELP @"Help"
#define SC_PAGE_TITLE_EULA @"EULA"
#define SC_PAGE_TITLE_SUMMARY @"Blue-Box-Summary"
#define SC_PAGE_TITLE_LIST @"Articles"
#define SC_PAGE_TITLE_DETAILS @"Article-Details"
#define SC_PAGE_TITLE_SEARCH_KEYWORDS @"Search-Keywords"
#define SC_PAGE_TITLE_SEARCH_KEYWORD_ARTICLES @"Search-Keywords-Articles"
#define SC_PAGE_TITLE_FULL @"Full-Article"
#define SC_PAGE_TITLE_SHARE @"Share"
#define SC_PAGE_TITLE_SHARE_MAIL @"Share-Via-Mail"
#define SC_PAGE_TITLE_SHARE_MESSAGE @"Share-Via-Message"
#define SC_PAGE_TITLE_SHARE_TWITTER @"Share-Via-Twitter"
#define SC_PAGE_TITLE_SHARE_FACEBOOK @"Share-Via-Facebook"



@interface SiteCatalystController : NSObject <NSURLConnectionDelegate>

//NSMutableData *_responseData;

-(void)trackEvent:(NSString *)event withContentTitle:(NSString *)title inSection:(NSString *)section;
-(void)trackAppLaunchEvent;
-(void)trackNavigationEvent:(NSString *)pageTitle inSection:(NSString *)section;


@end
