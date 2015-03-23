//
//  MGDataSourceChangeNotifier.m
//  Mytograph
//
//  Created by Adam Iredale on 4/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGDataSourceChangeNotifier.h"

@interface MGDataSourceChangeNotifier ()
/**
 *  Weak references to listeners
 */
@property (nonatomic, strong) NSHashTable *listeners;

@end

@implementation MGDataSourceChangeNotifier

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.listeners = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - MGDataSourceChangeNotifier

- (void)addChangeListener:(id <MGDataSourceChangeListener>)listener
{
    [_listeners addObject:listener];
}

- (void)removeChangeListener:(id <MGDataSourceChangeListener>)listener
{
    [_listeners removeObject:listener];
}

- (void)removeAllChangeListeners
{
    [_listeners removeAllObjects];
}

#pragma mark - MGDataSourceChangeListener

// So much boilerplate... surely there is a nicer way (aside from Swift, yes)

- (void)dataSourceWillChange:(id<MGDataSource>)dataSource
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSourceWillChange:dataSource];
    }
}

- (void)dataSourceDidChange:(id<MGDataSource>)dataSource
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSourceDidChange:dataSource];
    }
}

- (void)dataSourceDidReload:(id<MGDataSource>)dataSource
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSourceDidReload:dataSource];
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didInsertItemAtIndexPath:indexPath];
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didRemoveItemAtIndexPath:indexPath];
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didUpdateItemAtIndexPath:indexPath];
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didInsertSectionAtIndex:index];
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didUpdateSectionAtIndex:index];
    }
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    for (id <MGDataSourceChangeListener> listener in _listeners)
    {
        [listener dataSource:dataSource didRemoveSectionAtIndex:index];
    }
}

@end
