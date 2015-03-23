//
//  MGDataSourceChangeListener.m
//  Mytograph
//
//  Created by Adam Iredale on 5/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGDataSourceChangeListener.h"

@implementation MGDataSourceChangeListener

#pragma mark - Init

- (instancetype)init
{
    // Always fails - please use designated init
    self = [self initWithDataSource:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithDataSource:(id<MGChangingDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    self = [super init];
    if (self)
    {
        [dataSource.changeNotifier addChangeListener:self];
    }
    return self;
}

#pragma mark - MGDataSourceChangeListener

- (void)dataSourceWillChange:(id<MGDataSource>)dataSource
{
    if (_dataSourceWillChangeBlock)
    {
        _dataSourceWillChangeBlock(dataSource);
    }
}

- (void)dataSourceDidChange:(id<MGDataSource>)dataSource
{
    if (_dataSourceDidChangeBlock)
    {
        _dataSourceDidChangeBlock(dataSource);
    }
}

- (void)dataSourceDidReload:(id<MGDataSource>)dataSource
{
    if (_dataSourceDidReloadBlock)
    {
        _dataSourceDidReloadBlock(dataSource);
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceDidInsertItemBlock)
    {
        _dataSourceDidInsertItemBlock(dataSource, indexPath);
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceDidRemoveItemBlock)
    {
        _dataSourceDidRemoveItemBlock(dataSource, indexPath);
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceDidUpdateItemBlock)
    {
        _dataSourceDidUpdateItemBlock(dataSource, indexPath);
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    // TODO
}

#pragma mark - Class Methods

+ (instancetype)listenerForDataSource:(id<MGChangingDataSource>)dataSource
{
    MGDataSourceChangeListener *listener = nil;
    @autoreleasepool
    {
        listener = [[MGDataSourceChangeListener alloc] initWithDataSource:dataSource];
    }
    return listener;
}

@end
