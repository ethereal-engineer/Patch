//
//  Patch.h
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  @name Protocols
 */

#import "PatchProtocols.h"

/**
 *  @name Core
 */

#import "PDSDataSourceChangeListener.h"
#import "PDSDataSourceChangeNotifier.h"

/**
 *  @name Sources
 */

#import "PDSCoreDataSource.h"
#import "PDSArrayDataSource.h"
#import "PDSDirectoryContentDataSource.h"


/**
 *  @name Non-Converting Adapters
 */

#import "PDSPassThroughDataSource.h"
#import "PDSMappedDataSource.h"
#import "PDSFilteredDataSource.h"
#import "PDSCompositeDataSource.h"
#import "PDSReverseDataSource.h"
#import "PDSIndexMappedDataSource.h"
#import "PDSSampleDataSource.h"

/**
 *  @name Converting Adapters
 */

#warning TABLE VIEW DS ADAPTER MUST BE RECREATED
//#import "PDSTableViewDataSource.h"
#import "PDSCarouselDataSource.h"
#import "PDSCollectionViewDataSource.h"
#import "PDSPageViewControllerDataSource.h"

/**
 *  @name Extensions
 */

#import "PDSArrayDataSource+PDSFilterableDataSource.h"

/**
 *  @name Half-baked ideas
 */

//#import "PDSMemoizedDataSourceAdapter.h"
//#import "PDSPredicatePropertyCoreDataSource.h"