//
//  WD_QTableAdaptor.m
//  IHQ
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QTableAdaptor.h"

#import "WD_QTableModel.h"

#import "WD_QTableBaseViewCell.h"
#import "WD_QTableBaseReusableView.h"

@interface WD_QTableAdaptor()

@property(nonatomic,strong) NSMutableDictionary *reuseDic;

@end

@implementation WD_QTableAdaptor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _MaxRowW = 150.f;
        _MinRowW = 60.f;
        _defaultRowH = 40.f;
    }
    return self;
}

-(instancetype)initWithTableStyle:(id<WD_QTableStyleConstructorDelegate>)style ToLayout:(WD_QTableAutoLayoutConstructor *)layout;
{
    self = [self init];
    if (self) {
        self.styleConstructor = style;
        self.layoutConstructor = layout;
        self.reuseDic = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)commitChange{
    // 表头和数据布局合并
     self.layoutConstructor.colsW = [self mergeMaxValueToArr:self.layoutConstructor.colsW FromArr:self.layoutConstructor.HeadingsW];
     self.layoutConstructor.RowsH = [self mergeMaxValueToArr:self.layoutConstructor.RowsH FromArr:self.layoutConstructor.LeadingsH];
     
     // 贴边处理
     __block CGFloat leadingsW = 0.f;
     [self.layoutConstructor.LeadingsW enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     leadingsW += obj.floatValue;
     }];
    self.layoutConstructor.optmizeColsW = self.layoutConstructor.colsW;
     //self.layoutConstructor.optmizeColsW = [self optimizeWidth:self.layoutConstructor.colsW ByContainerWidth:CGRectGetWidth(models.frame) - leadingsW];
     //[self.reuseDic removeAllObjects];
}

-(void)addHeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)Headings AtRange:(NSRange)range{
    NSInteger index = range.location;
    if (Headings.count == 0) {
        [self.layoutConstructor.HeadingsW removeObjectsInRange:range];
        return;
    }
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (self.layoutConstructor.HeadingsW.count) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.HeadingsW];
    }
    if (self.layoutConstructor.HeadingsH.count) {
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.HeadingsH];
    }
    NSInteger colsNum = [Headings lastObject].count;
    NSInteger level = Headings.count;
    for (NSInteger i = fitHeights.count; i < level; i++) {
        [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    [fitWidths removeObjectsInRange:range];
    for (NSInteger i = 0; i < colsNum ; i++) {
        [fitWidths insertObject:[NSNumber numberWithFloat:self.MinRowW] atIndex:i+index];
    }
    [Headings enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [self fitRowHeightToColsWidth:fitWidths ByRowModel:obj ForType:WD_QTableCellIdxHeading AtRowId:idx FromCol:index];
        if (fitHeights[idx].floatValue < height) {
            fitHeights[idx] = [NSNumber numberWithFloat:height];
        }
    }];
    self.layoutConstructor.HeadingsW = fitWidths;
    self.layoutConstructor.HeadingsH = fitHeights;
}
-(void)addLeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)leadings AtRange:(NSRange)range{
    NSInteger index = range.location;
    if (leadings.count == 0) {
        [self.layoutConstructor.LeadingsH removeObjectsInRange:range];
        return;
    }
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (self.layoutConstructor.LeadingsW.count) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.LeadingsW];
    }
    if (self.layoutConstructor.LeadingsH.count) {
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.LeadingsH];
    }
    NSInteger rowNum = [leadings lastObject].count;
    NSInteger level = leadings.count;
    for (NSInteger i = fitWidths.count; i < level; i++) {
        [fitWidths addObject:[NSNumber numberWithFloat:self.MinRowW]]; //预设
    }
    [fitHeights removeObjectsInRange:range];
    for (NSInteger i = 0; i < rowNum ; i++) {
        [fitHeights insertObject:[NSNumber numberWithFloat:self.defaultRowH] atIndex:i+index];
    }
    [leadings enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self fitColWidthToRowHeights:fitHeights ByRowModel:obj ForType:WD_QTableCellIdxLeading AtCol:idx FromRow:index];
        if (fitWidths[idx].floatValue < width ) {
            fitWidths[idx] = [NSNumber numberWithFloat:width];
        }
    }];
    self.layoutConstructor.LeadingsH = fitHeights;
    self.layoutConstructor.LeadingsW = fitWidths;
}
/*  data处理 */
-(void)addDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models AtRowRange:(NSRange)range{
    NSInteger index = range.location;
    if (models.count == 0) {
        if (index < self.layoutConstructor.RowsH.count) {
            [self.layoutConstructor.RowsH removeObjectAtIndex:index];
        }
        return;
    }
    const NSInteger colsNum = models[0].count;
    const NSInteger rowsNum = models.count;
    /* 预设 */
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (self.layoutConstructor.colsW.count) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.colsW];
    }
    if (self.layoutConstructor.RowsH) {
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.RowsH];
    }
    for (NSInteger i = 1 ; i <= colsNum ; i++) {
        if (i > self.layoutConstructor.colsW.count) {
            [fitWidths addObject:[NSNumber numberWithFloat:self.MinRowW]]; //预设
        }
    }
    [fitHeights removeObjectsInRange:range];
    for (NSInteger i = 0; i < rowsNum ; i++) {
        [fitHeights insertObject:[NSNumber numberWithFloat:self.defaultRowH] atIndex:i + index];
    }
    [models enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull rows, NSUInteger rowIdx, BOOL * _Nonnull stop) {
        CGFloat fitHeight = [self fitRowHeightToColsWidth:fitWidths ByRowModel:rows ForType:WD_QTableCellIdxItem AtRowId:rowIdx + index FromCol:0];
        if ([fitHeights[rowIdx] floatValue] < fitHeight) {
            fitHeights[rowIdx] = [NSNumber numberWithFloat:fitHeight];
        }
    }];
    self.layoutConstructor.RowsH = fitHeights;
    self.layoutConstructor.colsW = fitWidths;
}

-(void)addDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models AtColRange:(NSRange)range{
    NSInteger index = range.location;
    if (models.count == 0){
        [self.layoutConstructor.colsW removeObjectAtIndex:index];
        return;
    }
    const NSInteger colsNum = models.count;
    const NSInteger rowsNum = models[0].count;
    /* 预设 */
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (self.layoutConstructor.colsW.count) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.colsW];
    }
    if (self.layoutConstructor.RowsH) {
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.RowsH];
    }
    for (NSInteger i = 1 ; i <= rowsNum ; i++) {
        if (i > self.layoutConstructor.RowsH.count) {
            [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
        }
    }
    [fitWidths removeObjectsInRange:range];
    for (NSInteger i = 0; i < colsNum ; i++) {
        [fitWidths insertObject:[NSNumber numberWithFloat:self.MinRowW] atIndex:i + index];
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

-(void)addDataUpdate:(WD_QTableModel *)model AtRow:(NSInteger)rowId InCol:(NSInteger)colId{
    CGFloat width = [self fitWidthOf:WD_QTableCellIdxItem ForHeight:self.defaultRowH * model.collapseRow  ByModel:model AtIndex:[NSIndexPath indexPathForRow:rowId inSection:colId]];
    width = width - self.MinRowW * (model.collapseCol - 1);
    CGFloat height = self.defaultRowH;
    if (width > self.MaxRowW) { //大于max，需要fit高度
        width = self.MaxRowW;
        height = [self fitHeightOf:WD_QTableCellIdxItem ForWidth:self.MaxRowW * model.collapseCol ByModel:model AtIndex:[NSIndexPath indexPathForRow:rowId inSection:colId]];
        height = height - (model.collapseRow - 1) * self.defaultRowH;
    }else if(width < self.MinRowW){
        width = self.MinRowW;
    }
    if (self.layoutConstructor.colsW[colId].floatValue < width) {
        self.layoutConstructor.colsW[colId] = [NSNumber numberWithFloat:width];
    }
    if (self.layoutConstructor.RowsH[rowId].floatValue < height) {
        self.layoutConstructor.RowsH[rowId] = [NSNumber numberWithFloat:height];
    }
}

-(void)addLeadingUpdate:(WD_QTableModel *)model AtRow:(NSInteger)rowId InLevel:(NSInteger)levelId{
    CGFloat width = [self fitWidthOf:WD_QTableCellIdxLeading ForHeight:self.defaultRowH * model.collapseRow  ByModel:model AtIndex:[NSIndexPath indexPathForRow:rowId inSection:levelId]];
    width = width - self.MinRowW * (model.collapseCol - 1);
    CGFloat height = self.defaultRowH;
    if (width > self.MaxRowW) { //大于max，需要fit高度
        width = self.MaxRowW;
        height = [self fitHeightOf:WD_QTableCellIdxItem ForWidth:self.MaxRowW * model.collapseCol ByModel:model AtIndex:[NSIndexPath indexPathForRow:rowId inSection:levelId]];
        height = height - (model.collapseRow - 1) * self.defaultRowH;
    }else if(width < self.MinRowW){
        width = self.MinRowW;
    }
    if (self.layoutConstructor.LeadingsW[levelId].floatValue < width) {
        self.layoutConstructor.LeadingsW[levelId] = [NSNumber numberWithFloat:width];
    }
    if (self.layoutConstructor.LeadingsH[rowId].floatValue < height) {
        self.layoutConstructor.LeadingsH[rowId] = [NSNumber numberWithFloat:height];
    }
}
-(void)addHeadingUpdate:(WD_QTableModel *)model AtCol:(NSInteger)colId InLevel:(NSInteger)levelId{
    CGFloat width = [self fitWidthOf:WD_QTableCellIdxHeading ForHeight:self.defaultRowH * model.collapseRow  ByModel:model AtIndex:[NSIndexPath indexPathForRow:colId inSection:levelId]];
    width = width - self.MinRowW * (model.collapseCol - 1);
    CGFloat height = self.defaultRowH;
    if (width > self.MaxRowW) { //大于max，需要fit高度
        width = self.MaxRowW;
        height = [self fitHeightOf:WD_QTableCellIdxHeading ForWidth:self.MaxRowW * model.collapseCol ByModel:model AtIndex:[NSIndexPath indexPathForRow:colId inSection:levelId]];
        height = height - (model.collapseRow - 1) * self.defaultRowH;
    }else if(width < self.MinRowW){
        width = self.MinRowW;
    }
    if (self.layoutConstructor.HeadingsW[colId].floatValue < width) {
        self.layoutConstructor.HeadingsW[colId] = [NSNumber numberWithFloat:width];
    }//修改记录
    if (self.layoutConstructor.HeadingsH[levelId].floatValue < height) {
        self.layoutConstructor.HeadingsH[levelId] = [NSNumber numberWithFloat:height];
    }
}

#pragma mark - 适配行高
/*  取最大宽度 并且用min max去限制 */
/*-(CGFloat)adjustWidthForOriginWidth:(CGFloat)originWidth ByExtraWidth:(CGFloat)extraWidth{
 CGFloat resWidth = extraWidth;
 if (resWidth > self.MaxRowW) { //大于max，需要fit高度
 resWidth = self.MaxRowW;
 }else if(resWidth < originWidth){
 resWidth = originWidth;
 }
 return resWidth;
 }*/

-(CGFloat)fitRowHeightToColsWidth:(NSMutableArray<NSNumber *> *)adjustFitWidths ByRowModel:(NSArray<WD_QTableModel *> *)models ForType:(NSInteger)type AtRowId:(NSInteger)rowId FromCol:(NSInteger)colId{
    NSMutableIndexSet *overMaxWCellIndexs =  [[NSMutableIndexSet alloc] init];
    [models enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isPlace && obj.collapseCol) {
            CGFloat width = [self fitWidthOf:type ForHeight:self.defaultRowH * obj.collapseRow ByModel:obj AtIndex:[NSIndexPath indexPathForRow:rowId inSection:idx + colId]];
            CGFloat finalWidth = width - (obj.collapseCol - 1) * self.MinRowW;
            if(finalWidth > self.MaxRowW) {
                [overMaxWCellIndexs addIndex:idx];
                finalWidth = self.MaxRowW;
            }else{
                if (finalWidth < self.MinRowW) {
                    finalWidth = self.MinRowW;
                }
            }
            if (finalWidth > adjustFitWidths[idx].floatValue) {
                adjustFitWidths[idx] = [NSNumber numberWithFloat:finalWidth];
            }
        }
    }];
    /*NSInteger idx = 0;
     while (idx < models.count) {
     WD_QTableModel * _Nonnull obj = models[idx];
     if (!obj.isPlace) {
     //计算宽度
     CGFloat width = [self fitWidthOf:type ForHeight:self.defaultRowH ByModel:obj AtIndex:[NSIndexPath indexPathForRow:rowId inSection:idx + colId]] / obj.collapseCol;
     if(width > self.MaxRowW) [overMaxWCellIndexs addIndex:idx];
     for (NSInteger collpsCol = 0; collpsCol < obj.collapseCol; collpsCol++) {
     CGFloat resWidth = [self adjustWidthForOriginWidth:adjustFitWidths[idx + collpsCol].floatValue ByExtraWidth:width];
     adjustFitWidths[idx + collpsCol] = [NSNumber numberWithFloat:ceil(resWidth)];
     }
     idx = idx + obj.collapseCol;
     }else{
     idx++;
     }
     }*/
    //宽度溢出的，计算行高
    __block CGFloat fitHeight = self.defaultRowH;
    [overMaxWCellIndexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat allWidth = self.MinRowW * (models[idx].collapseCol - 1) + adjustFitWidths[idx + colId].floatValue;
        CGFloat height = [self fitHeightOf:type ForWidth:allWidth ByModel:models[idx] AtIndex:[NSIndexPath indexPathForRow:rowId inSection:idx + colId]];
        height = height - (models[idx].collapseRow - 1) * self.defaultRowH;
        if (fitHeight < height) {
            fitHeight = height;
        }
    }];
    return fitHeight; //返回最新行高
}
#pragma mark - 适配列宽
-(CGFloat)fitColWidthToRowHeights:(NSMutableArray<NSNumber *> *)adjustFitHeigths ByRowModel:(NSArray<WD_QTableModel *> *)models ForType:(NSInteger)type AtCol:(NSInteger)colId FromRow:(NSInteger)rowId{
    __block CGFloat optmizeWidth = self.MinRowW;
    [models enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self fitWidthOf:type ForHeight:self.defaultRowH * obj.collapseRow  ByModel:obj AtIndex:[NSIndexPath indexPathForRow:idx + rowId inSection:colId]];
        width = width - self.MinRowW * (obj.collapseCol - 1);
        if (width > self.MaxRowW) { //大于max，需要fit高度
            width = self.MaxRowW;
        }else if(width < optmizeWidth){
            width = optmizeWidth;
        }
        optmizeWidth = width;
        if (optmizeWidth >= self.MaxRowW) {
            *stop = YES;
        }
    }];
    //宽度溢出的，拉升行高
    [models enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [self fitHeightOf:type ForWidth:optmizeWidth + (self.MinRowW * (obj.collapseCol - 1)) ByModel:models[idx] AtIndex:[NSIndexPath indexPathForRow:idx + rowId inSection:colId]] / obj.collapseRow;
        if (height > self.defaultRowH) {
            adjustFitHeigths[idx + rowId] = [NSNumber numberWithFloat:height];
            /*for (NSInteger i = 0; i < obj.collapseRow; i++) {
             adjustFitHeigths[idx + i + rowId] = [NSNumber numberWithFloat:height];
             }*/
        }
    }];
    return optmizeWidth;
    
}
#pragma mark - 计算宽度
-(CGFloat)fitWidthOf:(NSInteger)type ForHeight:(CGFloat)height ByModel:(WD_QTableModel *)model AtIndex:(NSIndexPath *)indexPath{
    __block CGFloat resValue = 0.f;
    if (type == WD_QTableCellIdxItem) {
        NSString *className = [self.styleConstructor itemCollectionViewCellIdentifier:indexPath];
        WD_QTableBaseViewCell *reuseCell = self.reuseDic[className];
        if (!reuseCell) {
            Class qTableCellClass = NSClassFromString(className);
            reuseCell = [[qTableCellClass alloc] init];
        }
        [self.styleConstructor constructItemCollectionView:reuseCell By:model];
        resValue = [reuseCell sizeThatFitWidthByHeight:height];
    }if (type == WD_QTableCellIdxLeading){
        NSString *className = [self.styleConstructor leadingSupplementaryIdentifier:indexPath];
        WD_QTableBaseViewCell *reuseCell = self.reuseDic[className];
        if (!reuseCell) {
            Class qTableCellClass = NSClassFromString(className);
            reuseCell = [[qTableCellClass alloc] init];
        }
        [self.styleConstructor constructLeadingSupplementary:reuseCell By:model];
        resValue = [reuseCell sizeThatFitWidthByHeight:height];
    }else if (type == WD_QTableCellIdxHeading){
        NSIndexPath *modifyIndex = [NSIndexPath indexPathForRow:indexPath.section inSection:indexPath.row];
        NSString *className = [self.styleConstructor headingSupplementaryCellIdentifier:modifyIndex];
        WD_QTableBaseViewCell *reuseCell = self.reuseDic[className];
        if (!reuseCell) {
            Class qTableCellClass = NSClassFromString(className);
            reuseCell = [[qTableCellClass alloc] init];
        }
        [self.styleConstructor constructHeadingSupplementary:reuseCell By:model];
        resValue = [reuseCell sizeThatFitWidthByHeight:height];
    }
    return resValue;
}
#pragma mark - 计算高度
-(CGFloat)fitHeightOf:(NSInteger)type ForWidth:(CGFloat)width ByModel:(WD_QTableModel *)model AtIndex:(NSIndexPath *)indexPath{
    __block CGFloat resValue = 0.f;
    if (type == WD_QTableCellIdxItem) {
        NSString *className = [self.styleConstructor itemCollectionViewCellIdentifier:indexPath];
        WD_QTableBaseViewCell *reuseCell = self.reuseDic[className];
        if (!reuseCell) {
            Class qTableCellClass = NSClassFromString(className);
            reuseCell = [[qTableCellClass alloc] init];
        }
        [self.styleConstructor constructItemCollectionView:reuseCell By:model];
        resValue = [reuseCell sizeThatFitHeighByWidth:width];
    }if (type == WD_QTableCellIdxLeading){
        NSString *className = [self.styleConstructor leadingSupplementaryIdentifier:indexPath];
        WD_QTableBaseViewCell *reuseCell = self.reuseDic[className];
        if (!reuseCell) {
            Class qTableCellClass = NSClassFromString(className);
            reuseCell = [[qTableCellClass alloc] init];
        }
        [self.styleConstructor constructLeadingSupplementary:reuseCell By:model];
        resValue = [reuseCell sizeThatFitHeighByWidth:width];
    }else if (type == WD_QTableCellIdxHeading){
        NSIndexPath *modifyIndex = [NSIndexPath indexPathForRow:indexPath.section inSection:indexPath.row];
        NSString *className = [self.styleConstructor headingSupplementaryCellIdentifier:modifyIndex];
        WD_QTableBaseViewCell *reuseCell = self.reuseDic[className];
        if (!reuseCell) {
            Class qTableCellClass = NSClassFromString(className);
            reuseCell = [[qTableCellClass alloc] init];
        }
        [self.styleConstructor constructHeadingSupplementary:reuseCell By:model];
        resValue = [reuseCell sizeThatFitHeighByWidth:width];
    }
    return resValue;
}

#pragma mark - mergeArrayMax

-(NSMutableArray *)mergeMaxValueToArr:(NSArray<NSNumber *> *)mainArr FromArr:(NSArray<NSNumber *> *)subArr{
    NSMutableArray *resArr = [NSMutableArray arrayWithArray:mainArr];
    [mainArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subArr.count > idx) {
            if (subArr[idx].floatValue > obj.floatValue) {
                resArr[idx] = [NSNumber numberWithFloat:subArr[idx].floatValue];
            }
        }else{
            *stop = YES;
        }
    }];
    return resArr;
}

-(NSArray<NSNumber *> *)optimizeWidth:(NSMutableArray<NSNumber *> *)widths ByContainerWidth:(CGFloat)width{
    __block CGFloat allWidth = 0.f;
    NSMutableArray<NSNumber *> *optmizeWidths = [NSMutableArray array];
    [widths enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        allWidth += obj.floatValue;
    }];
    if (width > allWidth) {
        CGFloat ratio = width / allWidth;
        [widths enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [optmizeWidths addObject:[NSNumber numberWithFloat:ratio * obj.floatValue]];
        }];
        return [optmizeWidths copy];
    }else{
        return [widths copy];
    }
}
@end
