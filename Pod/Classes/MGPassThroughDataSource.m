//
//  MGPassThroughDataSource.m
//  Mytograph
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGPassThroughDataSource.h"

#pragma mark - Composites

#import "MGDataSourceChangeNotifier.h"

@interface MGPassThroughDataSource ()

/**
 *  Redefine Read-Only Properties
 */

@property (nonatomic, strong) id <MGDataSourceChangeNotifier> changeNotifier;
@property (nonatomic, strong) id <MGDataSource> dataSource;

@end

@implementation MGPassThroughDataSource

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithDataSource:nil];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithDataSource:(id<MGDataSource>)dataSource
{
    self = [super init];
    if (self)
    {
        self.dataSource = dataSource;
    }
    return self;
}

#pragma mark - Private

- (MGDataSourceChangeNotifier *)dataSourceChangeNotifierOrNil
{
    if ([_dataSource conformsToProtocol:@protocol(MGChangingDataSource)])
    {
        return [(id <MGChangingDataSource>)_dataSource changeNotifier];
    }
    return nil;
}

#pragma mark - Accessors

- (void)setDataSource:(id<MGDataSource>)dataSource
{
    if (_dataSource)
    {
        [[self dataSourceChangeNotifierOrNil] removeChangeListener:self];
    }
    _dataSource = dataSource;
    if (_dataSource)
    {
        [[self dataSourceChangeNotifierOrNil] addChangeListener:self];
    }
    // Send notice of complete reload
    //[_changeNotifier dataSourceWillChange:self];
    [_changeNotifier dataSourceDidReload:self];
    //[_changeNotifier dataSourceDidChange:self];
}

#pragma mark - MGChangingDataSource

- (id<MGDataSourceChangeNotifier>)changeNotifier
{
    if (!_changeNotifier)
    {
        self.changeNotifier = [[MGDataSourceChangeNotifier alloc] init];
    }
    return _changeNotifier;
}

#pragma mark - MGDataSource

- (NSUInteger)numberOfItems
{
    return _dataSource.numberOfItems;
}

- (NSUInteger)numberOfSections
{
    return _dataSource.numberOfSections;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource numberOfItemsInSection:section];
}

- (id)itemAtIndex:(NSInteger)index
{
    return [_dataSource itemAtIndex:index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource itemAtIndexPath:indexPath];
}

- (void)reload
{
    [_dataSource reload];
}

// TODO: Refactor all this copy-paste boilerplate

#pragma mark - MGDataSourceChangeListener

- (void)dataSourceWillChange:(id<MGDataSource>)dataSource
{
    [_changeNotifier dataSourceWillChange:self];
}

- (void)dataSourceDidChange:(id<MGDataSource>)dataSource
{
    [_changeNotifier dataSourceDidChange:self];
}

- (void)dataSourceDidReload:(id<MGDataSource>)dataSource
{
    [_changeNotifier dataSourceDidReload:self];
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didInsertItemAtIndexPath:indexPath];
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didUpdateItemAtIndexPath:indexPath];
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didRemoveItemAtIndexPath:indexPath];
}

- (void)dataSource:(id<MGDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<MGDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<MGDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    // TODO
}

#pragma mark - Class Methods

+ (instancetype)dataSourceWithDataSource:(id<MGDataSource>)dataSource
{
    MGPassThroughDataSource *autoDataSource = nil;
    @autoreleasepool
    {
        autoDataSource = [[[self class] alloc] initWithDataSource:dataSource];
    }
    return autoDataSource;
}

@end
