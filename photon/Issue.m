//
//  Issue.m
//  photon
//
//  Created by jtq6 on 11/6/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "Issue.h"

@implementation Issue

-(id)initWithTitle:(NSString *)title
{
    
    if(self= [super init]) {
        
        self.title= title;
        self.articles = [[NSMutableArray alloc] init];
       
    }
    
    return self;
}

@end
