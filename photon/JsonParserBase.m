//
//  SchemaBase.m
//  photon
//
//  Created by jtq6 on 1/26/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "JsonParserBase.h"

@implementation JsonParserBase


+(NSInteger)integerValueForKey:(NSString *)key inJson:(NSDictionary *)json
{
    NSString *integerStr = [json valueForKey:key];
//    if (integerStr == nil) {
//        DebugLog(@"JSON key:%@ not found", key);
//    } else {
//        DebugLog(@"JSON key:%@ has integer value:%@", key, integerStr);
//    }
    
    NSInteger integerValue = [integerStr integerValue];
    
    return integerValue;
    
}

+(NSString *)stringValueForKey:(NSString *)key inJson:(NSDictionary *)json
{
    NSString *strValue = [json valueForKey:key];
//    if (strValue == nil) {
//        DebugLog(@"JSON key:%@ not found", key);
//    } else {
//        DebugLog(@"JSON key:%@ has string value:%@", key, strValue);
//    }
    return strValue;
    
}

+(NSInteger)parseSchemaVersionFromJson:(NSDictionary *)json
{
    NSInteger schemaVer = [self integerValueForKey:@"schema-ver" inJson:json];
    return schemaVer;
}



@end
