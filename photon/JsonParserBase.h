//
//  SchemaBase.h
//  photon
//
//  Created by jtq6 on 1/26/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParserBase : NSObject

+(NSInteger)integerValueForKey:(NSString *)key inJson:(NSDictionary *)json;
+(NSString *)stringValueForKey:(NSString *)key inJson:(NSDictionary *)json;
+(NSInteger)parseSchemaVersionFromJson:(NSDictionary *)json;
+(NSInteger)parseContentVersionFromJson:(NSDictionary *)json;

@end
