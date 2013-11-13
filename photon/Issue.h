//
//  Issue.h
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Issue : NSObject

@property(strong, nonatomic) NSMutableArray *articles;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *number;
@property(strong, nonatomic) NSString *volume;

-(id)initWithTitle:(NSString *)title;

@end
