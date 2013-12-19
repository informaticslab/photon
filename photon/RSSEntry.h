//
//  RSSEntry.h
//  photon
//
//  Created by jtq6 on 12/18/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSEntry : NSObject {
    NSString *_blogTitle;
    NSString *_articleTitle;
    NSString *_articleUrl;
    NSDate *_articleDate;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSDate *articleDate;

- (id)initWithBlogTitle:(NSString*)blogTitle articleTitle:(NSString*)articleTitle articleUrl:(NSString*)articleUrl articleDate:(NSDate*)articleDate;



@end
