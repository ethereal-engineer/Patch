//
//  MGDataSourceCluster.m
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGCompositeDataSource.h"

#pragma mark - Composites

#import "MGDataSourceChangeNotifier.h"

/**
 *  Currently this does no caching, but it could if required for future use
 */

@interface MGCompositeDataSource () <MGDataSourceChangeListener>

@property (nonatomic, strong) id <MGDataSourceChangeNotifier> changeNotifier;

/**
 *  Redefine Read Onlys
 */
@property (nonatomic, strong) NSArray *dataSources;

@end

@implementation MGCompositeDataSource

#pragma mark - Init

- (instancetype)init
{
    // Will always fail - please use designated init
    self = [self initWithDataSources:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithDataSources:(NSArray *)dataSources
{
    self = [super init];
    if (self)
    {
        self.dataSources = dataSources;
        for (id <MGDataSource> dataSource in dataSources)
        {
            if ([dataSource conformsToProtocol:@protocol(MGChangingDataSource)])
            {
                [[(id <MGChangingDataSource>)dataSource changeNotifier] addChangeListener:self];
            }
        }
    }
    return self;
}

#pragma mark - Private

- (NSIndexPath *)indexPathForDataSource:(id <MGDataSource>)dataSource indexPath:(NSIndexPath *)indexPath
{
    // Return the native index path to the datasource's given index path
    // TODO: add a cached information system on each datasource with offsets to speed this up
    NSUInteger runningTotal = 0;
    for (id <MGDataSource> childDataSource in _dataSources)
    {
        if (childDataSource == dataSource)
        {
            break;
        }
        else
        {
            runningTotal += childDataSource.numberOfItems;
        }
    }
    return [NSIndexPath indexPathForItem:indexPath.item + runningTotal inSection:0]; // TODO: section support
}

#pragma mark - MGChangingDataSource

- (id<MGDataSourceChangeNotifier>)changeNotifier
{
    if (!_changeNotifier)
    {
        self.changeNotifier = [[MGDataSourceChangeNotifier alloc] init];
    }
    return _changeNotifier;
}

#pragma mark - MGDataSource

- (NSUInteger)numberOfItems
{
    return [[_dataSources valueForKeyPath:@"@sum.numberOfItems"] unsignedIntegerValue];
}

- (NSUInteger)numberOfSections
{
    // Currently supports single-section mash-all-objects together goodness
    // section support to come as needed
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfItems;
}

- (id)itemAtIndex:(NSInteger)index
{
    NSUInteger runningTotal = 0;
    for (id <MGDataSource> dataSource in _dataSources)
    {
        if ((runningTotal + dataSource.numberOfItems) > index)
        {
            return [dataSource itemAtIndex:index - runningTotal];
        }
        runningTotal += dataSource.numberOfItems;
    }
    return nil; // TODO: should actually throw a range exception?
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"This datasource does not (yet) support sections");
    return [self itemAtIndex:indexPath.item];
}

- (void)reload
{
    [_dataSources makeObjectsPerformSelector:@selector(reload)];
}

#pragma mark - MGDataSourceChangeListener

#warning Potential issue here with multiple datasources changing at different times, but not a problem yet

- (void)dataSourceWillChange:(id<MGDataSource>)dataSource
{
    [_changeNotifier dataSourceWillChange:self];
}

- (void)dataSourceDidChange:(id<MGDataSource>)dataSource
{
    [_changeNotifier dataSourceDidChange:self];
}

- (void)dataSourceDidReload:(id<MGDataSource>)dataSource
{
    [_changeNotifier dataSourceDidReload:self];
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didInsertItemAtIndexPath:[self indexPathForDataSource:dataSource indexPath:indexPath]];
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didUpdateItemAtIndexPath:[self indexPathForDataSource:dataSource indexPath:indexPath]];
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didRemoveItemAtIndexPath:[self indexPathForDataSource:dataSource indexPath:indexPath]];
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

+ (instancetype)compositeDataSourceWithDataSources:(NSArray *)dataSources
{
    MGCompositeDataSource *dataSource = nil;
    @autoreleasepool
    {
        dataSource = [[MGCompositeDataSource alloc] initWithDataSources:dataSources];
    }
    return dataSource;
}

@end
