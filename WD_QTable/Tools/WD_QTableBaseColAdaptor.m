//
//  WD_QTableBaseColAdaptor.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/13.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableBaseColAdaptor.h"

@implementation WD_QTableBaseColAdaptor

/*  data处理 */
-(void)commitDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models FromIndex:(NSInteger)index{
    if (models.count == 0) return;
    const NSInteger colsNum = models.count;
    const NSInteger rowsNum = models[0].count;
    /* 预设 */
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (index) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.colsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.RowsH];
    }
    for (NSInteger i = fitHeights.count ; i < rowsNum ; i++) {
        [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    for (NSInteger i = 0; i < colsNum ; i++) {
        [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    [models enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull cols, NSUInteger colIdx, BOOL * _Nonnull stop) {
        CGFloat fitWidth = [self fitColWidthToRowHeights:fitHeights ByRowModel:cols ForType:WD_QTableCellIdxItem AtCol:colIdx + index FromRow:0];
        if ([fitWidths[colIdx + index] floatValue] < fitWidth) {
            fitWidths[colIdx + index] = [NSNumber numberWithFloat:fitWidth];
        }
    }];
    self.layoutConstructor.RowsH = fitHeights;
    self.layoutConstructor.colsW = fitWidths;
}

@end
