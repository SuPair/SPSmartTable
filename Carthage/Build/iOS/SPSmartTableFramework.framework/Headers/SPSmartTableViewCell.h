//
//  SPSmartTableViewCell.h
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPSmartCellRowModel.h"

@interface SPSmartTableViewCell : UITableViewCell

/**
 数据源
 */
@property (nonatomic, strong) SPSmartCellRowModel *cellValue;

/**
 所在位置
 */
@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@end
