//
//  PDSFilteredDataSource.m
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSFilteredDataSource.h"

@interface PDSFilteredDataSource ()

// !!!
//@property (nonatomic, readonly) id <PDSFilterableDataSource> dataSource;

@end

@implementation PDSFilteredDataSource

#pragma mark - Init

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    NSParameterAssert([dataSource conformsToProtocol:@protocol(PDSFilterableDataSource)]);
    self = [self initWithDataSource:(id <PDSFilterableDataSource>)dataSource filter:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithDataSource:(id <PDSFilterableDataSource>)dataSource filter:(NSPredicate *)filter
{
    self = [super initWithDataSource:dataSource];
    if (self)
    {
        self.filter     = filter;
        // If a filter is not specified, turn off filtering initially
        self.filtered   = NO;//(filter != nil); // !!!
    }
    return self;
}

#pragma mark - Private

- (NSPredicate *)activePredicate
{
    NSAssert(_filtered == NO || _filter != nil, @"A filter must be set");
    return (_filtered ? _filter : [NSPredicate predicateWithValue:YES]);
}

#pragma mark - PDSDataSource

- (NSUInteger)numberOfItems
{
    return [(id<PDSFilterableDataSource>)self.dataSource numberOfItemsMatchingPredicate:[self activePredicate]];
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return [(id<PDSFilterableDataSource>)self.dataSource numberOfItemsInSection:section matchingPredicate:[self activePredicate]];
}

- (id)itemAtIndex:(NSInteger)index
{
    return [(id<PDSFilterableDataSource>)self.dataSource filteredItemAtIndex:index predicate:[self activePredicate]];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [(id<PDSFilterableDataSource>)self.dataSource filteredItemAtIndexPath:indexPath predicate:[self activePredicate]];
}

#pragma mark - Class Methods

+ (instancetype)filteredDataSourceWithDataSource:(id<PDSFilterableDataSource>)dataSource filter:(NSPredicate *)filter
{
    PDSFilteredDataSource *filteredDataSource = nil;
    @autoreleasepool
    {
        filteredDataSource = [[PDSFilteredDataSource alloc] initWithDataSource:dataSource filter:filter];
    }
    return filteredDataSource;
}

@end
