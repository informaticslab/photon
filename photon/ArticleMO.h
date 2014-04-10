//
//  ArticleMO.h
//  photon
//
//  Created by jtq6 on 3/10/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IssueMO, KeywordMO;

@interface ArticleMO : NSManagedObject

@property (nonatomic, retain) NSString * added_by_report;
@property (nonatomic, retain) NSString * already_known;
@property (nonatomic, retain) NSString * implications;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) IssueMO *issue;
@property (nonatomic, retain) NSSet *tags;

@end

@interface ArticleMO (CoreDataGeneratedAccessors)

- (void)addTagsObject:(KeywordMO *)value;
- (void)removeTagsObject:(KeywordMO *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
