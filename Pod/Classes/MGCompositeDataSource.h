//
//  MGCompositeCluster.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Allows combining of multiple data sources for a single facade to an aggregated datasource
 */

@interface MGCompositeDataSource : NSObject <MGChangingDataSource>

- (instancetype)initWithDataSources:(NSArray *)dataSources NS_DESIGNATED_INITIALIZER;

+ (instancetype)compositeDataSourceWithDataSources:(NSArray *)dataSources;

@end

@interface MGCompositeDataSource (ReadOnly)

@property (nonatomic, readonly) NSArray *dataSources;

@end