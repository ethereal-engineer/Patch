//
//  PDSArrayDataSource.h
//  Patch
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Generic datasource based on NSArray
 */

#import "PatchProtocols.h"

@interface PDSArrayDataSource : NSObject <PDSDataSource>

- (instancetype)initWithArray:(NSArray *)array NS_DESIGNATED_INITIALIZER;

+ (instancetype)arrayDataSourceWithArray:(NSArray *)array;

@end

@interface PDSArrayDataSource (ReadOnly)

@property (nonatomic, readonly) NSArray *array;

@end