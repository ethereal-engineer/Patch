//
//  MGIndexMappedDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 13/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "MGPassThroughDataSource.h"

/**
 *  An index-mapped datasource allows us to specify which input indices map to which
 *  datasource indices (and sections), to be able to rearrange data or access by
 *  index and/or section.
 *
 *  Without map blocks assigned, this works exactly the same as a passthrough datasource
 */

@interface MGIndexMappedDataSource : MGPassThroughDataSource

/**
 *  Maps an inbound index to a datasource index
 */
@property (nonatomic, copy) NSInteger (^forwardIndexMapBlock)(NSInteger);
/**
 *  Maps a datasource index to an outbound index
 */
@property (nonatomic, copy) NSInteger (^reverseIndexMapBlock)(NSInteger);

/**
 *  Maps an inbound section to a datasource section
 */
@property (nonatomic, copy) NSInteger (^forwardSectionMapBlock)(NSInteger);
/**
 *  Maps a datasource section to an outbound section
 */
@property (nonatomic, copy) NSInteger (^reverseSectionMapBlock)(NSInteger);

/**
 *  Maps an inbound index to a datasource indexPath
 */
@property (nonatomic, copy) NSIndexPath *(^forwardIndexPathMapBlock)(NSIndexPath *);
/**
 *  Maps a datasource index to an outbound indexPath
 */
@property (nonatomic, copy) NSIndexPath *(^reverseIndexPathMapBlock)(NSIndexPath *);

@end
