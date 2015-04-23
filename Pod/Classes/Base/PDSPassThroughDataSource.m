//
//  PDSPassThroughDataSource.m
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSPassThroughDataSource.h"

#pragma mark - Composites

#import "PDSDataSourceChangeNotifier.h"

@interface PDSPassThroughDataSource ()

/**
 *  Redefine Read-Only Properties
 */

@property (nonatomic, strong) id <PDSDataSourceChangeNotifier> changeNotifier;
@property (nonatomic, strong) id <PDSDataSource> dataSource;

@end

@implementation PDSPassThroughDataSource

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithDataSource:nil];
    if (self)
    {
    }
    return self;
}

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    self = [super init];
    if (self)
    {
        self.dataSource = dataSource;
    }
    return self;
}

#pragma mark - Private

- (PDSDataSourceChangeNotifier *)dataSourceChangeNotifierOrNil
{
    if ([_dataSource conformsToProtocol:@protocol(PDSChangingDataSource)])
    {
        return [(id <PDSChangingDataSource>)_dataSource changeNotifier];
    }
    return nil;
}

#pragma mark - Accessors

- (void)setDataSource:(id<PDSDataSource>)dataSource
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

#pragma mark - PDSChangingDataSource

- (id<PDSDataSourceChangeNotifier>)changeNotifier
{
    if (!_changeNotifier)
    {
        self.changeNotifier = [[PDSDataSourceChangeNotifier alloc] init];
    }
    return _changeNotifier;
}

#pragma mark - PDSDataSource

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

- (NSArray *)itemsInSection:(NSUInteger)section
{
    return [_dataSource itemsInSection:section];
}

- (void)reload
{
    [_dataSource reload];
}

// TODO: Refactor all this copy-paste boilerplate

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    [_changeNotifier dataSourceWillChange:self];
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    [_changeNotifier dataSourceDidChange:self];
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    [_changeNotifier dataSourceDidReload:self];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didInsertItem:item atIndexPath:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didUpdateItem:item atIndexPath:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    [_changeNotifier dataSource:self didRemoveItem:item atIndexPath:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSection:(id)sectionInfo atIndex:(NSInteger)index
{
    // TODO
}

#pragma mark - Class Methods

+ (instancetype)dataSourceWithDataSource:(id<PDSDataSource>)dataSource
{
    PDSPassThroughDataSource *autoDataSource = nil;
    @autoreleasepool
    {
        autoDataSource = [[[self class] alloc] initWithDataSource:dataSource];
    }
    return autoDataSource;
}

@end
