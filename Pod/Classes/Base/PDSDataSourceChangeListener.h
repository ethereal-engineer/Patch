//
//  PDSDataSourceChangeListener.h
//  Patch
//
//  Created by Adam Iredale on 5/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PatchProtocols.h"

/**
 *  A concrete object implementation of the listener protocol, with (optional) blocks for callbacks
 */

@interface PDSDataSourceChangeListener : NSObject <PDSDataSourceChangeListener>

@property (nonatomic, copy) void (^dataSourceWillChangeBlock)(id <PDSDataSource> dataSource);
@property (nonatomic, copy) void (^dataSourceDidChangeBlock)(id <PDSDataSource> dataSource);
@property (nonatomic, copy) void (^dataSourceDidReloadBlock)(id <PDSDataSource> dataSource);

@property (nonatomic, copy) void (^dataSourceWillStartLoadingBlock)(id <PDSDataSource> dataSource);
@property (nonatomic, copy) void (^dataSourceDidStopLoadingBlock)(id <PDSDataSource> dataSource, NSError *error);

@property (nonatomic, copy) void (^dataSourceDidInsertItemBlock)(id <PDSDataSource> dataSource, id item, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^dataSourceDidUpdateItemBlock)(id <PDSDataSource> dataSource, id item, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^dataSourceDidRemoveItemBlock)(id <PDSDataSource> dataSource, id item, NSIndexPath *indexPath);

// TODO: Sections

- (instancetype)initWithDataSource:(id <PDSChangingDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

/**
 *  @name Class Methods
 */

+ (instancetype)listenerForDataSource:(id <PDSChangingDataSource>)dataSource;

@end
