//
//  PDSCoreDataSource+PDSFilterableDataSource.m
//  Pods
//
//  Created by Adam Iredale on 22/04/2015.
//
//

#import "PDSCoreDataSource+PDSFilterableDataSource.h"

#pragma mark - Private Header

#import "PDSCoreDataSource+Private.h"

/**
 *  Non-optimised...FWIW - also, not core data thread-safe yet!
 */

@interface PDSCoreDataSource (PDSFilterableDataSource_Internal)

@end

@implementation PDSCoreDataSource (PDSFilterableDataSource)

#pragma mark - PDSFilterableDataSource

- (NSUInteger)numberOfItemsInSection:(NSInteger)section matchingPredicate:(NSPredicate *)predicate
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [[sectionInfo.objects filteredArrayUsingPredicate:predicate] count];
}

- (NSUInteger)numberOfItemsMatchingPredicate:(NSPredicate *)predicate
{
    return [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate] count];
}

- (id)filteredItemAtIndex:(NSInteger)index predicate:(NSPredicate *)predicate
{
    return [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate] objectAtIndex:index];
}

- (id)filteredItemAtIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    return [[sectionInfo.objects filteredArrayUsingPredicate:predicate] objectAtIndex:indexPath.item];
}

- (NSInteger)filteredIndexForItem:(id)item atUnfilteredIndex:(NSInteger)index predicate:(NSPredicate *)predicate
{
    return [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:predicate] indexOfObject:item];
}

- (NSIndexPath *)filteredIndexPathForItem:(id)item atUnfilteredIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate
{
    NSInteger index = [self filteredIndexForItem:item atUnfilteredIndex:NSNotFound predicate:predicate];
    if (index == NSNotFound)
    {
        return nil;
    }
    return [NSIndexPath indexPathForItem:index inSection:indexPath.section];
}

@end
