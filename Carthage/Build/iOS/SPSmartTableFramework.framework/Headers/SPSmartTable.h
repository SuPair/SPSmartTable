//
//  SPSmartTable.h
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPSmartConfig.h"

@interface SPSmartTable : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)   UITableView     *sTable;

/**
 数据源
 */
@property (nonatomic, strong)   NSMutableArray  *dataSources;

/**
 配置
 */
@property (nonatomic, strong)   SPSmartConfig   *sConfig;
@end
