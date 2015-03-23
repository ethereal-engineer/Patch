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

@interface PDSCollectionViewDataSource : NSObject <UICollectionViewDataSource, PDSDataSourceChangeListener>

@end

@interface PDSCollectionViewDataSource (ReadOnly)

@property (nonatomic, readonly) id <PDSDataSource> dataSource;

@end