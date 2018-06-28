//
//  SPSmartConfig.m
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import "SPSmartConfig.h"

@implementation SPSmartConfig
- (instancetype)init{
    self = [super init];
    if (self) {
        self.sectionItemConfigs = [NSMutableArray array];
        self.smartTableSelectedModel = SmartTableSelectedModelNone;
    }
    return self;
}
@end
