//
//  AppManager.m
//  pedigree
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#import "AppManager.h"
#import "AppDelegate.h"
static AppManager *sharedAppManager = nil;

@implementation AppManager


#pragma mark Singleton Methods
+ (id)singletonAppManager {
	@synchronized(self) {
		if(sharedAppManager == nil)
			sharedAppManager = [[self alloc] init];
	}
    
	return sharedAppManager;

}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedAppManager == nil)  {
			sharedAppManager = [super allocWithZone:zone];
			return sharedAppManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}


- (id)init {
    
	if ((self = [super init])) {
		self.appName = @"Photon";
        self.agreedWithEula = FALSE;
//      self.tableFont = [UIFont boldSystemFontOfSize: 16];
        self.tableFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.textFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.issuesMgr = [[IssuesManager alloc  ]initWithTestData];
        
	
    }
	return self;

}


-(NSArray *)getAllIssues
{
    return _issuesMgr.issues;

}

-(BOOL)isDebugInfoEnabled
{
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enableDebugInfo"];
    return enabled;
    
}
@end
