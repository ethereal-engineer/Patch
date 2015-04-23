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

@end

@implementation PDSCollectionViewDataSource

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

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSection:(id)sectionInfo atIndex:(NSInteger)index
{
    
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSection:(id)sectionInfo atIndex:(NSInteger)index
{
   
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSection:(id)sectionInfo atIndex:(NSInteger)index
{
   
}

@end
