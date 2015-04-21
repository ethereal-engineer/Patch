//
//  PDSTableViewDataSource.h
//  Patch
//
//  Created by Adam Iredale on 21/04/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PatchProtocols.h"

/**
 *  Datasource adapter from generic datasource to UITableViewDataSource. Allows Patch to automatically
 *  manage all your table view row accounting and so on
 */

@interface PDSTableViewDataSource : NSObject <UITableViewDataSource, PDSDataSourceChangeListener>

/**
 *  Represents UITableViewDataSource protocol's -tableView:cellForRowAtIndexPath: call, with the addition of
 *  the data item at that index path
 */
@property (nonatomic, copy) UITableViewCell *(^cellAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath, id itemAtIndexPath);
/**
 *  Represents UITableViewDataSource protocol's -tableView:titleForHeaderInSection: call, with the addition of an array
 *  of items in the section, from which to derive the title
 */
@property (nonatomic, copy) NSString *(^titleForHeaderInSectionBlock)(UITableView *tableView, NSInteger section, NSArray *sectionItems);
/**
 *  Directly translates to the property with which the tableview animation style for updates will be used.
 *  Defaults to UITableViewRowAnimationAutomatic.
 */
@property (nonatomic, assign) UITableViewRowAnimation rowUpdateAnimationStyle;
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

@interface PDSTableViewDataSource (ReadOnly)

@property (nonatomic, readonly) id <PDSDataSource> dataSource;

@end