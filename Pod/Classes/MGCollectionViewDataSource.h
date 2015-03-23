//
//  MGCollectionViewDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Datasource adapter from generic datasource to UICollectionViewDataSource
 */

@interface MGCollectionViewDataSource : NSObject <UICollectionViewDataSource, MGDataSourceChangeListener>

@end

@interface MGCollectionViewDataSource (ReadOnly)

@property (nonatomic, readonly) id <MGDataSource> dataSource;

@end