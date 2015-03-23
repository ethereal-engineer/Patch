//
//  MGArrayDataSource.m
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGArrayDataSource.h"

@interface MGArrayDataSource ()
/**
 *  Redefinte Read-Only Properties
 */
@property (nonatomic, strong) NSArray *array;

@end

@implementation MGArrayDataSource

#pragma mark - Init

- (instancetype)init
{
    // Fails - please use designated init
    self = [self initWithArray:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    NSParameterAssert(array);
    self = [super init];
    if (self)
    {
        self.array = array;
    }
    return self;
}

#pragma mark - MGDataSource

- (NSUInteger)numberOfItems
{
    return _array.count;
}

- (NSUInteger)numberOfSections
{
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
}

- (id)itemAtIndex:(NSInteger)index
{
    return _array[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"This datasource does not support sections");
    return [self itemAtIndex:indexPath.item];
}

- (void)reload
{
    // Nothing to do!
}

#pragma mark - Class Methods

+ (instancetype)arrayDataSourceWithArray:(NSArray *)array
{
    MGArrayDataSource *dataSource = nil;
    @autoreleasepool
    {
        dataSource = [[MGArrayDataSource alloc] initWithArray:array];
    }
    return dataSource;
}

@end
