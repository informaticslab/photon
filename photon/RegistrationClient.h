//
//  RegistrationClient.h
//  MMWRPush
//
//  Created by Greg on 7/8/15.
//  Copyright (c) 2015 bitBrill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationClient : NSObject

@property(nonatomic, strong) NSData *token;


-(id)initWithToken:(NSData *)deviceToken;

@end
