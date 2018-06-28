//
//  SPSmartTable.m
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import "SPSmartTable.h"
#import "SPSmartTableViewCell.h"

@interface SPSmartTable()
@property (nonatomic, strong) NSMutableArray *selcetdCellIndexPath;

@end


@implementation SPSmartTable

- (instancetype)init{
    self = [super init];
    if (self) {
        [self sp_initilizeProperty];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sp_initilizeProperty];
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@">>>frame%@",NSStringFromCGRect(self.frame));
}

- (void)drawRect:(CGRect)rect{
    NSLog(@">>>%@",NSStringFromCGRect(rect));
    //重写view的大小
    self.sTable.frame = rect;
}


/**
 参数初始化
 */
- (void)sp_initilizeProperty{
    self.sTable = nil;
    self.dataSources = [NSMutableArray array];
    self.sConfig = nil;
    self.selcetdCellIndexPath = [NSMutableArray array];
}


/**
 table初始化
 */
- (void)sp_initilizeSmartTable{
    //配置为空或者已经初始化就不再初始化
    if (self.sConfig == nil || self.sTable != nil) {
        return;
    }
    
    //设置table样式
    if (self.sConfig.smartTableShowStyle == SmartTableShowStylePlan || self.sConfig.smartTableShowStyle == SmartTableShowStyleFolding) {
        //平铺样式
        self.sTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }else{
        //分组样式
        self.sTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    //注册cell
    for (SPSmartCellSectionModel *section in self.sConfig.sectionItemConfigs) {
        if (section.cellNameInSection != nil) {
            //注册cell
            [self registCellForTable:self.sTable CellName:section.cellNameInSection];
            //注册里面的cell的模型的cellname
            for (SPSmartCellRowModel *row in section.rowItemConfigs) {
                if (row.cellName) {
                    [self registCellForTable:self.sTable CellName:row.cellName];
                }
            }
        }else{
            NSAssert(NO, @"section的cellname不能为空");
        }
    }
    
    //配置table
    self.sTable.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉线
    self.sTable.delegate = self;
    self.sTable.dataSource = self;
    //设置自适应高度
    self.sTable.backgroundColor = [UIColor clearColor];
    //添加到view
    [self addSubview:self.sTable];
}


/**
 将cell注册到table

 @param table table
 @param cellName 要注册的cell名字
 */
- (void)registCellForTable:(nonnull UITableView *)table CellName:(nonnull NSString *)cellName{
    UINib *cellNib = [UINib nibWithNibName:cellName bundle:[NSBundle mainBundle]];
    if (cellNib) {
        //注册xib
        [table registerNib:cellNib forCellReuseIdentifier:cellName];
    }else{
        //检查class 是否存在
        [table registerClass:NSClassFromString(cellName) forCellReuseIdentifier:cellName];
    }
}


#pragma mark setter方法重写
- (void)setSConfig:(SPSmartConfig *)sConfig{
    _sConfig = sConfig;
    //初始化表格
    [self sp_initilizeSmartTable];
}

#pragma mark 代理方法

#pragma mark Table代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.sConfig) {
        if (self.sConfig.sectionItemConfigs) {
            return self.sConfig.sectionItemConfigs.count;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sConfig) {
        if (self.sConfig.sectionItemConfigs) {
            if (self.sConfig.sectionItemConfigs.count > section) {
                SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[section];
                if (cellSection.rowItemConfigs) {
                    return cellSection.rowItemConfigs.count;
                }
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.sConfig) {
        if (self.sConfig.sectionItemConfigs) {
            if (self.sConfig.sectionItemConfigs.count > section) {
                SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[section];
                return cellSection.heightForHeader;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.sConfig) {
        if (self.sConfig.sectionItemConfigs) {
            if (self.sConfig.sectionItemConfigs.count > section) {
                SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[section];
                return cellSection.heightForFooter;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.sConfig) {
        if (self.sConfig.sectionItemConfigs) {
            if (self.sConfig.sectionItemConfigs.count > section) {
                SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[section];
                return cellSection.sectionHeaderView;
            }
        }
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.sConfig) {
        if (self.sConfig.sectionItemConfigs) {
            //防止数组越界
            if (self.sConfig.sectionItemConfigs.count > section) {
                SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[section];
                return cellSection.sectionFooterView;
            }else{
                printf("数组存在越界");
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sTable) {
        if (self.sConfig.sectionItemConfigs) {
            SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[indexPath.section];
            //获取单个cell数据
            if (cellSection) {
                if (cellSection.rowItemConfigs) {
                    if (cellSection.rowItemConfigs.count > indexPath.row) {
                        //获取单个数据
                        SPSmartCellRowModel *row = cellSection.rowItemConfigs[indexPath.row];
                        if (row) {
                            return (CGFloat)row.cellHeight;
                        }
                    }
                }
                return (CGFloat)cellSection.cellHeightInSection;
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = nil;
    SPSmartCellRowModel *rowModel = nil;
    //获取cellname
    if (self.sTable) {
        if (self.sConfig.sectionItemConfigs) {
            SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[indexPath.section];
            //获取单个cell数据
            if (cellSection) {
                if (cellSection.rowItemConfigs) {
                    if (cellSection.rowItemConfigs.count > indexPath.row) {
                        //获取单个数据
                        rowModel = cellSection.rowItemConfigs[indexPath.row];
                        if (rowModel.cellName) {
                            cellName = rowModel.cellName;
                        }
                    }
                }
                if (cellName == nil) {
                    cellName = cellSection.cellNameInSection;
                }
            }
        }
    }
    if (cellName == nil) {
        NSAssert(NO, @"没有找到cell名字");
        return nil;
    }
    
    SPSmartTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [self loadNibByName:cellName];
    }
    
    //设置值
    if (rowModel) {
        cell.cellIndexPath = indexPath;
        cell.cellValue = rowModel;
    }
    
    //根据选中模式来进行配置
    if (self.sConfig.smartTableSelectedModel != SmartTableSelectedModelNone) {
        //设置默认颜色
        if (rowModel.cellDefaultColor) {
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = rowModel.cellDefaultColor;
        }
        
        //设置选中颜色
        if (rowModel.cellSelectedColor && rowModel.isSelected) {
            cell.selected = YES;
            //设置默认选中
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPSmartCellRowModel *rowModel = nil;
    SPSmartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.sTable) {
        if (self.sConfig.sectionItemConfigs) {
            SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[indexPath.section];
            //获取单个cell数据
            if (cellSection) {
                if (cellSection.rowItemConfigs) {
                    if (cellSection.rowItemConfigs.count > indexPath.row) {
                        //获取单个数据
                        rowModel = cellSection.rowItemConfigs[indexPath.row];
                    }
                }
            }
        }
    }
    //点击事件调用
    if (cell.cellValue.smartCellRowModelSelectedCallBack) {
        cell.cellValue.smartCellRowModelSelectedCallBack(cell.cellValue.cellValue, indexPath);
    }else{
        if (self.sTable) {
            if (self.sConfig.sectionItemConfigs) {
                SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[indexPath.section];
                //获取单个cell数据
                if (cellSection) {
                    //点击回调
                    if (cellSection.smartCellSectionModelRowSelectedCallBack) {
                        cellSection.smartCellSectionModelRowSelectedCallBack(cell, indexPath);
                    }
                }
            }
        }
    }
    //选择事件
    if (self.sConfig.smartTableSelectedModel == SmartTableSelectedModelSingle) {
        //设置默认颜色（颜色和默认选中）
        if (rowModel.cellSelectedColor) {
            cell.selected = YES;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = rowModel.cellSelectedColor;
        }
    }
    
    //多选
    if (self.sConfig.smartTableSelectedModel == SmartTableSelectedModelMultiSelect) {
        
        //设置默认颜色
        if (rowModel.cellSelectedColor) {
            cell.selected = YES;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = rowModel.cellSelectedColor;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPSmartCellRowModel *rowModel = nil;
    SPSmartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.sTable) {
        if (self.sConfig.sectionItemConfigs) {
            SPSmartCellSectionModel *cellSection = self.sConfig.sectionItemConfigs[indexPath.section];
            //获取单个cell数据
            if (cellSection) {
                if (cellSection.rowItemConfigs) {
                    if (cellSection.rowItemConfigs.count > indexPath.row) {
                        //获取单个数据
                        rowModel = cellSection.rowItemConfigs[indexPath.row];
                    }
                }
            }
        }
    }
    if (self.sConfig.smartTableSelectedModel == SmartTableSelectedModelSingle) {
        //设置默认颜色
        if (rowModel.cellDefaultColor) {
            cell.selected = NO;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = rowModel.cellDefaultColor;
        }
    }
}

- (id)loadNibByName:(NSString *)name{
    return [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject];
}
@end
