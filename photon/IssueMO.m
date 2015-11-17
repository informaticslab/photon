//
//  IssueMO.m
//  photon-core-data
//
//  Created by jtq6 on 3/6/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "IssueMO.h"


@implementation IssueMO

@dynamic title;
@dynamic date;
@dynamic number;
@dynamic volume;
@dynamic unread;
@dynamic articles;

-(NSString *)debugDescription
{
    
    NSString *returnString = [NSString stringWithFormat:@"Issue title=%@ date=%@ num=%@ vol=%@", self.title, self.date, self.number, self.volume];
    return returnString;
    
}

@end
