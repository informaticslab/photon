//
//  IssueMO.h
//  photon-core-data
//
//  Created by jtq6 on 3/6/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IssueMO : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSNumber * unread;
@property (nonatomic, retain) NSSet *articles;
@end

@interface IssueMO (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(NSManagedObject *)value;
- (void)removeArticlesObject:(NSManagedObject *)value;
- (void)addArticles:(NSSet *)values;
- (void)removeArticles:(NSSet *)values;

@end
