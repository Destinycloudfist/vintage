//
//  Stubs.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/4/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_ANDROID
#else

@interface APNFCManager : NSObject
+(void)readNFCTagWithCompletionBlock:(void(^)(BOOL success, NSString *payload))block;
+(void)writeNFCTagWithURLString:(NSString *)urlString completionBlock:(void(^)(BOOL success, NSString *payload))block;

@end

#endif