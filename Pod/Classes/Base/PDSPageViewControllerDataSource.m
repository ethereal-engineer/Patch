//
//  PDSPageViewControllerDataSource.m
//  Patch
//
//  Created by Adam Iredale on 18/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSPageViewControllerDataSource.h"

/**
 *  @name Categories
 */

#import "UIPageViewController+Patch.h"

@interface PDSPageViewControllerDataSource () <PDSDataSourceChangeListener>

@property (nonatomic, strong) id <PDSDataSource> dataSource;

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong) NSArray *insertedIndexPaths;

@property (nonatomic, strong) NSArray *removedIndexPaths;

@property (nonatomic, strong) NSArray *updatedIndexPaths;

@property (nonatomic, weak) UIPageViewController *pageViewController;

/**
 *  Redefine readonly properties
 */
@property (nonatomic, strong) UIViewController *placeholderViewController;

@end

@implementation PDSPageViewControllerDataSource

#pragma mark - Init

- (instancetype)init
{
    // Always fails - use designated init instead
    self = [self initWithDataSource:nil placeholderViewController:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource placeholderViewController:(UIViewController *)placeholder
{
    NSParameterAssert(dataSource);
    NSParameterAssert(placeholder);
    
    self = [super init];
    if (self)
    {
        self.viewControllers            = nil;
        self.dataSource                 = dataSource;
        self.placeholderViewController  = placeholder;
        if ([dataSource conformsToProtocol:@protocol(PDSChangingDataSource)])
        {
            [[(id <PDSChangingDataSource>)dataSource changeNotifier] addChangeListener:self];
        }
    }
    return self;
}

#pragma mark - Accessors

- (NSUInteger)numberOfViewControllers
{
    return _dataSource.numberOfItems;
}

#pragma mark - Private

- (void)initialiseViewControllers
{
    self.viewControllers = @[];
    [self mapDataItemsToViewControllers];
    [self updatePageViewControllerFromViewControllers:@[] toViewControllers:_viewControllers];
}

- (void)mapDataItemsToViewControllers
{
    for (NSInteger i = 0; i < _dataSource.numberOfItems; i++)
    {
        _viewControllers = [_viewControllers arrayByAddingObject:[self createViewControllerForDataSourceIndex:i]];
        [self configureViewControllerAtIndex:i];
    }
}

- (void)updatePageViewControllerFromViewControllers:(NSArray *)fromVCs toViewControllers:(NSArray *)toVCs
{
    if (toVCs.count == 0)
    {
        _pageViewController.singleViewController = _placeholderViewController;
        return;
    }
    
    UIViewController *currentViewController = _pageViewController.viewControllers.firstObject;
    NSInteger indexOfCurrentViewController  = [fromVCs indexOfObject:currentViewController];
    
    // if no items, show the placeholder
    UIViewController *viewController = _placeholderViewController;
    
    // if the current view controller was not a data view controller (i.e. not found in from array), show the first toVC
    if (indexOfCurrentViewController == NSNotFound)
    {
        viewController = toVCs.firstObject;
    }
    else if ([toVCs containsObject:currentViewController] == NO)
    {
        // if the current view controller was a data view controller
        // but doesn't exist in the to, show the next valid view controller
        if (toVCs.count > indexOfCurrentViewController)
        {
            viewController = toVCs[indexOfCurrentViewController];
        }
        else
        {
            viewController = toVCs.lastObject;
        }
    }
    _pageViewController.singleViewController = viewController;
}

- (UIViewController *)createViewControllerForDataSourceIndex:(NSInteger)index
{
    NSParameterAssert(_instantiateViewControllerBlock);
    UIViewController *viewController = _instantiateViewControllerBlock(index, [_dataSource itemAtIndex:index]);
    NSAssert(viewController, @"Instantiate block MUST return a valid view controller");
    return viewController;
}

- (void)configureViewControllerAtIndex:(NSInteger)index
{
    if (!_configureViewControllerBlock)
    {
        return;
    }
    _configureViewControllerBlock(_viewControllers[index], index, [_dataSource itemAtIndex:index]);
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger indexOfViewController = [_viewControllers indexOfObject:viewController];
    if (indexOfViewController == NSNotFound || indexOfViewController == 0)
    {
        return nil;
    }
    else
    {
        return _viewControllers[indexOfViewController - 1];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger indexOfViewController = [_viewControllers indexOfObject:viewController];
    if (indexOfViewController == NSNotFound || indexOfViewController == _viewControllers.count - 1)
    {
        return nil;
    }
    else
    {
        return _viewControllers[indexOfViewController + 1];
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // Snatch a reference to the page view controller here for later
    self.pageViewController = pageViewController;
    // This happens only once
    if (!_viewControllers)
    {
        [self initialiseViewControllers];
    }
    return _viewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [_viewControllers indexOfObject:_pageViewController.viewControllers.firstObject];
}

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    // TODO: we may need to have some kind of animation block started here... or something?
    self.insertedIndexPaths = @[];
    self.removedIndexPaths = @[];
    self.updatedIndexPaths = @[];
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    NSArray         *preChangeViewControllers   = _viewControllers;
    NSMutableArray  *mutableViewControllers     = [_viewControllers mutableCopy];
    
    // Operations come through unsorted, so sort the volatile ones
    self.insertedIndexPaths = [_insertedIndexPaths sortedArrayUsingSelector:@selector(compare:)];
    self.removedIndexPaths  = [_removedIndexPaths sortedArrayUsingSelector:@selector(compare:)];
    
    // Perform removes first (in reverse order, of course)
    for (NSIndexPath *indexPath in _removedIndexPaths.reverseObjectEnumerator)
    {
        [mutableViewControllers removeObjectAtIndex:indexPath.item];
    }
    
    // Then inserts
    for (NSIndexPath *indexPath in _insertedIndexPaths)
    {
        [mutableViewControllers insertObject:[self createViewControllerForDataSourceIndex:indexPath.item] atIndex:indexPath.item];
    }
    
    // Update the properties before the configuration pass (I'd prefer better than this)
    self.viewControllers = [NSArray arrayWithArray:mutableViewControllers];
    
    // Then a configuration pass for all inserts and updates
    NSArray *insertedOrUpdatedIndexPaths = [_insertedIndexPaths arrayByAddingObjectsFromArray:_updatedIndexPaths];
    for (NSIndexPath *indexPath in insertedOrUpdatedIndexPaths)
    {
        [self configureViewControllerAtIndex:indexPath.item];
    }
    
    // Nullify intermediaries
    self.insertedIndexPaths = nil;
    self.removedIndexPaths  = nil;
    self.updatedIndexPaths  = nil;
    
    // Animate the migration as needed
    [self updatePageViewControllerFromViewControllers:preChangeViewControllers toViewControllers:_viewControllers];
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    [self initialiseViewControllers];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    _insertedIndexPaths = [_insertedIndexPaths arrayByAddingObject:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    _removedIndexPaths = [_removedIndexPaths arrayByAddingObject:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    _updatedIndexPaths = [_updatedIndexPaths arrayByAddingObject:indexPath];
}

// N.B. Sections not supported in this datasource (should I use a block device instead then?)

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    //
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    //
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    //
}

#pragma mark - Public

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    return _viewControllers[index];
}

#pragma mark - Class Methods

+ (instancetype)pageViewControllerDataSourceWithDataSource:(id<PDSDataSource>)dataSource placeholderViewController:(UIViewController *)placeholder
{
    PDSPageViewControllerDataSource *pvcd = nil;
    @autoreleasepool
    {
        pvcd = [[PDSPageViewControllerDataSource alloc] initWithDataSource:dataSource placeholderViewController:placeholder];
    }
    return pvcd;
}

@end
