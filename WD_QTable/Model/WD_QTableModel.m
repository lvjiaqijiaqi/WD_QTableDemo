//
//  WD_QTableModel.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableModel.h"

@implementation WD_QTableModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _subTitle = @"";
        
        _sign = 0;
        _level = 0;
        
        _collapseRow = 1;
        _collapseCol = 1;
        
        _extraDic = [NSMutableDictionary dictionary];
        _sectionModel = nil;
        
        _cellType = WD_QTableCellTypeCellUnknown;
        _isPlace = NO;
        
        _childrenModels = nil;
        
    }
    return self;
}

-(NSString *)title{
    if (!_title) {
        return @"";
    }
    return _title;
}
-(NSString *)subTitle{
    if (!_subTitle) {
        return @"";
    }
    return _subTitle;
}

+(WD_QTableModel *)placeModel{
    WD_QTableModel * placeModel = [[self alloc] init];
    placeModel.collapseRow = 0;
    placeModel.collapseCol = 0;
    placeModel.isPlace = YES;
    return placeModel;
}

@end
