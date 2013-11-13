//
//  AppManager.h
//  pedigree
//
//  Created by jtq6 on 3/21/13.
//  Copyright (c) 2013 CDC Informatics R&D Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define DEBUG
#import "Debug.h"
#import "IssuesManager.h"

@interface AppManager : NSObject 

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) UIFont *tableFont;
@property (nonatomic, retain) UIFont *textFont;
@property BOOL agreedWithEula;

// Core Data properties
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) IssuesManager *issuesMgr;

+ (id)singletonAppManager;
-(BOOL)isDebugInfoEnabled;
-(NSArray*)getAllIssues;

@end
