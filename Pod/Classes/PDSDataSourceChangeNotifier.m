//
//  PDSDataSourceChangeNotifier.m
//  Patch
//
//  Created by Adam Iredale on 4/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSDataSourceChangeNotifier.h"

@interface PDSDataSourceChangeNotifier ()
/**
 *  Weak references to listeners
 */
@property (nonatomic, strong) NSHashTable *listeners;

@end

@implementation PDSDataSourceChangeNotifier

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.listeners = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - PDSDataSourceChangeNotifier

- (void)addChangeListener:(id <PDSDataSourceChangeListener>)listener
{
    [_listeners addObject:listener];
}

- (void)removeChangeListener:(id <PDSDataSourceChangeListener>)listener
{
    [_listeners removeObject:listener];
}

- (void)removeAllChangeListeners
{
    [_listeners removeAllObjects];
}

#pragma mark - PDSDataSourceChangeListener

// So much boilerplate... surely there is a nicer way (aside from Swift, yes)

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSourceWillChange:dataSource];
    }
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSourceDidChange:dataSource];
    }
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSourceDidReload:dataSource];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didInsertItemAtIndexPath:indexPath];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didRemoveItemAtIndexPath:indexPath];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didUpdateItemAtIndexPath:indexPath];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didInsertSectionAtIndex:index];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didUpdateSectionAtIndex:index];
    }
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    for (id <PDSDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didRemoveSectionAtIndex:index];
    }
}

@end
