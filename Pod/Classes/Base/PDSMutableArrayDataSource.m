//
//  PDSMutableArrayDataSource.m
//  Pods
//
//  Created by Adam Iredale on 28/05/2015.
//
//

#import "PDSMutableArrayDataSource.h"

#pragma mark - Change Notifier

#import "PDSDataSourceChangeNotifier.h"

@interface PDSMutableArrayDataSource ()

// Never access this directly - instead use the self.array property
@property (nonatomic, strong) NSMutableArray *internalArray;

@end

@implementation PDSMutableArrayDataSource

@synthesize changeNotifier = _changeNotifier;

#pragma mark - Init

- (instancetype)init
{
    self = [self initWithArray:nil];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        _changeNotifier = [[PDSDataSourceChangeNotifier alloc] init];
        _internalArray = [NSMutableArray array];
        if (array.count)
        {
            [_internalArray addObjectsFromArray:array];
        }
        [self addObserver:self
               forKeyPath:@"internalArray"
                  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                  context:&_internalArray];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"internalArray"
                 context:&_internalArray];
}

#pragma mark - Accessors

- (NSMutableArray *)array
{
    return [self mutableArrayValueForKey:@"internalArray"];
}

// TODO: equality? hash?

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &_internalArray)
    {
        if ([keyPath isEqualToString:@"internalArray"])
        {
            NSLog(@"Change = %@",change);
            [self.changeNotifier dataSourceWillChange:self];
            
            switch ([change[NSKeyValueChangeKindKey] unsignedIntegerValue])
            {
                case NSKeyValueChangeInsertion:
                    [self notifyChangeForInsertionOItems:change[NSKeyValueChangeNewKey]
                                            withIndexSet:change[NSKeyValueChangeIndexesKey]];
                    break;
                case NSKeyValueChangeRemoval:
                    [self notifyChangeForRemovalOfItems:change[NSKeyValueChangeOldKey]
                                            withIndexSet:change[NSKeyValueChangeIndexesKey]];
                    break;
                case NSKeyValueChangeReplacement:
                    [self notifyChangeForReplacementOfItems:change[NSKeyValueChangeOldKey]
                                               withNewItems:change[NSKeyValueChangeNewKey]
                                                 atIndexSet:change[NSKeyValueChangeIndexesKey]];
                    break;
                case NSKeyValueChangeSetting: // N/A
                default:
                    break;
            }
            
            [self.changeNotifier dataSourceDidChange:self];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)notifyChangeForInsertionOItems:(NSArray *)items withIndexSet:(NSIndexSet *)indexSet
{
    __block NSInteger itemIndex = 0;
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [self.changeNotifier dataSource:self didInsertItem:items[itemIndex] atIndexPath:indexPath];
        itemIndex++;
    }];
}

- (void)notifyChangeForRemovalOfItems:(NSArray *)items withIndexSet:(NSIndexSet *)indexSet
{
    __block NSInteger itemIndex = 0;
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
         [self.changeNotifier dataSource:self didRemoveItem:items[itemIndex] atIndexPath:indexPath];
         itemIndex++;
     }];
}

- (void)notifyChangeForReplacementOfItems:(NSArray *)oldItems withNewItems:(NSArray *)newItems atIndexSet:(NSIndexSet *)indexSet
{
    // !!! New items not passed through
    __block NSInteger itemIndex = 0;
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
         [self.changeNotifier dataSource:self didUpdateItem:oldItems[itemIndex] atIndexPath:indexPath];
         itemIndex++;
     }];
}

#pragma mark - PDSDataSource

- (NSUInteger)numberOfItems
{
    return self.array.count;
}

- (NSUInteger)numberOfSections
{
    return 1;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

- (id)itemAtIndex:(NSInteger)index
{
    return self.array[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(indexPath.section == 0, @"This datasource does not support sections");
    return [self itemAtIndex:indexPath.item];
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    return self.array;
}

- (void)reload
{
    // !!!
}

#pragma mark - Class Methods

+ (instancetype)arrayDataSourceWithArray:(NSArray *)array
{
    PDSMutableArrayDataSource *dataSource = nil;
    @autoreleasepool
    {
        dataSource = [[PDSMutableArrayDataSource alloc] initWithArray:array];
    }
    return dataSource;
}

@end
