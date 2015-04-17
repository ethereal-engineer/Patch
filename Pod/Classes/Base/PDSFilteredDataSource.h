//
//  PDSFilteredDataSource.h
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSPassThroughDataSource.h"

/**
 *  An adapter for a datasource that reveals only items that meet the filter predicate. Not intended
 *  for use directly with Core Data, as this can be filtered more efficiently with a direct predicate.
 */

@interface PDSFilteredDataSource : PDSPassThroughDataSource

@property (nonatomic, strong) NSPredicate *filter;
@property (nonatomic, assign) BOOL filtered;

- (instancetype)initWithDataSource:(id <PDSFilterableDataSource>)dataSource filter:(NSPredicate *)filter NS_DESIGNATED_INITIALIZER;
+ (instancetype)filteredDataSourceWithDataSource:(id <PDSFilterableDataSource>)dataSource filter:(NSPredicate *)filter;

@end
