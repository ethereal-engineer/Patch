//
//  PDSDataSourceChangeListener.m
//  Patch
//
//  Created by Adam Iredale on 5/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSDataSourceChangeListener.h"

@implementation PDSDataSourceChangeListener

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

- (instancetype)initWithDataSource:(id<PDSChangingDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    self = [super init];
    if (self)
    {
        [dataSource.changeNotifier addChangeListener:self];
    }
    return self;
}

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    if (_dataSourceWillChangeBlock)
    {
        _dataSourceWillChangeBlock(dataSource);
    }
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    if (_dataSourceDidChangeBlock)
    {
        _dataSourceDidChangeBlock(dataSource);
    }
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    if (_dataSourceDidReloadBlock)
    {
        _dataSourceDidReloadBlock(dataSource);
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceDidInsertItemBlock)
    {
        _dataSourceDidInsertItemBlock(dataSource, indexPath);
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceDidRemoveItemBlock)
    {
        _dataSourceDidRemoveItemBlock(dataSource, indexPath);
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSourceDidUpdateItemBlock)
    {
        _dataSourceDidUpdateItemBlock(dataSource, indexPath);
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    // TODO
}

#pragma mark - Class Methods

+ (instancetype)listenerForDataSource:(id<PDSChangingDataSource>)dataSource
{
    PDSDataSourceChangeListener *listener = nil;
    @autoreleasepool
    {
        listener = [[PDSDataSourceChangeListener alloc] initWithDataSource:dataSource];
    }
    return listener;
}

@end
