//
//  GaKeyChainUtility.h
//  DeviceId
//
//  Created by GikkiAres on 2020/4/4.
//  Copyright © 2020 TinyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GaKeyChainItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GaKeyChainUtility : NSObject

+ (void)saveContextToKeyChain:(NSString *)context forService:(NSString * _Nullable)service  accessGroup:(NSString * _Nullable)accessGroup;

+ (NSArray<GaKeyChainItem *> *)contextFromKeyChainForService:(NSString *_Nullable)service accessGroup:(NSString *_Nullable)accessGroup;

+ (void)deleteContextFromKeyChainForService:(NSString *)service accessGroup:(NSString * _Nullable)accessGroup;


+ (NSArray <GaKeyChainItem *>*)queryAllKeyChainItem;

@end

NS_ASSUME_NONNULL_END
