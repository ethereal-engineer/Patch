//
//  MGMappedDataSource.m
//  Mytograph
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGMappedDataSource.h"

#pragma mark - Composites

#import "MGDataSourceChangeNotifier.h"

@interface MGMappedDataSource ()

@property (nonatomic, copy) MGFunctor functor;

@end

@implementation MGMappedDataSource

#pragma mark - Init

- (instancetype)initWithDataSource:(id<MGDataSource>)dataSource
{
    self = [self initWithDataSource:dataSource functor:nil];
    if (self)
    {
        // This will always fail - please use designated default instead
    }
    return self;
}

- (instancetype)initWithDataSource:(id<MGDataSource>)dataSource functor:(MGFunctor)functor
{
    NSParameterAssert(functor);
    
    self = [super initWithDataSource:dataSource];
    if (self)
    {
        self.functor = functor;
    }
    return self;
}

#pragma mark - Private

- (id)mapFrom:(id)dataItem
{
    // TODO: Memoize?
    return _functor(dataItem);
}

#pragma mark - MGDataSource Overrides

- (id)itemAtIndex:(NSInteger)index
{
    return [self mapFrom:[self.dataSource itemAtIndex:index]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self mapFrom:[self.dataSource itemAtIndexPath:indexPath]];
}

#pragma mark - Class Methods

+ (instancetype)mappedDataSourceWithDataSource:(id<MGDataSource>)dataSource functor:(MGFunctor)functor
{
    MGMappedDataSource *mappedDataSource = nil;
    @autoreleasepool
    {
        mappedDataSource = [[MGMappedDataSource alloc] initWithDataSource:dataSource functor:functor];
    }
    return mappedDataSource;
}

@end
