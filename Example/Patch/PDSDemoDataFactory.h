//
//  PDSDemoDataFactory.h
//  Patch
//
//  Created by Adam Iredale on 23/03/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSDemoDataFactory : NSObject

+ (id <PDSDataSource>)demoArrayDataSource;
+ (id <PDSDataSource>)demoCoreDataDataSource;

@end
