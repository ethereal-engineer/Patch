//
//  MGCollectionViewDataSource.m
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGCollectionViewDataSource.h"

@interface MGCollectionViewDataSource ()

/**
 *  Redefine Read Onlys
 */
@property (nonatomic, strong) id <MGDataSource> dataSource;

@end

@implementation MGCollectionViewDataSource

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataSource.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - MGDataSourceChangeListener

- (void)dataSourceWillChange:(id<MGDataSource>)dataSource
{
    
}

- (void)dataSourceDidChange:(id<MGDataSource>)dataSource
{
    
}

- (void)dataSourceDidReload:(id<MGDataSource>)dataSource
{
    
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
   
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
   
}

@end
