//
//  PDSReverseDataSource.m
//  Patch
//
//  Created by Adam Iredale on 29/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSReverseDataSource.h"

@implementation PDSReverseDataSource

#pragma mark - Private

- (NSInteger)reverseIndex:(NSInteger)index
{
    return self.numberOfItems - index - 1;
}

- (NSInteger)reverseSection:(NSInteger)section
{
    return self.numberOfSections - section - 1;
}

- (NSIndexPath *)reverseIndexPath:(NSIndexPath *)indexPath
{
    NSInteger reverseSection = [self reverseSection:indexPath.section];
    NSInteger numberOfItemsInReverseSection = [super numberOfItemsInSection:reverseSection];
    return [NSIndexPath indexPathForItem:numberOfItemsInReverseSection - indexPath.item - 1 inSection:reverseSection];
}

#pragma mark - Overrides

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return [super numberOfItemsInSection:[self reverseSection:section]];
}

- (id)itemAtIndex:(NSInteger)index
{
    return [super itemAtIndex:[self reverseIndex:index]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super itemAtIndexPath:[self reverseIndexPath:indexPath]];
}

#pragma mark - PDSChangingDataSource

//- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [super dataSource:dataSource didInsertItemAtIndexPath:[self reverseIndexPath:indexPath]];
//}
//
//- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_changeNotifier dataSource:self didUpdateItemAtIndexPath:indexPath];
//}
//
//- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_changeNotifier dataSource:self didRemoveItemAtIndexPath:indexPath];
//}


@end
