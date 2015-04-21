//
//  PatchProtocols.h
//
//  Created by Adam Iredale on 23/03/2015.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Generic datasource protocol
 */

@protocol PDSDataSource <NSObject>
/**
 *  Number of sections in the datasource
 */
@property (nonatomic, readonly) NSUInteger numberOfSections;
/**
 *  Total number of items in the datasource (irrespective of sections)
 */
@property (nonatomic, readonly) NSUInteger numberOfItems;
/**
 *  Return the item at the given index, irrespective of sections
 *
 *  @param index Index within the datasource's bounds
 *
 *  @return Data item at the index
 */
- (id)itemAtIndex:(NSInteger)index;
/**
 *  Return the item at the given index path
 *
 *  @param indexPath Index path with valid index and section
 *
 *  @return Data item at the index path
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  Returns an array of items in a given section
 *
 *  @param section Index of section
 *
 *  @return An array of items contained in this section
 */
- (NSArray *)itemsInSection:(NSUInteger)section;
/**
 *  Return the number of items in the given section
 *
 *  @param section Section index
 *
 *  @return Number of items in the section
 */
- (NSUInteger)numberOfItemsInSection:(NSInteger)section;
/**
 *  Ask the datasource to requery its source (e.g. Core Data)
 */
- (void)reload;

@end

@protocol PDSFilterableDataSource <PDSDataSource>

- (NSUInteger)numberOfItemsMatchingPredicate:(NSPredicate *)predicate;
- (id)filteredItemAtIndex:(NSInteger)index predicate:(NSPredicate *)predicate;
- (id)filteredItemAtIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate;
- (NSUInteger)numberOfItemsInSection:(NSInteger)section matchingPredicate:(NSPredicate *)predicate;

@end

@protocol PDSDataSourceChangeNotifier;

/**
 *  Protocol that indicates that the datasource is of the changing kind, and hence has a change
 *  notifier.
 */
@protocol PDSChangingDataSource <PDSDataSource>
/**
 *  Change notifier object for informing observers (conforming to PDSDataSourceChangeListener) of
 *  datasource changes
 */
@property (nonatomic, readonly) id <PDSDataSourceChangeNotifier> changeNotifier;

@end

/**
 *  Change listeners must conform to this protocol to receive change notifications from a
 *  change notifier
 */
@protocol PDSDataSourceChangeListener <NSObject>
/**
 *  This will be called before any changes to the datasource data
 *
 *  @param dataSource Datasource
 */
- (void)dataSourceWillChange:(id <PDSDataSource>)dataSource;
/**
 *  This will be called after changes to the datasource data
 *
 *  @param dataSource Datasource
 */
- (void)dataSourceDidChange:(id <PDSDataSource>)dataSource;
/**
 *  The entire datasource reloaded
 *
 *  @param dataSource Datasource
 */
- (void)dataSourceDidReload:(id <PDSDataSource>)dataSource;
/**
 *  The datasource inserted an item
 *
 *  @param dataSource Datasource
 *  @param indexPath  IndexPath of the item
 */
- (void)dataSource:(id <PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The datasource removed an item
 *
 *  @param dataSource Datasource
 *  @param indexPath  IndexPath of the item
 */
- (void)dataSource:(id <PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The datasource updated an item
 *
 *  @param dataSource Datasource
 *  @param indexPath  IndexPath of the item
 */
- (void)dataSource:(id <PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The datasource inserted a section
 *
 *  @param dataSource Datasource
 *  @param indexPath  Index of the section
 */
- (void)dataSource:(id <PDSDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index;
/**
 *  The datasource removed a section
 *
 *  @param dataSource Datasource
 *  @param indexPath  Index of the section
 */
- (void)dataSource:(id <PDSDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index;
/**
 *  The datasource updated a section
 *
 *  @param dataSource Datasource
 *  @param indexPath  Index of the section
 */
- (void)dataSource:(id <PDSDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index;

@end

/**
 *  The change notifier accepts any number of listeners and informs them when the attached
 *  datasource data changes
 */
@protocol PDSDataSourceChangeNotifier <PDSDataSourceChangeListener>
/**
 *  Add a change listener
 *
 *  Note that all listeners are weakly retained, so don't have to be explicitly removed
 *
 *  @param listener Listener
 */
- (void)addChangeListener:(id <PDSDataSourceChangeListener>)listener;
/**
 *  Remove a change listener
 *
 *  @param listener Listener
 */
- (void)removeChangeListener:(id <PDSDataSourceChangeListener>)listener;
/**
 *  Removes ALL change listeners
 */
- (void)removeAllChangeListeners;

@end
