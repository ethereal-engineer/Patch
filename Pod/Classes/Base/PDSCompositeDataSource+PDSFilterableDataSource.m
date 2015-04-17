//
//  PDSCompositeDataSource+PDSFilterableDataSource.m
//  Pods
//
//  Created by Adam Iredale on 17/04/2015.
//
//

#import "PDSCompositeDataSource+PDSFilterableDataSource.h"

#pragma mark - Filtered DataSource

#import "PDSFilteredDataSource.h"

/**
 *  N.B. Currently non-optimised or memoized.
 */

@implementation PDSCompositeDataSource (PDSFilterableDataSource)

#pragma mark - PDSFilterableDataSource

- (NSUInteger)numberOfItemsInSection:(NSInteger)section matchingPredicate:(NSPredicate *)predicate
{
    // As the array datasource has only one section, this defaults to calling the single item call
    // This has to return a sum of all the items matching the predicate
    // For those that don't conform to filterable protocol, they remain unfiltered
    NSUInteger sum = 0;
    for (id <PDSDataSource> dataSource in self.dataSources)
    {
        id <PDSDataSource> filterableDataSource = [PDSFilteredDataSource filteredDataSourceWithDataSource:dataSource filter:predicate];
        sum += [filterableDataSource numberOfItemsInSection:section];
    }
    return sum;
}

- (NSUInteger)numberOfItemsMatchingPredicate:(NSPredicate *)predicate
{
    NSUInteger sum = 0;
    for (id <PDSDataSource> dataSource in self.dataSources)
    {
        id <PDSDataSource> filterableDataSource = [PDSFilteredDataSource filteredDataSourceWithDataSource:dataSource filter:predicate];
        sum += [filterableDataSource numberOfItems];
    }
    return sum;
}

- (id)filteredItemAtIndex:(NSInteger)index predicate:(NSPredicate *)predicate
{
    // This will have to step through each datasource, finding their sum of filtered items
    // to know where to find the item at the required index. Of course, we will memoise this.
    NSUInteger sum = 0;
    for (id <PDSDataSource> dataSource in self.dataSources)
    {
        id <PDSDataSource> filterableDataSource = [PDSFilteredDataSource filteredDataSourceWithDataSource:dataSource filter:predicate];
        NSUInteger count = [filterableDataSource numberOfItems];
        
        if (sum + count >= index + 1)
        {
            // It's in this datasource
            NSInteger translatedIndex = index - sum;
            return [filterableDataSource itemAtIndex:translatedIndex];
        }
        sum += count;
    }
    return nil;
}

- (id)filteredItemAtIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate
{
    // This will have to step through each datasource, finding their sum of filtered items
    // to know where to find the item at the required index. Of course, we will memoise this.
    NSUInteger sum = 0;
    for (id <PDSDataSource> dataSource in self.dataSources)
    {
        id <PDSDataSource> filterableDataSource = [PDSFilteredDataSource filteredDataSourceWithDataSource:dataSource filter:predicate];
        NSUInteger count = [filterableDataSource numberOfItemsInSection:indexPath.section];
        
        if (sum + count >= indexPath.item + 1)
        {
            // It's in this datasource
            NSInteger translatedIndex = indexPath.item - sum;
            NSIndexPath *translatedIndexPath = [NSIndexPath indexPathForItem:translatedIndex inSection:indexPath.section];
            return [filterableDataSource itemAtIndexPath:translatedIndexPath];
        }
        sum += count;
    }
    return nil;
}

@end
