//
//  GaKeyChainModel.m
//  DeviceId
//
//  Created by GikkiAres on 2020/4/4.
//  Copyright © 2020 TinyWind. All rights reserved.
//

#import "GaKeyChainItem.h"

@implementation GaKeyChainItem

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if(self == [super init]) {
        self.data = dic[(NSString *)kSecValueData];
        self.service = dic[(NSString *)kSecAttrService];
        self.accessGroup = dic[(NSString *)kSecAttrAccessGroup];
    }
    return self;
}

- (void)setData:(NSData *)data {
    _data = data;
    NSString * value = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];
    NSLog(@"Value is %@",value);
    _value = value;
}

- (void)setValue:(NSString *)value {
    _value = value;
    NSData * data = [_value dataUsingEncoding:NSUTF8StringEncoding];
    _data = data;
}

- (BOOL)saveToKeyChain {
        //添加查询字典
        NSMutableDictionary * mdic =[@{
            //指定项目要保存的内容.
            (NSString *)kSecValueData:self.data
            //指定项目的类型
            ,(NSString *)kSecClass:(NSString *)kSecClassGenericPassword
        } mutableCopy];
        if(self.service) {
            mdic[(NSString *)kSecAttrService] = self.service;
        }
        if(self.accessGroup) {
            mdic[(NSString *)kSecAttrAccessGroup] = self.accessGroup;
        }
        
        //如果有,就更新,没有就新增.
        OSStatus status = SecItemAdd((CFDictionaryRef)mdic, nil);
        if(status == errSecSuccess) {
            NSLog(@"保存数据到KeyChain,成功,数据为:%@",self.data);
            return YES;
        }
        else {
            NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
            NSLog(@"保存数据到KeyChain,失败,原因为:%@",errorInfo);
            return NO;
        }
}


- (BOOL)updateValue {
        //创建搜索查询字典
       NSMutableDictionary * searchQuery =[NSMutableDictionary dictionary];
            //指定项目的类型
        searchQuery[(NSString *)kSecClass]=(NSString *)kSecClassGenericPassword;
        if(self.service) {
            searchQuery[(NSString *)kSecAttrService] = self.service;
        }
        if(self.accessGroup) {
            searchQuery[(NSString *)kSecAttrAccessGroup] = self.accessGroup;
        }
    
    //创建更新查询字典
        NSMutableDictionary * updateQuery =[NSMutableDictionary dictionary];
            //指定项目的类型
        updateQuery[(NSString *)kSecValueData]=self.value;
        
        OSStatus status = SecItemUpdate((CFDictionaryRef)searchQuery, (CFDictionaryRef)updateQuery);
        if(status == errSecSuccess) {
            NSLog(@"更新数据到KeyChain,成功,数据为:%@",self.value);
            return YES;
        }
        else {
            NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
            NSLog(@"更新数据到KeyChain,失败,原因为:%@",errorInfo);
            return NO;
        }
}

- (NSString *)toString {
    NSString * str = [NSString stringWithFormat:@"Value is: %@\nAccess Group is: %@\nService is: %@",self.value,self.accessGroup,self.service];
    return str;
}

- (BOOL)removeFormKeyChain {
    //创建删除查询字典

    NSMutableDictionary * mdic =[NSMutableDictionary dictionary];
        //指定项目的类型
    mdic[(NSString *)kSecClass]=(NSString *)kSecClassGenericPassword;
    if(self.service) {
        mdic[(NSString *)kSecAttrService] = self.service;
    }
    if(self.accessGroup) {
        mdic[(NSString *)kSecAttrAccessGroup] = self.accessGroup;
    }
    
       OSStatus status = SecItemDelete((CFDictionaryRef)mdic);
           if(status == errSecSuccess) {
               NSLog(@"KeyChain删除数据,成功,service为%@",self.service);
               return YES;
           }
           else if(status == errSecItemNotFound) {
               NSLog(@"KeyChain删除数据,成功,没有匹配的钥匙链项目.");
           }
           else {
               NSString * errorInfo = (NSString *)CFBridgingRelease(SecCopyErrorMessageString(status, nil));
               NSLog(@"KeyChain删除数据,失败,原因为:%@",errorInfo);
           }
    return NO;
}

@end
