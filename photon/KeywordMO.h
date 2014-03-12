//
//  KeywordMO.h
//  photon
//
//  Created by jtq6 on 3/12/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ArticleMO;

@interface KeywordMO : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *articles;
@end

@interface KeywordMO (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(ArticleMO *)value;
- (void)removeArticlesObject:(ArticleMO *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
