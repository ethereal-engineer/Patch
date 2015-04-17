//
//  PDSCaraouselDataSource.m
//  Patch
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSCarouselDataSource.h"

@interface PDSCarouselDataSource ()
/**
 *  Weak reference to carousel for updating as data changes
 */
@property (nonatomic, weak) iCarousel *carousel;
/**
 *  Redefine Read Onlys
 */
@property (nonatomic, strong) id <PDSDataSource> dataSource;

@end

@implementation PDSCarouselDataSource

#pragma mark - Init

- (instancetype)init
{
    // Fails - please use designated init
    self = [self initWithDataSource:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    NSParameterAssert(dataSource);
    self = [super init];
    if (self)
    {
        self.dataSource = dataSource;
        if ([dataSource conformsToProtocol:@protocol(PDSChangingDataSource)])
        {
            [[(id <PDSChangingDataSource>)dataSource changeNotifier] addChangeListener:self];
        }
    }
    return self;
}

#pragma mark - Private

- (UIView *)instantiateViewForItemAtIndex:(NSInteger)index
{
    if (_instantiateViewBlock != nil)
    {
        return _instantiateViewBlock(index);
    }
    else
    {
        return nil;
    }
}

- (void)configureView:(UIView *)view forItemAtIndex:(NSInteger)index
{
    if (_configureViewBlock)
    {
        _configureViewBlock(view, index, [_dataSource itemAtIndex:index]);
    }
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    // Weak capture here
    self.carousel = carousel;
    return _dataSource.numberOfItems;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        view = [self instantiateViewForItemAtIndex:index];
    }
    
    [self configureView:view forItemAtIndex:index];
    
    return view;
}

#pragma mark - PDSDataSourceChangeListener

- (void)dataSourceWillChange:(id<PDSDataSource>)dataSource
{
    // TODO: Begin an animation block here
}

- (void)dataSourceDidChange:(id<PDSDataSource>)dataSource
{
    // TODO: Commit the animation block here
}

- (void)dataSourceDidReload:(id<PDSDataSource>)dataSource
{
    [_carousel reloadData];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_carousel insertItemAtIndex:indexPath.item animated:YES];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_carousel reloadItemAtIndex:indexPath.item animated:YES];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_carousel removeItemAtIndex:indexPath.item animated:YES];
}

- (void)dataSource:(id<PDSDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index
{
    // TODO
}

- (void)dataSource:(id<PDSDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index
{
    // TODO
}

#pragma mark - Class Methods

+ (instancetype)carouselDataSourceWithDataSource:(id<PDSDataSource>)dataSource
{
    PDSCarouselDataSource *carouselDataSource = nil;
    @autoreleasepool
    {
        carouselDataSource = [[[self class] alloc] initWithDataSource:dataSource];
    }
    return carouselDataSource;
}

@end
