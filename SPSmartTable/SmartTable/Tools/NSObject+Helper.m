//
//  NSObject+SPHelper.m
//  SPDevelopmentFramework
//
//  Created by fish on 2018/5/23.
//  Copyright © 2018年 Fish. All rights reserved.
//

#import "NSObject+Helper.h"
#import <objc/runtime.h>

@implementation NSObject (Helper)


+ (id)sp_decodeClass:(id)object decoder:(NSCoder *)aDecoder{
    if (!object) {
        return nil;
    }
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    for (NSInteger i = 0 ; i < count; i ++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        if ([attribute hasPrefix:@"TB"] || [attribute hasPrefix:@"Tc"]) {        // BOOL
            NSNumber *CXLBool_Number = @([aDecoder decodeBoolForKey:key]);
            [object setValue:CXLBool_Number forKey:key];
        } else if ([attribute hasPrefix:@"Tq"]) {                                //int64
            NSNumber *CXLInt64_Number = @([aDecoder decodeInt64ForKey:key]);
            [object setValue:CXLInt64_Number forKey:key];
        } else if ([attribute hasPrefix:@"Ti"]) {                                //int32
            NSNumber *CXLInt32_Nubmer = @([aDecoder decodeInt32ForKey:key]);
            [object setValue:CXLInt32_Nubmer forKey:key];
        } else if ([attribute hasPrefix:@"TQ"] || [attribute hasPrefix:@"TI"]) { //unInteger
            NSNumber *CXLUnInteger_Number = @([aDecoder decodeInt64ForKey:key]);
            [object setValue:CXLUnInteger_Number forKey:key];
        } else if ([attribute hasPrefix:@"Td"]) {                                //double
            NSNumber *CXLDouble_Number = @([aDecoder decodeDoubleForKey:key]);
            [object setValue:CXLDouble_Number forKey:key];
        } else if ([attribute hasPrefix:@"Tf"]) {                                //float
            NSNumber *CXLFloat_Number = @([aDecoder decodeFloatForKey:key]);
            [object setValue:CXLFloat_Number forKey:key];
        } else if ([attribute hasPrefix:@"T@"]) {                                //object
            [object setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        } else {
            [object setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    free(properties);
    
    return object;
}

+ (void)sp_encodeClass:(id)object encoder:(NSCoder *)aCoder{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    for (NSInteger i = 0 ; i < count; i ++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        //size_t integerSize = sizeof(NSInteger);
        if ([attribute hasPrefix:@"TB"] || [attribute hasPrefix:@"Tc"]) {        // BOOL
            NSNumber *CXLBOOL_Number = [object valueForKey:key];
            [aCoder encodeBool:CXLBOOL_Number.boolValue forKey:key];
        } else if ([attribute hasPrefix:@"Tq"]) {                                //int64
            NSNumber *CXLInt64_Number = [object valueForKey:key];
            [aCoder encodeInt64:CXLInt64_Number.integerValue forKey:key];
        } else if ([attribute hasPrefix:@"Ti"]) {                                //int32
            NSNumber *CXLInt32_Number = [object valueForKey:key];
            [aCoder encodeInt32:CXLInt32_Number.intValue forKey:key];
        } else if ([attribute hasPrefix:@"TQ"] || [attribute hasPrefix:@"TI"]) { //unInteger
            NSNumber *CXLUninteger_Number = [object valueForKey:key];
            [aCoder encodeInt64:CXLUninteger_Number.integerValue forKey:key];
        } else if ([attribute hasPrefix:@"Td"]) {                                //double
            NSNumber *CXLDouble_Number = [object valueForKey:key];
            [aCoder encodeDouble:CXLDouble_Number.doubleValue forKey:key];
        } else if ([attribute hasPrefix:@"Tf"]) {                                //float
            NSNumber *CXLFloat_Number = [object valueForKey:key];
            [aCoder encodeFloat:CXLFloat_Number.floatValue forKey:key];
        } else if ([attribute hasPrefix:@"T@"]) {                                //object
            [aCoder encodeObject:[object valueForKey:key] forKey:key];
        } else {
            [aCoder encodeObject:[object valueForKey:key] forKey:key];
        }
        
    }
    free(properties);
}

- (void)sp_setKeyPathValueByData:(NSMutableDictionary *)data IsCustomPriority:(BOOL)isCustomPriority{
    u_int count;
    //获取当前View的所有参数
    objc_property_t * properties  = class_copyPropertyList([self class], &count);
    //获取list文件进行keyPath 比对
    NSString *propertyForKeyPathRulesPath = [[NSBundle mainBundle] pathForResource:@"PropertyForKeyPathRules" ofType:@"plist"];
    // 获取keypath字典
    NSMutableDictionary *propertyForKeyPathRulesDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:propertyForKeyPathRulesPath];
    //循环遍历每一个参数获取对应的名字
    for (int i=0; i<count; i++) {
        //获取属性
        objc_property_t property = properties[i];
        //获取属性类型
        const char * propertyAttribute =property_getAttributes(property);
        //获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        //对属性类型进行判断(对默认设置了对应关系的属性进行赋值)
        for (NSString *key in propertyForKeyPathRulesDictionary.allKeys) {
            //判断key 值是否包含在属性中
            if ([[NSString stringWithUTF8String:propertyAttribute] containsString:key]) {
                //如果包含则设置value值
                NSString *keypath = [NSString stringWithFormat:@"%@%@", propertyName,propertyForKeyPathRulesDictionary[key]];
                //从给定的data字典中寻找对应参数的key如果存在，则进行赋值操作
                if ([data.allKeys containsObject:propertyName]) {
                    [self setValue:data[propertyName] forKeyPath:keypath];
                    //判断自定义的优先级，如果自定义优先级底则直接跳过
                    if (!isCustomPriority) {
                        continue;
                    }
                }
            }
        }
        //对自定义类型进行赋值
        if ([data.allKeys containsObject:propertyName]) {
            //如果给定的值是字典类型判断是否存在自定义keypath和value
            if ([data[propertyName] isKindOfClass:[NSDictionary class]]){
                NSDictionary *propertyValueAndKeyPathDictionary = data[propertyName];
                NSString    *keyPath    = nil;
                id          value       = nil;
                //获取路径
                if ([propertyForKeyPathRulesDictionary.allKeys containsObject:SPCustomKeyPath]) {
                    keyPath = propertyValueAndKeyPathDictionary[SPCustomKeyPath];
                }
                //获取值
                if ([propertyForKeyPathRulesDictionary.allKeys containsObject:SPCustomKeyPathValue]) {
                    value = propertyValueAndKeyPathDictionary[SPCustomKeyPathValue];
                }
                //进行赋值
                if (keyPath != nil && value != nil) {
                    [self setValue:value forKeyPath:keyPath];
                    //跳过进入下一轮
                    continue;
                }
            }
        }
        
        //对非自定义和非标准的进行赋值
        if ([data.allKeys containsObject:propertyName]) {
            id value = data[propertyName];
            if (value) {
                [self setValue:value forKey:propertyName];
            }
        }
    }
    free(properties);
    //自定义命令执行
}

//重写找不到key这种情况
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
