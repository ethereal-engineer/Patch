//
//  PDSIndexMappedDataSource.m
//  Patch
//
//  Created by Adam Iredale on 13/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSIndexMappedDataSource.h"

// TODO: Integrate this with the filtered datasource system

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

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [super dataSource:self didInsertItem:item atIndexPath:[self reverseMappedIndexPathFromIndexPath:indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [super dataSource:self didUpdateItem:item atIndexPath:[self reverseMappedIndexPathFromIndexPath:indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [super dataSource:self didRemoveItem:item atIndexPath:[self reverseMappedIndexPathFromIndexPath:indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // TODO
}

@end
