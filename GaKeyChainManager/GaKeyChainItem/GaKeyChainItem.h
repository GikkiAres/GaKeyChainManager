//
//  GaKeyChainModel.h
//  DeviceId
//
//  Created by GikkiAres on 2020/4/4.
//  Copyright © 2020 TinyWind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

/*
 查询出来的结果是:
 {
     accc = "<SecAccessControlRef: ak>";  kSecAttrAccessControl
     acct = "";
     agrp = tinywind;  kSecAttrAccessGroup
     cdat = "2020-04-04 09:57:33 +0000";  kSecAttrCreationDate
     mdat = "2020-04-04 09:57:33 +0000";  kSecAttrModificationDate
     musr = {length = 0, bytes = 0x};
     pdmn = ak;
     persistref = {length = 0, bytes = 0x};
     sha1 = {length = 20, bytes = 0xfbb1103f22e7c6f95fc67cc86087a4bebba988fb};
     svce = 111;  服务名-->service  kSecAttrServer
     sync = 0;  kSecAttrSynchronizable
     tomb = 0;
     "v_Data" = {length = 3, bytes = 0x313131};  数据-->data kSecValueData
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface GaKeyChainItem : NSObject

@property (nonatomic,strong) NSData * data;
@property (nonatomic,strong) NSString * value;
@property (nonatomic,strong) NSString  * accessGroup;
@property (nonatomic,strong) NSString  * service;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (BOOL)saveToKeyChain;
- (NSString *)toString;
- (BOOL)removeFormKeyChain;
- (BOOL)updateValue;

@end

NS_ASSUME_NONNULL_END
