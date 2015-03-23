//
//  MGDirectoryContentDataSource.m
//  Mytograph
//
//  Created by Adam Iredale on 19/03/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGDirectoryContentDataSource.h"

@interface MGDirectoryContentDataSource ()

@end

@implementation MGDirectoryContentDataSource

#pragma mark - Init

- (instancetype)initWithArray:(NSArray *)array
{
    self = [self initWithURL:nil];
    if (self)
    {
        // Will always fail - please use designated init instead
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)directoryURL
{
    NSParameterAssert(directoryURL);
    
    NSError *error = nil;
    
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:directoryURL
                                                   includingPropertiesForKeys:nil options:0 error:&error];
    if (!array)
    {
        NSLog(@"Unable to get contents of directory at URL for datasource: %@", error);
    }
    
    self = [super initWithArray:array];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Class Methods

+ (instancetype)dataSourceWithURL:(NSURL *)directoryURL
{
    MGDirectoryContentDataSource *dataSource = nil;
    @autoreleasepool
    {
        dataSource = [[MGDirectoryContentDataSource alloc] initWithURL:directoryURL];
    }
    return dataSource;
}

@end
