//
//  SPSmartCellSectionModel.h
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSmartCellRowModel.h"



/**
 cell 点击回调函数
 
 @param cell 参数值
 @param indexPath 位置
 */
typedef void(^SPSmartCellSectionModelRowSelectedCallBack)(id cell, NSIndexPath *indexPath);

@interface SPSmartCellSectionModel : NSObject

/**
 Section header高度用于缓存
 */
@property (nonatomic, assign) float     heightForHeader;

/**
 Section header高度用于缓存
 */
@property (nonatomic, assign) float     heightForFooter;

/**
 Section header视图
 */
@property (nonatomic, strong) UIView    *sectionHeaderView;

/**
 Section footer视图
 */
@property (nonatomic, strong) UIView    *sectionFooterView;

/**
 cell 名字用于设置当前section下的row的cell name（必须设置，也可以在rowmodel中单独设置，row的优先级高于section）
 cell 名字支持xib和类名 xib优先于类名
 */
@property (nonatomic, copy) NSString    *cellNameInSection;

/**
 section 中cell的高度
 */
@property (nonatomic, assign) float     cellHeightInSection;

/**
 Section 配置数组，
 */
@property (nonatomic, strong) NSMutableArray<SPSmartCellRowModel *> *rowItemConfigs;

/**
 Section cell 点击回调
 */
@property (nonatomic, copy) SPSmartCellSectionModelRowSelectedCallBack smartCellSectionModelRowSelectedCallBack;

#pragma mark  Custom Method
- (instancetype)init;
@end
