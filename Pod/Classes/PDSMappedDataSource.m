//
//  PDSMappedDataSource.m
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSMappedDataSource.h"

#pragma mark - Composites

#import "PDSDataSourceChangeNotifier.h"

@interface PDSMappedDataSource ()

@property (nonatomic, copy) PDSFunctor functor;

@end

@implementation PDSMappedDataSource

#pragma mark - Init

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    self = [self initWithDataSource:dataSource functor:nil];
    if (self)
    {
        // This will always fail - please use designated default instead
    }
    return self;
}

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource functor:(PDSFunctor)functor
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

#pragma mark - PDSDataSource Overrides

- (id)itemAtIndex:(NSInteger)index
{
    return [self mapFrom:[self.dataSource itemAtIndex:index]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self mapFrom:[self.dataSource itemAtIndexPath:indexPath]];
}

#pragma mark - Class Methods

+ (instancetype)mappedDataSourceWithDataSource:(id<PDSDataSource>)dataSource functor:(PDSFunctor)functor
{
    PDSMappedDataSource *mappedDataSource = nil;
    @autoreleasepool
    {
        mappedDataSource = [[PDSMappedDataSource alloc] initWithDataSource:dataSource functor:functor];
    }
    return mappedDataSource;
}

@end
