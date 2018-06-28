//
//  SPSmartCellModel.m
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import "SPSmartCellRowModel.h"

@implementation SPSmartCellRowModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellHeight = 0;
        self.cellRow = 0;
        self.cellSection = 0;
        self.cellName = nil;
        self.cellValue = nil;
        self.cellSelectedColor = nil;
        self.cellDefaultColor = nil;
        self.isSelected = NO;
        self.smartCellRowModelSelectedCallBack = nil;
    }
    return self;
}

@end
