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

#ifdef PATCH_INCLUDES_COREDATA
#import "PDSCoreDataSource.h"
#import "PDSCoreDataSource+PDSFilterableDataSource.h"
#endif

#ifdef PATCH_INCLUDES_RMSTORE
#import "PDSRMStoreDataSource.h"
#endif

#import "PDSArrayDataSource.h"
#import "PDSMutableArrayDataSource.h"
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

#ifdef PATCH_INCLUDES_ICAROUSEL
#import "PDSCarouselDataSource.h"
#endif

#import "PDSTableViewDataSource.h"
#import "PDSCollectionViewDataSource.h"
#import "PDSPageViewControllerDataSource.h"

/**
 *  @name Extensions
 */

#import "PDSArrayDataSource+PDSFilterableDataSource.h"
#import "PDSCompositeDataSource+PDSFilterableDataSource.h"

/**
 *  @name Half-baked ideas
 */

//#import "PDSMemoizedDataSourceAdapter.h"
//#import "PDSPredicatePropertyCoreDataSource.h"

