//
//  MGSampleDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 13/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGIndexMappedDataSource.h"

/**
 *  Allows setting of a maximum count such that data returned is an averaged subset of
 *  available data.
 */

@interface MGSampleDataSource : MGIndexMappedDataSource
/**
 *  By default, the sample count is 0, which is the same as setting the sample count
 *  to the number of available data items.
 */
@property (nonatomic, assign) NSUInteger maximumCount;

@end
