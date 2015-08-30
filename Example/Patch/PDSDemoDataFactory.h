//
//  PDSDemoDataFactory.h
//  Patch
//
//  Created by Adam Iredale on 23/03/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  UserInfo key for storyboard file name
 */
static NSString *const PDSDemoStoryboardNameKey = @"PDSDemoStoryboardNameKey";

@interface PDSDemoDataFactory : NSObject

/**
 *  @name Main Menu
 */

+ (id <PDSDataSource>)mainMenuItemsDataSource;

/**
 *  @name Basic DataSource Demos
 */

+ (id <PDSDataSource>)arrayDataSource;

/**
 *  @name Advanced DataSource Demos
 */

+ (id <PDSDataSource>)filteredCompositeDataSource;
+ (id <PDSDataSource>)sampledDataSource;
+ (id <PDSDataSource>)mappedRandomNumberDataSource;

@end
