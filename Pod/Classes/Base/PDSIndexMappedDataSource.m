//
//  PDSIndexMappedDataSource.m
//  Patch
//
//  Created by Adam Iredale on 13/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSIndexMappedDataSource.h"

#pragma mark - CocoaLumberjack

@implementation PDSIndexMappedDataSource

- (NSInteger)forwardMappedIndexFromIndex:(NSInteger)index
{
    NSInteger forwardMappedIndex = index;
    if (_forwardIndexMapBlock)
    {
        forwardMappedIndex = _forwardIndexMapBlock(index);
    }
    return forwardMappedIndex;
}

- (NSInteger)reverseMappedIndexFromIndex:(NSInteger)index
{
    NSInteger reverseMappedIndex = index;
    if (_reverseIndexMapBlock)
    {
        reverseMappedIndex = _reverseIndexMapBlock(index);
    }
    return reverseMappedIndex;
}

- (NSInteger)forwardMappedSectionFromSection:(NSInteger)section
{
    NSInteger forwardMappedSection = section;
    if (_forwardSectionMapBlock)
    {
        forwardMappedSection = _forwardSectionMapBlock(section);
    }
    return forwardMappedSection;
}

- (NSInteger)reverseMappedSectionFromSection:(NSInteger)section
{
    NSInteger reverseMappedSection = section;
    if (_reverseSectionMapBlock)
    {
        reverseMappedSection = _reverseSectionMapBlock(section);
    }
    return reverseMappedSection;
}

- (NSIndexPath *)forwardMappedIndexPathFromIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *forwardMappedIndexPath = indexPath;
    if (_forwardIndexPathMapBlock)
    {
        forwardMappedIndexPath = _forwardIndexPathMapBlock(indexPath);
    }
    return forwardMappedIndexPath;
}

- (NSIndexPath *)reverseMappedIndexPathFromIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *reverseMappedIndexPath = indexPath;
    if (_reverseIndexPathMapBlock)
    {
        reverseMappedIndexPath = _reverseIndexPathMapBlock(indexPath);
    }
    return reverseMappedIndexPath;
}

#pragma mark - PDSDataSource

- (id)itemAtIndex:(NSInteger)index
{
    return [self.dataSource itemAtIndex:[self forwardMappedIndexFromIndex:index]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource itemAtIndexPath:[self forwardMappedIndexPathFromIndexPath:indexPath]];
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfItemsInSection:[self forwardMappedSectionFromSection:section]];
}

#pragma mark - PDSDataSourceChangeListener

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super dataSource:self didInsertItemAtIndexPath:[self reverseMappedIndexPathFromIndexPath:indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super dataSource:self didUpdateItemAtIndexPath:[self reverseMappedIndexPathFromIndexPath:indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super dataSource:self didRemoveItemAtIndexPath:[self reverseMappedIndexPathFromIndexPath:indexPath]];
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

@end
