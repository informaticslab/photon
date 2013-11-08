//
//  Article.h
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *already_know;
@property(strong, nonatomic) NSString *added_by_report;
@property(strong, nonatomic) NSString *implications;
@property(strong, nonatomic) NSMutableArray *tags;



-(id)initWithTitle:(NSString *)title;

@end
