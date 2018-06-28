//
//  SPSmartTableViewCell.m
//  SPSmartTable
//
//  Created by fish on 2018/6/28.
//  Copyright © 2018年 supan. All rights reserved.
//

#import "SPSmartTableViewCell.h"
#import "NSObject+Helper.h"

@implementation SPSmartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellValue:(SPSmartCellRowModel *)cellValue{
    _cellValue = cellValue;
    [self sp_setKeyPathValueByData:_cellValue.cellValue IsCustomPriority:YES];
}

@end
