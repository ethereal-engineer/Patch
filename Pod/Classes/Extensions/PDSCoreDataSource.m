//
//  PDSCoreDataSource.m
//  Patch
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

@import CoreData;

#import "PDSCoreDataSource.h"

#pragma mark - Composites

#import "PDSDataSourceChangeNotifier.h"

@interface PDSCoreDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) id <PDSDataSourceChangeNotifier> changeNotifier;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PDSCoreDataSource

#pragma mark - Init

- (instancetype)init
{
    // Will always fail - please use designated init instead
    self = [self initWithEntityName:nil sortDescriptors:nil andContext:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithEntityName:(NSString *)name sortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(name.length > 0);
    NSParameterAssert(sortDescriptors.count > 0);
    NSParameterAssert(context != nil);
    
    self = [super init];
    if (self)
    {
        self.context        = context;
        self.fetchRequest   = [NSFetchRequest fetchRequestWithEntityName:name];
        
        _fetchRequest.sortDescriptors = sortDescriptors;
    }
    return self;
}

#pragma mark - Accessors

- (NSPredicate *)fetchPredicate
{
    return _fetchRequest.predicate;
}

- (void)setFetchPredicate:(NSPredicate *)fetchPredicate
{
    _fetchRequest.predicate = fetchPredicate;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        // TODO: Revise this at a later stage for section use and caching for performance as needed
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:_fetchRequest
                                                                            managedObjectContext:_context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        _fetchedResultsController.delegate = self;
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error])
        {
#warning Error handling
            //DDLogError(@"Core Data fetch failed for %@ with error: %@", _fetchRequest, error);
        }
    }
    return _fetchedResultsController;
}

#pragma mark - PDSDataSource

- (NSUInteger)numberOfItems
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSUInteger)numberOfSections
{
    return self.fetchedResultsController.sections.count;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (id)itemAtIndex:(NSInteger)index
{
    return _fetchedResultsController.fetchedObjects[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)reload
{
    // Relies on dependants to trigger re-population lazily
    self.fetchedResultsController = nil;
    [_changeNotifier dataSourceDidReload:self];
}

#pragma mark - PDSChangingDataSource

- (id<PDSDataSourceChangeNotifier>)changeNotifier
{
    if (!_changeNotifier)
    {
        self.changeNotifier = [[PDSDataSourceChangeNotifier alloc] init];
    }
    return _changeNotifier;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_changeNotifier dataSourceWillChange:self];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_changeNotifier dataSourceDidChange:self];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [_changeNotifier dataSource:self didInsertItemAtIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [_changeNotifier dataSource:self didRemoveItemAtIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [_changeNotifier dataSource:self didRemoveItemAtIndexPath:indexPath];
            [_changeNotifier dataSource:self didInsertItemAtIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            [_changeNotifier dataSource:self didUpdateItemAtIndexPath:indexPath];
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [_changeNotifier dataSource:self didInsertSectionAtIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeDelete:
            [_changeNotifier dataSource:self didRemoveSectionAtIndex:sectionIndex];
            break;
        case NSFetchedResultsChangeMove:
            //
            break;
        case NSFetchedResultsChangeUpdate:
            [_changeNotifier dataSource:self didUpdateSectionAtIndex:sectionIndex];
            break;
        default:
            break;
    }
}

#pragma mark - Class Methods

+ (instancetype)dataSourceWithEntityName:(NSString *)name sortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)context
{
    PDSCoreDataSource *dataSource = nil;
    @autoreleasepool
    {
        dataSource = [[PDSCoreDataSource alloc] initWithEntityName:name sortDescriptors:sortDescriptors andContext:context];
    }
    return dataSource;
}

+ (instancetype)dataSourceWithEntityName:(NSString *)name sortDescriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)context
{
    PDSCoreDataSource *dataSource = [self dataSourceWithEntityName:name sortDescriptors:sortDescriptors andContext:context];
    dataSource.fetchPredicate = predicate;
    return dataSource;
}

@end
