//
//  MGArrayDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Generic datasource based on an array
 */

@interface MGArrayDataSource : NSObject <MGDataSource>

- (instancetype)initWithArray:(NSArray *)array NS_DESIGNATED_INITIALIZER;

+ (instancetype)arrayDataSourceWithArray:(NSArray *)array;

@end

@interface MGArrayDataSource (ReadOnly)

@property (nonatomic, readonly) NSArray *array;

@end