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
    
	if ((self = [super init]))
    {
		self.appName = @"Photon";
        self.agreedWithEula = FALSE;
        
//      self.tableFont = [UIFont boldSystemFontOfSize: 16];
        self.tableFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
        self.textFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        
        // set up core data properties
        self.managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        self.managedObjectModel = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectModel;
        self.persistentStoreCoordinator = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentStoreCoordinator;
        
        if ([APP_MGR isDeviceIpad] == YES)
            self.splitVM = [[SplitViewManager alloc] init];
        
        self.issuesMgr = [[IssuesManager alloc  ]init];
        self.jsonParser = [[JsonParser alloc] init];
        
        [self.jsonParser parseAndPersistTestData];
        //[self.jsonParser parseTestData];
        //[self.jsonParser updateFromFeed];
                
    }
	return self;

}

-(BOOL)isDeviceIpad
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return YES;
        
    return NO;
}

-(BOOL)isDebugInfoEnabled
{
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enableDebugInfo"];
    return enabled;
    
}

- (void)presentEulaModalView
{
    
    if (_agreedWithEula == TRUE)
    return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@",
                             [appInfo objectForKey:@"CFBundleShortVersionString"],
                             [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed])
    {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        NSLog(@"Data saved");
        NSLog(@"%@", currVersion);
        
        // Create the modal view controller
        // EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        
        // we are the delegate that is responsible for dismissing the help view
//        eulaVC.delegate = self;
 //       eulaVC.modalPresentationStyle = UIModalPresentationPageSheet;
 //       [self presentModalViewController:eulaVC animated:YES];
        
    }
    
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}






@end
