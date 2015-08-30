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
    NSArray *oldViewControllers = self.viewControllers ?: @[];
    self.viewControllers = @[];
    [self mapDataItemsToViewControllers];
    [self updatePageViewControllerFromViewControllers:oldViewControllers toViewControllers:_viewControllers];
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
    UIViewController *currentViewController             = _pageViewController.viewControllers.firstObject;
    NSInteger sourceIndexOfCurrentViewController        = [fromVCs indexOfObject:currentViewController];
    
    // Visible behaviour on change:
    
    // - If current view controller exists in the destination, stay on it
    UIViewController *viewController = currentViewController;

    if (toVCs.count == 0)
    {
        // - No view controllers? Show placeholder
        viewController = _placeholderViewController;
    }
    else if (!currentViewController)
    {
        // - If there is no current controller (first time?), use the first from the destination set
        viewController = toVCs.firstObject;
    }
    else if (![toVCs containsObject:currentViewController])
    {
        // - If not, and there is another view controller at its index, show that
        if (sourceIndexOfCurrentViewController < toVCs.count)
        {
            viewController = toVCs[sourceIndexOfCurrentViewController];
        }
        else
        {
            // - Otherwise, show nearest view controller
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
    // Process updates first
    for (NSIndexPath *indexPath in _updatedIndexPaths)
    {
        [self configureViewControllerAtIndex:indexPath.item];
    }
    
    // If that's all there is then do no more
    if (!_removedIndexPaths.count && !_insertedIndexPaths.count)
    {
        return;
    }
    
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
    
     for (NSIndexPath *indexPath in _insertedIndexPaths)
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

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    _insertedIndexPaths = [_insertedIndexPaths arrayByAddingObject:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    _removedIndexPaths = [_removedIndexPaths arrayByAddingObject:indexPath];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    _updatedIndexPaths = [_updatedIndexPaths arrayByAddingObject:indexPath];
}

// N.B. Sections not supported in this datasource (should I use a block device instead then?)

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSection:(id)sectionInfo atIndex:(NSInteger)index
{
    //
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSection:(id)sectionInfo atIndex:(NSInteger)index
{
    //
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSection:(id)sectionInfo atIndex:(NSInteger)index
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
