//
//  PDSArrayDataSource+PDSFilterableDataSource.m
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSArrayDataSource+PDSFilterableDataSource.h"

/**
 *  The non-optimised version FYI
 */

@implementation PDSArrayDataSource (PDSFilterableDataSource)

- (NSUInteger)numberOfItemsInSection:(NSInteger)section matchingPredicate:(NSPredicate *)predicate
{
    // As the array datasource has only one section, this defaults to calling the single item call
    return [self numberOfItemsMatchingPredicate:predicate];
}

- (NSUInteger)numberOfItemsMatchingPredicate:(NSPredicate *)predicate
{
    return [[self.array filteredArrayUsingPredicate:predicate] count];
}

- (id)filteredItemAtIndex:(NSInteger)index predicate:(NSPredicate *)predicate
{
    return [[self.array filteredArrayUsingPredicate:predicate] objectAtIndex:index];
}

- (id)filteredItemAtIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate
{
    // As the array datasource has only one section, this defaults to calling the single item call
    return [self filteredItemAtIndex:indexPath.item predicate:predicate];
}

- (NSInteger)filteredIndexForItem:(id)item atUnfilteredIndex:(NSInteger)index predicate:(NSPredicate *)predicate
{
    return [[self.array filteredArrayUsingPredicate:predicate] indexOfObject:item];
}

- (NSIndexPath *)filteredIndexPathForItem:(id)item atUnfilteredIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate
{
    // Array has only one section, so it's the same as above
    NSInteger index = [self filteredIndexForItem:item atUnfilteredIndex:indexPath.item predicate:predicate];
    if (index == NSNotFound)
    {
        return nil;
    }
    return [NSIndexPath indexPathForItem:index inSection:0];
}

@end
