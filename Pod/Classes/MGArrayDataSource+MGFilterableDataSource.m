//
//  MGArrayDataSource+MGFilterableDataSource.m
//  Mytograph
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGArrayDataSource+MGFilterableDataSource.h"

/**
 *  The non-optimised version FYI
 */

@implementation MGArrayDataSource (MGFilterableDataSource)

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

@end
