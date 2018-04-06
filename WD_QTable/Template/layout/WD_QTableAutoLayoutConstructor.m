//
//  WD_QTableAutoLayoutConstructor.m
//  IHQ
//
//  Created by jqlv on 2018/2/26.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QTableAutoLayoutConstructor.h"

@implementation WD_QTableAutoLayoutConstructor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _RowsH = [NSMutableArray array];
        _colsW = [NSMutableArray array];
        _LeadingsH = [NSMutableArray array];
        _LeadingsW = [NSMutableArray array];
        _HeadingsH = [NSMutableArray array];
        _HeadingsW = [NSMutableArray array];
        _optmizeColsW = [NSMutableArray array];
    }
    return self;
}
-(CGFloat)rowHeightAtRowId:(NSInteger)rowId{
    if (self.RowsH.count > rowId) {
        return self.RowsH[rowId].floatValue;
    }else if(self.LeadingsH.count > rowId){
        return self.LeadingsH[rowId].floatValue;
    }
    return self.itemH;
}
-(CGFloat)colWidthAtcolId:(NSInteger)colId{
    if (self.optmizeColsW.count > colId) {
        return self.optmizeColsW[colId].floatValue;
    }else if(self.HeadingsW.count > colId){
        return self.HeadingsW[colId].floatValue;
    }
    return self.itemW;
}
-(CGFloat)leadingWAtLevel:(NSInteger)level{
    if (self.LeadingsW.count > level) {
        return self.LeadingsW[level].floatValue;
    }
    return self.itemW;
}
-(CGFloat)headingHAtLevel:(NSInteger)level{
    if (self.HeadingsH.count > level) {
        return self.HeadingsH[level].floatValue;
    }
    return self.itemH;
}
-(BOOL)adjustLayoutForNewFrame:(CGRect)frame colCount:(NSInteger)colCount andRowCount:(NSInteger)rowCount{
    return YES;
}
@end
