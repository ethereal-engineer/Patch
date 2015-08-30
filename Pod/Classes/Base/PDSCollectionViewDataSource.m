//
//  PDSCollectionViewDataSource.m
//  Patch
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSCollectionViewDataSource.h"

@interface PDSCollectionViewDataSource ()

/**
 *  Redefine Read Onlys
 */
@property (nonatomic, strong) id <PDSDataSource> dataSource;
/**
 *  Keep a weak reference to the collection view to manage updates,
 *  refreshes and reloads
 */
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation PDSCollectionViewDataSource

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithDataSource:nil];
    if (self)
    {
        // This will always fail. Please use designated init. In a later version, I'm looking at
        // supporting changing the adapter's datasource dynamically, but this is how it is for v1.
    }
    return self;
}

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    self = [super init];
    if (self)
    {
        _dataSource = dataSource;
        // Subscribe to changes if possible
        if ([dataSource conformsToProtocol:@protocol(PDSChangingDataSource)])
        {
            [[(id <PDSChangingDataSource>)dataSource changeNotifier] addChangeListener:self];
        }
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // Sneaky weakref taken here
    self.collectionView = collectionView;
    return _dataSource.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.cellAtIndexPathBlock);
    return self.cellAtIndexPathBlock(collectionView, indexPath, [self.dataSource itemAtIndexPath:indexPath]);
}

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    // !!!
    // Later we may group these changes and perform them all in sync with will/did
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    // !!!
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    [self.collectionView reloadData];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSection:(id)sectionInfo atIndex:(NSInteger)index
{
    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:index]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSection:(id)sectionInfo atIndex:(NSInteger)index
{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:index]];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSection:(id)sectionInfo atIndex:(NSInteger)index
{
    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:index]];
}

#pragma mark - Class Convenience

+ (instancetype)dataSourceWithDataSource:(id<PDSDataSource>)dataSource
{
    PDSCollectionViewDataSource *collectionViewDataSource = nil;
    @autoreleasepool
    {
        collectionViewDataSource = [[PDSCollectionViewDataSource alloc] initWithDataSource:dataSource];
    }
    return collectionViewDataSource;
}


@end
