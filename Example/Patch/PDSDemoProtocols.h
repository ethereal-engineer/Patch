//
//  PDSDemoProtocols.h
//  Patch
//
//  Created by Adam Iredale on 21/04/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#ifndef Patch_PDSDemoProtocols_h
#define Patch_PDSDemoProtocols_h


@protocol PDSDemoMenuItem <NSObject>

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

@end

#endif
