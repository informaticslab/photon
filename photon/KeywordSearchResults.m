//
//  KeywordSearchResults.m
//  photon
//
//  Created by jtq6 on 7/8/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "KeywordSearchResults.h"

@implementation KeywordSearchResults

NSManagedObjectModel *model;
NSManagedObjectContext *context;



-(id)initAndSearchForKeyword:(NSString *)text
{
    if (self = [super init]) {
        model = APP_MGR.managedObjectModel;
        context = APP_MGR.managedObjectContext;
        
        NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                text, @"TEXT", nil];
        
        NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"GetKeywordsWithText" substitutionVariables:substitutionDictionary];
        
        NSError *error = nil;
        self.fetchedKeywordMOs = [context executeFetchRequest:fetchRequest error:&error];
        
        self.fetchCount = [self.fetchedKeywordMOs count];
        if (self.fetchCount == 0) {
            DebugLog(@"Issues Manager has no keyword with text = %@.", text);
        }
    }
    
    return self;
}


-(void)mergeDuplicateKeywords
{
    KeywordMO *keptKeyword = nil;
    
    if (self.fetchCount == 1)
        return;
    
    for (KeywordMO *keyword in self.fetchedKeywordMOs) {
        
        // set the keyword we are going to keep if not set
        if (keptKeyword == nil) {
            keptKeyword = keyword;
        } else {
            
            // otherwise copy articles to kept keyword
            for (ArticleMO *article in keyword.articles) {
                [keptKeyword addArticlesObject:article];

            }
            
            // delete duplicate keyword
            //[context deleteObject:keyword];

        }

    }
    
    [APP_MGR saveContext];
    
}

@end
