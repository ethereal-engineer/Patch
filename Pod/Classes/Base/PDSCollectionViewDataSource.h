//
//  PDSCollectionViewDataSource.h
//  Patch
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Datasource adapter from generic datasource to UICollectionViewDataSource
 */

#import "PatchProtocols.h"

@interface PDSCollectionViewDataSource : NSObject <UICollectionViewDataSource, PDSDataSourceChangeListener>
/**
 *  Represents UICollectionViewDataSource protocol's -collectionView:cellForItemAtIndexPath: call, with the addition of
 *  the data item at that index path
 */
@property (nonatomic, copy) UICollectionViewCell *(^cellAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath *indexPath, id itemAtIndexPath);
/**
 *  Designated initializer
 *
 *  @param dataSource PDSDataSource upon which this table datasource relies
 *
 *  @return An instance of PDSTableViewDataSource
 */
- (instancetype)initWithDataSource:(id <PDSDataSource>)dataSource NS_DESIGNATED_INITIALIZER;
/**
 *  Convenience initializer
 */
+ (instancetype)dataSourceWithDataSource:(id <PDSDataSource>)dataSource;

@end

@interface PDSCollectionViewDataSource (ReadOnly)

@property (nonatomic, readonly) id <PDSDataSource> dataSource;

@end