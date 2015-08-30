//
//  PDSRMStoreDataSource.m
//  Patch
//
//  Created by Adam Iredale on 26/08/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSRMStoreDataSource.h"

#pragma mark - Third Party Frameworks

#import <RMStore/RMStore.h>

#pragma mark - Patch Dependencies

#import "PDSDataSourceChangeNotifier.h"

@interface PDSRMStoreDataSource () <RMStoreObserver>

@property (nonatomic, strong) id <PDSDataSourceChangeNotifier> changeNotifier;

@property (nonatomic, assign) BOOL hasAttemptedLoad;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) RMStore *store;

@property (nonatomic, strong) NSArray *productIds;

@property (nonatomic, strong) NSArray *validProducts;

@property (nonatomic, strong) NSArray *invalidProductIds;

@end

@implementation PDSRMStoreDataSource

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithStore:nil productIds:nil];
    if (self)
    {
        // Will always fail - please use designated instead
    }
    return self;
}

- (instancetype)initWithStore:(RMStore *)store productIds:(NSArray *)productIds
{
    NSParameterAssert(store);
    NSParameterAssert(productIds.count > 0);
    self = [super init];
    if (self)
    {
        _store          = store;
        _productIds     = productIds;
        _changeNotifier = [[PDSDataSourceChangeNotifier alloc] init];
        
        _shouldUpdateItemsWhenPurchased = YES;
    }
    return self;
}

#pragma mark - Private

- (NSIndexPath *)indexPathForProduct:(SKProduct *)product
{
    return [NSIndexPath indexPathForItem:[self.validProducts indexOfObject:product] inSection:0];
}

- (void)notifyUpdateForProductsWithProductIds:(NSArray *)productIds
{
    [self.changeNotifier dataSourceWillChange:self];
    for (NSString *productId in productIds)
    {
        SKProduct *product = [self productWithProductId:productId];
        [self.changeNotifier dataSource:self didUpdateItem:product atIndexPath:[self indexPathForProduct:product]];
    }
    [self.changeNotifier dataSourceDidChange:self];
}

- (SKProduct *)productWithProductId:(NSString *)productId
{
    return [[self.validProducts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"productIdentifier ==[cd] %@", productId]] firstObject];
}

- (void)startLoading
{
    if (self.hasAttemptedLoad)
    {
        return;
    }
    self.hasAttemptedLoad = YES;
    [self.store removeStoreObserver:self];
    [self.store addStoreObserver:self];
    [self.changeNotifier dataSourceWillStartLoading:self];
    self.isLoading = YES;
    [self.store requestProducts:[NSSet setWithArray:self.productIds]
                        success:^(NSArray *products, NSArray *invalidProductIdentifiers)
     {
         self.validProducts     = products; // TODO: do we need to sort this in the same order as the ids given?
         self.invalidProductIds = invalidProductIdentifiers;
         self.isLoading = NO;
         [self.changeNotifier dataSourceDidStopLoading:self error:nil];
         [self.changeNotifier dataSourceDidReload:self];
     }
                        failure:^(NSError *error)
     {
         self.isLoading = NO;
         [self.changeNotifier dataSourceDidStopLoading:self error:error];
         [self.changeNotifier dataSourceDidReload:self];
     }];
}

#pragma mark - PDSDataSource

- (NSUInteger)numberOfSections
{
    // Only single-sections in the store for now
    // Trigger the load request but only do it once
    [self startLoading];
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    NSAssert(section == 0, @"Multi-sections are not supported for this datasource");
    return (self.isLoading ? 0 : self.validProducts.count);
}

- (NSUInteger)numberOfItems
{
    return [self numberOfItemsInSection:0];
}

- (id)itemAtIndex:(NSInteger)index
{
    return self.validProducts[index]; // TODO: are we integrating the status of the item (bought or not), download status???
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert(indexPath.section == 0);
    return [self itemAtIndex:indexPath.item];
}

#pragma mark - RMStoreObserver

- (void)storePaymentTransactionFinished:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWhenPurchased)
    {
        return;
    }
    [self notifyUpdateForProductsWithProductIds:@[notification.rm_productIdentifier]];
    NSLog(@"storePaymentTransactionFinished");
}

- (void)storeRestoreTransactionsFinished:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWhenPurchased)
    {
        return;
    }
    NSLog(@"storeRestoreTransactionsFinished");
}

- (void)storeDownloadFailed:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWithDownloadStatus)
    {
        return;
    }
    [self notifyUpdateForProductsWithProductIds:@[notification.rm_productIdentifier]];
}

- (void)storeDownloadPaused:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWithDownloadStatus)
    {
        return;
    }
    [self notifyUpdateForProductsWithProductIds:@[notification.rm_productIdentifier]];
}

- (void)storeDownloadUpdated:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWithDownloadStatus)
    {
        return;
    }
    [self notifyUpdateForProductsWithProductIds:@[notification.rm_productIdentifier]];
}

- (void)storeDownloadCanceled:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWithDownloadStatus)
    {
        return;
    }
    [self notifyUpdateForProductsWithProductIds:@[notification.rm_productIdentifier]];
}

- (void)storeDownloadFinished:(NSNotification *)notification
{
    if (!self.shouldUpdateItemsWithDownloadStatus)
    {
        return;
    }
    [self notifyUpdateForProductsWithProductIds:@[notification.rm_productIdentifier]];
}

#pragma mark - Class Methods

+ (instancetype)dataSourceWithStore:(RMStore *)store productIds:(NSArray *)productIds
{
    PDSRMStoreDataSource *dataSource = nil;
    @autoreleasepool
    {
        dataSource = [[PDSRMStoreDataSource alloc] initWithStore:store productIds:productIds];
    }
    return dataSource;
}

@end