//
//  PDSDirectoryContentDataSource.h
//  Patch
//
//  Created by Adam Iredale on 19/03/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSArrayDataSource.h"

// TODO: re-eval inheritance quickie

@interface PDSDirectoryContentDataSource : PDSArrayDataSource <PDSDataSource>

- (instancetype)initWithURL:(NSURL *)directoryURL NS_DESIGNATED_INITIALIZER;

+ (instancetype)dataSourceWithURL:(NSURL *)directoryURL;

@end
