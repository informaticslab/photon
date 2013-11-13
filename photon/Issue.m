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
        NSArray *titleSplit = [_title componentsSeparatedByString:@"/"];
        if ([titleSplit count] == 3) {
            self.date = titleSplit[0];
            self.volume = titleSplit[1];
            self.number = titleSplit[2];
        }

       
    }
    
    return self;
}

@end
