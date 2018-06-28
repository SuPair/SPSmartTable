//
//  SPSmartCellModel.h
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 cell 点击回调函数

 @param value 参数值
 @param indexPath 位置
 */
typedef void(^SPSmartCellRowModelSelectedCallBack)(id value, NSIndexPath *indexPath);

@interface SPSmartCellRowModel : NSObject


/**
 cell 高度用于缓存
 */
@property (nonatomic, assign) float     cellHeight;

/**
 cell 适用于的section
 */
@property (nonatomic, assign) float     cellSection;

/**
 cell 适用于的row
 */
@property (nonatomic, assign) float     cellRow;

/**
 cell 名字
 */
@property (nonatomic, copy) NSString    *cellName;

/**
 cell 值
 */
@property (nonatomic, strong)     id    cellValue;

/**
 设置未选中颜色
 */
@property (nonatomic, strong) UIColor   *cellDefaultColor;

/**
 设置选中颜色
 */
@property (nonatomic, strong) UIColor   *cellSelectedColor;

/**
 设置是否被选中
 */
@property (nonatomic, assign) BOOL      isSelected;


/**
 cell 点击回调
 */
@property (nonatomic, copy) SPSmartCellRowModelSelectedCallBack smartCellRowModelSelectedCallBack;



#pragma mark  Custom Method
- (instancetype)init;
@end
