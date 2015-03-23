//
//  MGDataFactory.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

@class MGProject, LMAddress;

@interface MGDataFactory : NSObject

/**
 *  @name User Data (top level)
 */

+ (id <MGDataSource>)personDataSource;
//+ (id <MGDataSource>)faceDataSource;
+ (id <MGDataSource>)projectDataSource;

/**
 *  @name Project Data
 */

+ (id <MGDataSource>)slideDataSourceForProject:(MGProject *)project;

/**
 *  @name App Data
 */


//+ (id <MGDataSource>)shareMenuItemsDataSource;
+ (id <MGDataSource>)personMenuItemDataSource;
+ (id <MGDataSource>)projectMenuItemDataSource;

/**
 *  @name DLC Data
 */

+ (id<MGDataSource>)menuItemDataSourceForContentPacksOfType:(NSString *)packType;

/**
 *  @name Dates And Places (it's big enough to warrant its own heading). Note that dates and places
 *  are broken out seperately for unit testing in another category header file.
 */

+ (id <MGDataSource>)datesAndPlacesDataSourceForHomeAddress:(LMAddress *)address referenceDate:(NSDate *)date;


/**
 *  @name Composite/Mixed Data
 *
 *  Augments user data with app/menu items in the same source
 */

+ (id <MGDataSource>)personMenuDataSource;
+ (id <MGDataSource>)projectMenuDataSource;

@end
