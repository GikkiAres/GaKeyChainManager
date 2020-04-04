//
//  GaKeyChainUtility.m
//  DeviceId
//
//  Created by GikkiAres on 2020/4/4.
//  Copyright © 2020 TinyWind. All rights reserved.
//

#import "GaKeyChainUtility.h"


@implementation GaKeyChainUtility

+ (void)saveContextToKeyChain:(NSString *)context forKey:(NSString *_Nullable)key {
    [self saveContextToKeyChain:context forService:nil accessGroup:nil];
}

+ (void)saveContextToKeyChain:(NSString *)context forService:(NSString * _Nullable)service  accessGroup:(NSString * _Nullable)accessGroup{
    //钥匙链项目中kSecValueData中必须保存NSData.
    NSData * data = [context dataUsingEncoding:NSUTF8StringEncoding];
    
    //添加查询字典
    NSMutableDictionary * mdic =[@{
        //指定项目要保存的内容.
        (NSString *)kSecValueData:data
        //指定项目的类型
        ,(NSString *)kSecClass:(NSString *)kSecClassGenericPassword        
    } mutableCopy];
    if(service) {
        mdic[(NSString *)kSecAttrService] = service;
    }
    if(accessGroup) {
        mdic[(NSString *)kSecAttrAccessGroup] = accessGroup;
    }
    
    //新增
    OSStatus status = SecItemAdd((CFDictionaryRef)mdic, nil);
    if(status == errSecSuccess) {
        NSLog(@"保存数据到KeyChain,成功,数据为:%@",context);
    }
    else {
        NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
        NSLog(@"保存数据到KeyChain,失败,原因为:%@",errorInfo);
    }
}

+ (NSArray<GaKeyChainItem *> *)contextFromKeyChainForService:(NSString * _Nullable)service accessGroup:(NSString * _Nullable)accessGroup {
    NSMutableArray * marrResult = [NSMutableArray array];
    //搜索查询字典
    NSMutableDictionary * searchQuery =[self searchQueryDictionaryForService:service accessGroup:accessGroup isSingleMatch:NO isReturnData:YES isReturnAttributes:YES];

    CFTypeRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchQuery, (CFTypeRef *)&result);
        if(status == errSecSuccess) {
            //指定的是返回多个结果,所以结果是数组.
            NSArray * arrResult = (__bridge NSArray *)result;
            [arrResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * dic = obj;
                GaKeyChainItem * item = [[GaKeyChainItem alloc]initWithDictionary:dic];
                NSLog(@"item is %@",dic);
                [marrResult addObject:item];
               
            }];
            NSLog(@"KeyChain查询数据,成功,一个有%zi个项目",marrResult.count);
        }
        else if(status == errSecItemNotFound) {
            NSLog(@"KeyChain查询数据,成功,没有匹配的钥匙链项目.");
        }
        else {
            NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
            NSLog(@"KeyChain查询数据,失败,原因为:%@",errorInfo);
        }
    return marrResult;
}

//addQuery的字典
+ (NSMutableDictionary *)addQueryDictionaryForService:(NSString *)service accessGroup:(NSString * _Nullable)accessGroup {
    NSMutableDictionary * mdic =[@{
    //指定项目的类型
    (NSString *)kSecClass:(NSString *)kSecClassGenericPassword
    //返回的结果数量
    ,(NSString *)kSecMatchLimit:(NSString *)kSecMatchLimitOne
    //是否返回项目的数据
    ,(NSString *)kSecReturnData:(id)kCFBooleanTrue
    } mutableCopy];
    if(service) {
        mdic[(NSString *)kSecAttrService] = service;
    }
      if(accessGroup) {
          mdic[(NSString *)kSecAttrAccessGroup] = accessGroup;
      }
    return mdic;
}

//searchQuery的字典
+ (NSMutableDictionary *)searchQueryDictionaryForService:(NSString *)service accessGroup:(NSString * _Nullable)accessGroup isSingleMatch:(BOOL)isSingleMatch isReturnData:(BOOL)isReturnData isReturnAttributes:(BOOL)isReturnAttributes{
    NSMutableDictionary * searchQuery =[NSMutableDictionary dictionary];
    //指定项目的类型,必填项.
    searchQuery[(NSString *)kSecClass]=(NSString *)kSecClassGenericPassword;

    //返回的结果数量
    if(isSingleMatch) {
        searchQuery[(NSString *)kSecMatchLimit]=(NSString *)kSecMatchLimitOne;
    }
    else {
        searchQuery[(NSString *)kSecMatchLimit]=(NSString *)kSecMatchLimitAll;
    }
    
    //是否返回项目的数据
    if(isReturnData) {
        
        searchQuery[(NSString *)kSecReturnData]=(id)kCFBooleanTrue;
    }
    else {
        searchQuery[(NSString *)kSecReturnData]=(id)kCFBooleanFalse;
    }
    
    //是否返回项目属性
    if(isReturnAttributes) {
        searchQuery[(NSString *)kSecReturnAttributes]=(id)kCFBooleanTrue;
    }
    else {
        searchQuery[(NSString *)kSecReturnAttributes]=(id)kCFBooleanFalse;
    }
    
    if(service) {
        searchQuery[(NSString *)kSecAttrService] = service;
    }
      if(accessGroup) {
          searchQuery[(NSString *)kSecAttrAccessGroup] = accessGroup;
      }
    
//    searchQuery[(NSString *)kSecReturnRef] = (id)kCFBooleanTrue;
//    searchQuery[(NSString *)kSecReturnPersistentRef] = (id)kCFBooleanTrue;
    
    return searchQuery;
}

+ (void)deleteContextFromKeyChainForService:(NSString *)service accessGroup:(NSString * _Nullable)accessGroup {
    NSMutableDictionary * mdic = [self addQueryDictionaryForService:nil accessGroup:accessGroup];
    OSStatus status = SecItemDelete((CFDictionaryRef)mdic);
        if(status == errSecSuccess) {
            NSLog(@"KeyChain删除数据,成功,service为%@",service);
        }
        else if(status == errSecItemNotFound) {
            NSLog(@"KeyChain删除数据,成功,没有匹配的钥匙链项目.");
        }
        else {
            NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
            NSLog(@"KeyChain删除数据,失败,原因为:%@",errorInfo);
        }
}

+ (void)logContextFromKeyChainForService:(NSString * _Nullable)service accessGroup:(NSString * _Nullable)accessGroup {
    NSMutableArray * marrResult = [NSMutableArray array];
    //搜索查询字典
    NSMutableDictionary * searchQuery =[self searchQueryDictionaryForService:service accessGroup:accessGroup isSingleMatch:NO isReturnData:YES isReturnAttributes:YES];

    CFTypeRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchQuery, (CFTypeRef *)&result);
        if(status == errSecSuccess) {
            //指定的是返回多个结果,所以结果是数组.
            NSArray * arrResult = (__bridge NSArray *)result;
            [arrResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary * dic = obj;
                NSData * data = dic[(NSString *)kSecValueData];
                NSString * value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSString * service = dic[(NSString *)kSecAttrService];
                NSString * accessGroup = dic[(NSString *)kSecAttrAccessGroup];
                NSLog(@"value is %@,service is %@,accessGroup is %@",value,service,accessGroup);
            }];
            NSLog(@"KeyChain查询数据,成功,一个有%zi个项目",marrResult.count);
        }
        else if(status == errSecItemNotFound) {
            NSLog(@"KeyChain查询数据,成功,没有匹配的钥匙链项目.");
        }
        else {
            NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
            NSLog(@"KeyChain查询数据,失败,原因为:%@",errorInfo);
        }
}

+ (NSArray <GaKeyChainItem *>*)queryAllKeyChainItem {
   return  [GaKeyChainUtility contextFromKeyChainForService:nil accessGroup:nil];
}

@end
