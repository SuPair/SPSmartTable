//
//  SPSmartCellSectionModel.m
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import "SPSmartCellSectionModel.h"

@implementation SPSmartCellSectionModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.heightForHeader = 0;
        self.heightForFooter = 0;
        self.sectionHeaderView = nil;
        self.sectionFooterView = nil;
        self.rowItemConfigs = [NSMutableArray array];
        self.cellNameInSection = nil;
        self.cellHeightInSection = 0;
        self.smartCellSectionModelRowSelectedCallBack = nil;
    }
    return self;
}

@end
