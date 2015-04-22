//
//  PDSFilteredDataSource.m
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSFilteredDataSource.h"

@interface PDSFilteredDataSource () <PDSDataSourceChangeListener>

@end

@implementation PDSFilteredDataSource

#pragma mark - Init

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    NSParameterAssert([dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)]);
    self = [self initWithDataSource:(id <PDSFilterableDataSource>)dataSource filter:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithDataSource:(id <PDSFilterableDataSource>)dataSource filter:(NSPredicate *)filter
{
    self = [super initWithDataSource:dataSource];
    if (self)
    {
        self.filter     = filter;
        // If a filter is not specified, turn off filtering initially
        self.filtered   = (filter != nil);
    }
    return self;
}

#pragma mark - Private

- (NSPredicate *)activePredicate
{
    NSAssert(_filtered == NO || _filter != nil, @"A filter must be set");
    return (_filtered ? _filter : [NSPredicate predicateWithValue:YES]);
}

#pragma mark - PDSDataSource

- (NSUInteger)numberOfItems
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        return [super numberOfItems];
    }
    return [(id<PDSFilterableDataSource>)self.dataSource numberOfItemsMatchingPredicate:[self activePredicate]];
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        return [super numberOfItemsInSection:section];
    }
    return [(id<PDSFilterableDataSource>)self.dataSource numberOfItemsInSection:section matchingPredicate:[self activePredicate]];
}

- (id)itemAtIndex:(NSInteger)index
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        return [super itemAtIndex:index];
    }
    return [(id<PDSFilterableDataSource>)self.dataSource filteredItemAtIndex:index predicate:[self activePredicate]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        return [super itemAtIndexPath:indexPath];
    }
    return [(id<PDSFilterableDataSource>)self.dataSource filteredItemAtIndexPath:indexPath predicate:[self activePredicate]];
}

#pragma mark - PDSDataSourceChangeListener

//- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
//{
//    
//}
//
//- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
//{
//    
//}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        [super dataSource:dataSource didInsertItem:item atIndexPath:indexPath];
        return;
    }

    NSIndexPath *filteredIndexPath = [(id<PDSFilterableDataSource>)self.dataSource filteredIndexPathForItem:item atUnfilteredIndexPath:indexPath];
    if (filteredIndexPath)
    {
        [super dataSource:dataSource didInsertItem:item atIndexPath:filteredIndexPath];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        [super dataSource:dataSource didRemoveItem:item atIndexPath:indexPath];
    }
    
    NSIndexPath *filteredIndexPath = [(id<PDSFilterableDataSource>)self.dataSource filteredIndexPathForItem:item atUnfilteredIndexPath:indexPath];
    if (filteredIndexPath)
    {
        [super dataSource:dataSource didRemoveItem:item atIndexPath:filteredIndexPath];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    if (![self.dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)])
    {
        [super dataSource:dataSource didUpdateItem:item atIndexPath:indexPath];
    }
    
    NSIndexPath *filteredIndexPath = [(id<PDSFilterableDataSource>)self.dataSource filteredIndexPathForItem:item atUnfilteredIndexPath:indexPath];
    if (filteredIndexPath)
    {
        [super dataSource:dataSource didUpdateItem:item atIndexPath:filteredIndexPath];
    }
}

// TODO: Section Support

#pragma mark - Class Methods

+ (instancetype)filteredDataSourceWithDataSource:(id<PDSFilterableDataSource>)dataSource filter:(NSPredicate *)filter
{
    PDSFilteredDataSource *filteredDataSource = nil;
    @autoreleasepool
    {
        filteredDataSource = [[PDSFilteredDataSource alloc] initWithDataSource:dataSource filter:filter];
    }
    return filteredDataSource;
}

@end
