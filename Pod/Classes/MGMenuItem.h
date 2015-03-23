//
//  MGMenuItem.h
//  Mytograph
//
//  Created by Adam Iredale on 4/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Represents a menu item in any carousel-based menu (basically the non-UI model of a button)
 */

@interface MGMenuItem : NSObject <MGMenuItem>

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title image:(UIImage *)image userInfo:(NSDictionary *)userInfo NS_DESIGNATED_INITIALIZER;

+ (instancetype)menuItemWithIdentifier:(NSString *)identifier title:(NSString *)title image:(UIImage *)image userInfo:(NSDictionary *)userInfo;

@end
