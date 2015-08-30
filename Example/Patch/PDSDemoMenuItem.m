//
//  PDSDemoMenuItem.m
//  Patch
//
//  Created by Adam Iredale on 21/04/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoMenuItem.h"

@implementation PDSDemoMenuItem

@synthesize title, subtitle, userInfo;

+ (instancetype)menuItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle userInfo:(NSDictionary *)userInfo
{
    PDSDemoMenuItem *item = nil;
    @autoreleasepool
    {
        item = [[PDSDemoMenuItem alloc] init];
        item.title      = title;
        item.subtitle   = subtitle;
        item.userInfo   = userInfo;
    }
    return item;
}

+ (instancetype)menuItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    return [self menuItemWithTitle:title subtitle:subtitle userInfo:nil];
}

@end
