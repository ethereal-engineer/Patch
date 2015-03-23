//
//  MGMenuItem.m
//  Mytograph
//
//  Created by Adam Iredale on 4/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGMenuItem.h"

@interface MGMenuItem ()
/**
 *  Redefine read-only from protocol
 */
@property (nonatomic, strong) NSString  *identifier;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation MGMenuItem

#pragma mark - Init

- (instancetype)init
{
    // Will always fail - please use designated init instead
    self = [self initWithIdentifier:nil title:nil image:nil userInfo:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title image:(UIImage *)image userInfo:(NSDictionary *)userInfo
{
    NSParameterAssert(identifier.length > 0);
    self = [super init];
    if (self)
    {
        self.identifier = identifier;
        self.title      = title;
        self.image      = image;
        self.userInfo   = userInfo;
    }
    return self;
}

#pragma mark - Debug

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@"{ identifier : %@, title: %@, ... , userInfo: %@ }", _identifier, _title, _userInfo];
}

#pragma mark - Class Methods

+ (instancetype)menuItemWithIdentifier:(NSString *)identifier title:(NSString *)title image:(UIImage *)image userInfo:(NSDictionary *)userInfo
{
    MGMenuItem *menuItem = nil;
    @autoreleasepool
    {
        menuItem = [[MGMenuItem alloc] initWithIdentifier:identifier title:title image:image userInfo:userInfo];
    }
    return menuItem;
}

@end
