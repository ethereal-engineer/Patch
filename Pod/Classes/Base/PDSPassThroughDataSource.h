//
//  PDSPassThroughDataSource.h
//  Patch
//
//  Created by Adam Iredale on 22/01/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PatchProtocols.h"

/**
 *  This is a datasource do-nothing adapter, which implements the same
 *  interfaces as the datasource it wraps (and possibly others). The
 *  intention behind this is to provide a superclass for a bunch of
 *  boilerplate when creating datasources that transform datasources.
 */

@interface PDSPassThroughDataSource : NSObject <PDSChangingDataSource, PDSDataSourceChangeListener>

- (instancetype)initWithDataSource:(id <PDSDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

+ (instancetype)dataSourceWithDataSource:(id <PDSDataSource>)dataSource;

@end

@interface PDSPassThroughDataSource (ReadOnly)

@property (nonatomic, readonly) id <PDSDataSource> dataSource;

@end