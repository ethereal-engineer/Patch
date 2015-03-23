//
//  Common.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  @name Constants
 */

/**
 *  Bucket for debug uploads - I'd normally encrypt the keys and secret but
 *  in this case the key and secret can only put files, so as long as it's removed
 *  or changed by release, it doesn't matter - I can always void the keys.
 */
static NSString *const kMytographDebugBucketName    = @"com.bionicmonocle.mytograph";
static NSString *const kMytographDebugBucketKey     = @"AKIAIZW2T44TTVYI4KUQ";
static NSString *const kMytographDebugBucketSecret  = @"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";

static const BOOL MGAssetsShouldUsePreciseTiming = YES;

/**
 *  Content Pack Types (duplicated in folder structure - not ideal)
 */
static NSString *const MGContentPackTypeFilter  = @"filter";
static NSString *const MGContentPackTypeMusic   = @"music";
static NSString *const MGContentPackTypeOverlay = @"overlay";


/**
 *  @name Enums
 */

/**
 *  Menu Item Kind (Generic)
 */
typedef NS_ENUM(NSUInteger, MGMenuItemKind){
    /**
     *  Do nothing, basically
     */
    MGMenuItemKindUnknown,
    /**
     *  Launch the "add" action
     */
    MGMenuItemKindAdd
};

typedef NS_ENUM(NSUInteger, MGSlideRendererImageQuality)
{
    MGSlideRendererImageQualityPreview,
    MGSlideRendererImageQualityRender
};

typedef NS_ENUM(NSUInteger, MGSlideRendererOutputKind)
{
    MGSlideRendererOutputKindImage,
    MGSlideRendererOutputKindAsset
};

/**
 *  @name Protocols
 */

@class UIImage, MGSlide;

/**
 *  Generic datasource protocol
 */

@protocol MGDataSource <NSObject>
/**
 *  Number of sections in the datasource
 */
@property (nonatomic, readonly) NSUInteger numberOfSections;
/**
 *  Total number of items in the datasource (irrespective of sections)
 */
@property (nonatomic, readonly) NSUInteger numberOfItems;
/**
 *  Return the item at the given index, irrespective of sections
 *
 *  @param index Index within the datasource's bounds
 *
 *  @return Data item at the index
 */
- (id)itemAtIndex:(NSInteger)index;
/**
 *  Return the item at the given index path
 *
 *  @param indexPath Index path with valid index and section
 *
 *  @return Data item at the index path
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  Return the number of items in the given section
 *
 *  @param section Section index
 *
 *  @return Number of items in the section
 */
- (NSUInteger)numberOfItemsInSection:(NSInteger)section;
/**
 *  Ask the datasource to requery its source (e.g. Core Data)
 */
- (void)reload;

@end

@protocol MGFilterableDataSource <MGDataSource>

- (NSUInteger)numberOfItemsMatchingPredicate:(NSPredicate *)predicate;
- (id)filteredItemAtIndex:(NSInteger)index predicate:(NSPredicate *)predicate;
- (id)filteredItemAtIndexPath:(NSIndexPath *)indexPath predicate:(NSPredicate *)predicate;
- (NSUInteger)numberOfItemsInSection:(NSInteger)section matchingPredicate:(NSPredicate *)predicate;

@end

@protocol MGDataSourceChangeNotifier;

/**
 *  Protocol that indicates that the datasource is of the changing kind, and hence has a change
 *  notifier.
 */
@protocol MGChangingDataSource <MGDataSource>
/**
 *  Change notifier object for informing observers (conforming to MGDataSourceChangeListener) of 
 *  datasource changes
 */
@property (nonatomic, readonly) id <MGDataSourceChangeNotifier> changeNotifier;

@end

/**
 *  Change listeners must conform to this protocol to receive change notifications from a
 *  change notifier
 */
@protocol MGDataSourceChangeListener <NSObject>
/**
 *  This will be called before any changes to the datasource data
 *
 *  @param dataSource Datasource
 */
- (void)dataSourceWillChange:(id <MGDataSource>)dataSource;
/**
 *  This will be called after changes to the datasource data
 *
 *  @param dataSource Datasource
 */
- (void)dataSourceDidChange:(id <MGDataSource>)dataSource;
/**
 *  The entire datasource reloaded
 *
 *  @param dataSource Datasource
 */
- (void)dataSourceDidReload:(id <MGDataSource>)dataSource;
/**
 *  The datasource inserted an item
 *
 *  @param dataSource Datasource
 *  @param indexPath  IndexPath of the item
 */
- (void)dataSource:(id <MGDataSource>)dataSource didInsertItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The datasource removed an item
 *
 *  @param dataSource Datasource
 *  @param indexPath  IndexPath of the item
 */
- (void)dataSource:(id <MGDataSource>)dataSource didRemoveItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The datasource updated an item
 *
 *  @param dataSource Datasource
 *  @param indexPath  IndexPath of the item
 */
- (void)dataSource:(id <MGDataSource>)dataSource didUpdateItemAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  The datasource inserted a section
 *
 *  @param dataSource Datasource
 *  @param indexPath  Index of the section
 */
- (void)dataSource:(id <MGDataSource>)dataSource didInsertSectionAtIndex:(NSInteger)index;
/**
 *  The datasource removed a section
 *
 *  @param dataSource Datasource
 *  @param indexPath  Index of the section
 */
- (void)dataSource:(id <MGDataSource>)dataSource didRemoveSectionAtIndex:(NSInteger)index;
/**
 *  The datasource updated a section
 *
 *  @param dataSource Datasource
 *  @param indexPath  Index of the section
 */
- (void)dataSource:(id <MGDataSource>)dataSource didUpdateSectionAtIndex:(NSInteger)index;

@end

/**
 *  The change notifier accepts any number of listeners and informs them when the attached
 *  datasource data changes
 */
@protocol MGDataSourceChangeNotifier <MGDataSourceChangeListener>
/**
 *  Add a change listener
 *
 *  Note that all listeners are weakly retained, so don't have to be explicitly removed
 *
 *  @param listener Listener
 */
- (void)addChangeListener:(id <MGDataSourceChangeListener>)listener;
/**
 *  Remove a change listener
 *
 *  @param listener Listener
 */
- (void)removeChangeListener:(id <MGDataSourceChangeListener>)listener;
/**
 *  Removes ALL change listeners
 */
- (void)removeAllChangeListeners;

@end

/**
 *  Represents an item that a user may interact with in a visual menu. WIP
 */
@protocol MGMenuItem <NSObject>

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) UIImage *image; // Need MORE Images for state (enabled, bought, etc) or possibly overlays
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDictionary *userInfo;
// Select Action
// Highlight Action (carousel itself should be set to know whether to wait until stopped to exec)
// State - enabled, disabled for IAP?
// Drag to delete flag?

@end

/**
 *  Protocol that reveals the bare essentials of the editing interface that the toolsets may use
 */
@protocol MGEditingInterface <NSObject>
/**
 *  The index of the slide on screen right now, relative to the project object - NSNotFound if none
 */
@property (nonatomic, readonly) MGSlide *currentSlide; // CARE HERE!
@property (nonatomic, readonly) NSInteger currentSlideIndex;
@property (nonatomic, readonly) NSUInteger numberOfSlides;
/**
 *  Show the slide at the given index for the active project
 *
 *  @param index    Slide Index
 *  @param animated Animate changes?
 */
- (void)showSlideAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

@class MGProject;

/**
 *  Protocol conformed to for anything that edits the project object
 */

@protocol MGProjectEditor <NSObject>
/**
 *  Anything that makes changes to a project must have a project property to set
 */
@property (nonatomic, strong) MGProject *project;

@end

/**
 *  Anything that makes changes to a slide must have a slide property to set
 */
@protocol MGSlideEditor <NSObject>

@property (nonatomic, strong) MGSlide *slide;

@end

/**
 *  Toolsets (view controllers atm) are project editors, and they are always within the editing
 *  view controller
 */

@protocol MGToolset <MGProjectEditor>

@optional

/**
 *  View controller that (if exists) is overlaid above the preview window in the editing screen upon selecting
 *  the toolset and removed upon moving to another toolset. The view controller will be added as a child
 *  view controller to the editor until it is removed again.
 */
@property (nonatomic, readonly) UIViewController *previewOverlayViewController;
/**
 *  Allows toolsets to control the editing interface if needed
 */
@property (nonatomic, weak) id <MGEditingInterface> editingInterface;
/**
 *  Either allows or doesn't - initially for titles
 */
@property (nonatomic, readonly) BOOL shouldAllowImageManipulation;
/**
 *  Return YES if slide-related editing is in progress (to prevents redraw etc)
 */
@property (nonatomic, readonly) BOOL isSlideEditInProgress;

// FIXME: needs start editing and finish editing to allow the editor to lock and unlock parts of the UI

@end

@class ZZArchive;

@protocol MGContentPack <NSObject>

@property (nonatomic, readonly) ZZArchive *archive; //!!! hasty exposure
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *localizedDisplayName;

- (UIImage *)thumbnailImage:(NSError *__autoreleasing*)error;

@end

@protocol MGNamedEntity <NSObject>

@property (nonatomic, readonly) NSString *name;

@end

@protocol MGPlaceEntity <MGNamedEntity>

@end

/**
 *  @name Macro for index-mapping (hopefully temporary)
 */
static inline double MGIndexMappingDelta(NSInteger fromMaxIndex, NSInteger toMaxIndex)
{
    if (fromMaxIndex <= 0 || toMaxIndex <= 0)
    {
        return 1;
    }
    else
    {
        return (double)fromMaxIndex / (double)toMaxIndex;
    }
}