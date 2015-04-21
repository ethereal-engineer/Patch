//
//  PDSTableViewDataSource.m
//  Patch
//
//  Created by Adam Iredale on 21/04/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSTableViewDataSource.h"

@interface PDSTableViewDataSource ()

/**
 *  Redefine ReadOnly Properties
 */
@property (nonatomic, strong) id <PDSDataSource> dataSource;
/**
 *  Keep a weak reference to the table view to manage updates, 
 *  refreshes and reloads
 */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation PDSTableViewDataSource

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithDataSource:nil];
    if (self)
    {
        // This will always fail. Please use designated init. In a later version, I'm looking at
        // supporting changing the adapter's datasource dynamically, but this is how it is for v1.
    }
    return self;
}

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    self = [super init];
    if (self)
    {
        _dataSource = dataSource;
        // Subscribe to changes if possible
        if ([dataSource conformsToProtocol:@protocol(PDSChangingDataSource)])
        {
            [[(id <PDSChangingDataSource>)dataSource changeNotifier] addChangeListener:self];
        }
        self.rowUpdateAnimationStyle = UITableViewRowAnimationAutomatic;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Sneaky weakref taken here
    self.tableView = tableView;
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(self.cellAtIndexPathBlock);
    return self.cellAtIndexPathBlock(tableView, indexPath, [self.dataSource itemAtIndexPath:indexPath]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.titleForHeaderInSectionBlock == nil)
    {
        return nil;
    }
    return self.titleForHeaderInSectionBlock(tableView, section, [self.dataSource itemsInSection:section]);
}

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    [self.tableView reloadData];
}

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    [self.tableView beginUpdates];
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    [self.tableView endUpdates];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:self.rowUpdateAnimationStyle];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:self.rowUpdateAnimationStyle];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:self.rowUpdateAnimationStyle];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:self.rowUpdateAnimationStyle];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:self.rowUpdateAnimationStyle];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:self.rowUpdateAnimationStyle];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didChangeEmptyState:(BOOL)isEmpty
{
    
}


#pragma mark - Class Convenience

+ (instancetype)dataSourceWithDataSource:(id<PDSDataSource>)dataSource
{
    PDSTableViewDataSource *tableViewDataSource = nil;
    @autoreleasepool
    {
        tableViewDataSource = [[PDSTableViewDataSource alloc] initWithDataSource:dataSource];
    }
    return tableViewDataSource;
}

@end