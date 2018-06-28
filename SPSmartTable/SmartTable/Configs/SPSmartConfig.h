//
//  SPSmartConfig.h
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSmartCellSectionModel.h"

#pragma mark Block 块函数


/**
 Cell高度回调函数

 @param indexPath 位置
 @param tableView table
 @return 高度
 */
typedef CGFloat (^SmartHeightForRowAtIndexPathCallBack)(NSIndexPath *indexPath, UITableView *tableView);
@interface SPSmartConfig : NSObject


/**
 智能表显示样式

 - SmartTableShowStylePlan: Plan样式同tableview
 - SmartTableShowStyleGroup: Group样式同tableview
 - SmartTableShowStyleFolding: 折叠样式
 */
typedef NS_ENUM(NSInteger, SmartTableShowStyle) {
    SmartTableShowStylePlan = 0,
    SmartTableShowStyleGroup,
    SmartTableShowStyleFolding
};


/**
 cell的选中模式，包含三种（主要设置isSelected属性）

 - SmartTableSelectedModelNone: 没有选中
 - SmartTableSelectedModelSingle: 单选
 - SmartTableSelectedModelMultiSelect: 多选
 */
typedef NS_ENUM(NSInteger, SmartTableSelectedModel) {
    SmartTableSelectedModelNone = 0,
    SmartTableSelectedModelSingle,
    SmartTableSelectedModelMultiSelect
};


/**
 section 配置数组，
 */
@property (nonatomic, strong)   NSMutableArray<SPSmartCellSectionModel *> *sectionItemConfigs;

/**
 空数据背景图片
 */
@property (nonatomic, strong)   UIImage   *placeholderImage;

/**
 空数据提示文字
 */
@property (nonatomic, copy)     NSString  *placeholderTitle;

/**
 设置table展示样式
 */
@property (nonatomic, assign)   SmartTableShowStyle smartTableShowStyle;

/**
 设置选中模式
 */
@property (nonatomic, assign)   SmartTableSelectedModel smartTableSelectedModel;

#pragma mark  Custom Method
- (instancetype)init;
@end
