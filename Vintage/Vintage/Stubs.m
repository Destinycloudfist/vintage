//
//  Stubs.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/4/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Stubs.h"

#if TARGET_OS_ANDROID
#import <NFC/APNFCManager.h>
#else

@implementation APNFCManager : NSObject

+(void)readNFCTagWithCompletionBlock:(void(^)(BOOL success, NSString *payload))block
{
    block(YES, @"");
}

+(void)writeNFCTagWithURLString:(NSString *)urlString completionBlock:(void(^)(BOOL success, NSString *payload))block
{
    block(YES, @"");
}

@end


#endif
