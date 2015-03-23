//
//  MGMappedDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGPassThroughDataSource.h"

/**
 *  A functor is a map function that takes an object and produces another object as a result
 *
 *  @param dataItem The input data item
 *
 *  @return The output data item
 */

typedef id(^MGFunctor)(id dataItem);

/**
 *  A mapped datasource uses the same concept as the map FP paradigm. It takes
 *  a datasource as input and maps each item to a different output by function.
 */

@interface MGMappedDataSource : MGPassThroughDataSource

// N.B. An improvement might memoize this for one-pass mapping caching

- (instancetype)initWithDataSource:(id <MGDataSource>)dataSource functor:(MGFunctor)functor NS_DESIGNATED_INITIALIZER;
+ (instancetype)mappedDataSourceWithDataSource:(id <MGDataSource>)dataSource functor:(MGFunctor)functor;

@end
