//
//  MGDataSourceChangeListener.h
//  Mytograph
//
//  Created by Adam Iredale on 5/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  A concrete object implementation of the listener protocol, with (optional) blocks for callbacks
 */

@interface MGDataSourceChangeListener : NSObject <MGDataSourceChangeListener>

@property (nonatomic, copy) void (^dataSourceWillChangeBlock)(id <MGDataSource> dataSource);
@property (nonatomic, copy) void (^dataSourceDidChangeBlock)(id <MGDataSource> dataSource);
@property (nonatomic, copy) void (^dataSourceDidReloadBlock)(id <MGDataSource> dataSource);

@property (nonatomic, copy) void (^dataSourceDidInsertItemBlock)(id <MGDataSource> dataSource, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^dataSourceDidUpdateItemBlock)(id <MGDataSource> dataSource, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^dataSourceDidRemoveItemBlock)(id <MGDataSource> dataSource, NSIndexPath *indexPath);

// TODO: Sections

- (instancetype)initWithDataSource:(id <MGChangingDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

/**
 *  @name Class Methods
 */

+ (instancetype)listenerForDataSource:(id <MGChangingDataSource>)dataSource;

@end
