//
//  PDSRMStoreDataSource.h
//  Patch
//
//  Created by Adam Iredale on 26/08/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PatchProtocols.h"

@class RMStore;

/**
 *  DataSource for RMStore, an IAP Helper. Allows easy display and actions on IAPs.
 */

@interface PDSRMStoreDataSource : NSObject <PDSChangingDataSource>
/**
 *  YES if an update notification should be sent to any listeners when an item's download state changes
 */
@property (nonatomic, assign) BOOL shouldUpdateItemsWithDownloadStatus;
/**
 *  YES if an update notification should be sent to any listeners when an item is purchased (or restored)
 *  @default YES
 */
@property (nonatomic, assign) BOOL shouldUpdateItemsWhenPurchased;

- (instancetype)initWithStore:(RMStore *)store productIds:(NSArray *)productIds NS_DESIGNATED_INITIALIZER;
+ (instancetype)dataSourceWithStore:(RMStore *)store productIds:(NSArray *)productIds;

@end