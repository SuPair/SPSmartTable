//
//  NSObject+SPHelper.h
//  SPDevelopmentFramework
//
//  Created by fish on 2018/5/23.
//  Copyright © 2018年 Fish. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const SPCustomKeyPath          = @"kSPCustomKeyPath";
static NSString *const SPCustomKeyPathValue     = @"kSPCustomKeyPathValue";

@interface NSObject (Helper)

/**
 动态遍历对象然后设置decode代码
 
 @param object 需要调用的对象
 @param aDecoder NSCoder实例
 @return 调用对象
 */
+ (id)sp_decodeClass:(id)object decoder:(NSCoder *)aDecoder;

/**
 动态遍历对象然后设置encode代码
 
 @param object 需要压缩方法的对象
 @param aCoder NSCoder实例
 */
+ (void)sp_encodeClass:(id)object encoder:(NSCoder *)aCoder;


/**
 设置keypath通过给定的数据进行设置

 @param data 需要设置的key-value 字典
 @param isCustomPriority 设置自定义优先级是否高于默认的
 */
- (void)sp_setKeyPathValueByData:(NSMutableDictionary *)data IsCustomPriority:(BOOL)isCustomPriority;
@end
