//
//  PDSSampleDataSource.m
//  Patch
//
//  Created by Adam Iredale on 13/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSSampleDataSource.h"

// TODO: This is pretty much a filter, but it's by index rather than object - see if a merge is possible

@implementation PDSSampleDataSource

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    self = [super initWithDataSource:dataSource];
    if (self)
    {
        // Set up the sample index maps
        __weak typeof(self) weakSelf = self;
        [self setForwardIndexMapBlock:^NSInteger(NSInteger index)
        {
            return [weakSelf indexFromSampleIndex:index];
        }];
        [self setForwardIndexPathMapBlock:^NSIndexPath *(NSIndexPath *indexPath)
         {
             // Only single sections currently supported
             return [NSIndexPath indexPathForItem:[weakSelf indexFromSampleIndex:indexPath.item] inSection:0];
         }];
        [self setReverseIndexMapBlock:^NSInteger(NSInteger index)
         {
             return [weakSelf sampleIndexFromIndex:index];
         }];
        [self setReverseIndexPathMapBlock:^NSIndexPath *(NSIndexPath *indexPath)
         {
             // Only single sections currently supported
             return [NSIndexPath indexPathForItem:[weakSelf sampleIndexFromIndex:indexPath.item] inSection:0];
         }];
    }
    return self;
}

#pragma mark - Accessors

- (void)setMaximumCount:(NSUInteger)maximumCount
{
    if (_maximumCount == maximumCount)
    {
        return;
    }
    _maximumCount = maximumCount;
    // TODO: this lazy-loads a bit early perhaps - refactor
    //[self.changeNotifier dataSourceWillChange:self];
    [self.changeNotifier dataSourceDidReload:self];
    //[self.changeNotifier dataSourceDidChange:self];
}

#pragma mark - Private

- (double)virtualIncrement
{
    // Map from the lesser or equal sample index to the actual index
    return PDSIndexMappingDelta(self.dataSource.numberOfItems - 1, self.numberOfItems - 1);
}

- (NSInteger)indexFromSampleIndex:(NSInteger)index
{
    return round([self virtualIncrement] * index);
}

- (NSInteger)sampleIndexFromIndex:(NSInteger)index
{
    return round((double)index / [self virtualIncrement]);
}

#pragma mark - PDSDataSource

- (NSUInteger)numberOfItems
{
    return (_maximumCount ? MIN(_maximumCount, self.dataSource.numberOfItems) : self.dataSource.numberOfItems);
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    // Only single sections currently supported
    NSAssert(section == 0, @"Only single section datasources are currently supported by this datasource");
    return self.numberOfItems;
}

#pragma mark - PDSDataSourceChangeListener

/**
 *  If there is any change to the underlying datasource, the datasource must, itself, completely
 *  recompute/reload. I'm sure there's a better way to do this, but for now, this is it.
 */

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    // Purposeful blank here
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    [self.changeNotifier dataSourceDidReload:self];
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    [self.changeNotifier dataSourceDidReload:self];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    // Purposeful blank here
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    // Purposeful blank here
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    // Purposeful blank here
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // Purposeful blank here
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // Purposeful blank here
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // Purposeful blank here
}

@end
