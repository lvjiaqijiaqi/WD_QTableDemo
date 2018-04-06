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
        _MinxRowW = 60.f;
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

-(void)commitChange:(WD_QViewModel *)models FromIndex:(NSInteger)index{
    if (models.headings.count) {
        [self commitHeadingChange:models.headings FromIndex:index];
    }
    if (models.leadings.count) {
        [self commitLeadingChange:models.leadings FromIndex:index];
    }
    if (models.datas.count) {
        [self commitDataChange:models.datas FromIndex:index];
    }
    /*表头和数据布局合并*/
    self.layoutConstructor.colsW = [self mergeMaxValueToArr:self.layoutConstructor.colsW FromArr:self.layoutConstructor.HeadingsW];
    self.layoutConstructor.RowsH = [self mergeMaxValueToArr:self.layoutConstructor.RowsH FromArr:self.layoutConstructor.LeadingsH];
    
    /* 贴边处理 */
    __block CGFloat leadingsW = 0.f;
    [self.layoutConstructor.LeadingsW enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        leadingsW += obj.floatValue;
    }];
    self.layoutConstructor.optmizeColsW = [self optimizeWidth:self.layoutConstructor.colsW ByContainerWidth:CGRectGetWidth(models.frame) - leadingsW];
    
    [self.reuseDic removeAllObjects];
    
}
-(void)commitHeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)Headings FromIndex:(NSInteger)index{
    if (Headings.count == 0) return;
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (index) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.HeadingsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.HeadingsH];
    }
    NSInteger colsNum = [Headings lastObject].count;
    NSInteger level = Headings.count;
    for (NSInteger i = fitHeights.count; i < level; i++) {
        [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    for (NSInteger i = 0; i < colsNum ; i++) {
        [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    [Headings enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [self fitRowHeightToColsWidth:fitWidths ByRowModel:obj ForType:WD_QTableCellIdxHeading AtRowId:idx FromCol:index];
        fitHeights[idx] = [NSNumber numberWithFloat:height];
    }];
    self.layoutConstructor.HeadingsW = fitWidths;
    self.layoutConstructor.HeadingsH = fitHeights;
}
-(void)commitLeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)leadings FromIndex:(NSInteger)index{
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (index) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.LeadingsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.LeadingsH];
    }
    NSInteger rowNum = [leadings lastObject].count;
    NSInteger level = leadings.count;
    for (NSInteger i = fitWidths.count; i < level; i++) {
        [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    for (NSInteger i = 0; i < rowNum ; i++) {
        [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    [leadings enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self fitColWidthToRowHeights:fitHeights ByRowModel:obj ForType:WD_QTableCellIdxLeading AtCol:idx FromRow:index];
        fitWidths[idx] = [NSNumber numberWithFloat:width];
    }];
    self.layoutConstructor.LeadingsH = fitHeights;
    self.layoutConstructor.LeadingsW = fitWidths;
}
/*  data处理 */
-(void)commitDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models FromIndex:(NSInteger)index{
    if (models.count == 0) return;
    const NSInteger colsNum = models[0].count;
    const NSInteger rowsNum = models.count;
    /* 预设 */
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (index) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.colsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.RowsH];
    }
    for (NSInteger i = fitWidths.count ; i < colsNum ; i++) {
        [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    for (NSInteger i = 0; i < rowsNum ; i++) {
        [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
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

#pragma mark - 适配行高

/*  取最大宽度 并且用min max去限制 */
-(CGFloat)adjustWidthForOriginWidth:(CGFloat)originWidth ByExtraWidth:(CGFloat)extraWidth{
    CGFloat resWidth = extraWidth;
    if (resWidth > self.MaxRowW) { //大于max，需要fit高度
        resWidth = self.MaxRowW;
    }else if(resWidth < originWidth){
        resWidth = originWidth;
    }
    return resWidth;
}

-(CGFloat)fitRowHeightToColsWidth:(NSMutableArray<NSNumber *> *)adjustFitWidths ByRowModel:(NSArray<WD_QTableModel *> *)models ForType:(NSInteger)type AtRowId:(NSInteger)rowId FromCol:(NSInteger)colId{
    NSMutableIndexSet *overMaxWCellIndexs =  [[NSMutableIndexSet alloc] init];
    NSInteger idx = 0;
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
    }
    //宽度溢出的，计算行高
    __block CGFloat fitHeight = self.defaultRowH;
    [overMaxWCellIndexs enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [self fitHeightOf:type ForWidth:self.MaxRowW * models[idx].collapseCol ByModel:models[idx] AtIndex:[NSIndexPath indexPathForRow:rowId inSection:idx + colId]];
        if (fitHeight * models[idx].collapseRow < height) {
            fitHeight = height;
        }
    }];
    return fitHeight; //返回最新行高
}
#pragma mark - 适配列宽
-(CGFloat)fitColWidthToRowHeights:(NSMutableArray<NSNumber *> *)adjustFitHeigths ByRowModel:(NSArray<WD_QTableModel *> *)models ForType:(NSInteger)type AtCol:(NSInteger)colId FromRow:(NSInteger)rowId{
    //const maxW =
    __block CGFloat optmizeWidth = self.MinxRowW;
    [models enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self fitWidthOf:type ForHeight:self.defaultRowH * obj.collapseRow  ByModel:obj AtIndex:[NSIndexPath indexPathForRow:idx + rowId inSection:colId]];
        width = width - self.MinxRowW * (obj.collapseCol - 1);
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
        CGFloat height = [self fitHeightOf:type ForWidth:optmizeWidth + (self.MinxRowW * (obj.collapseCol - 1)) ByModel:models[idx] AtIndex:[NSIndexPath indexPathForRow:idx + rowId inSection:colId]] / obj.collapseRow;
        if (height > self.defaultRowH) {
            for (NSInteger i = 0; i < obj.collapseRow; i++) {
                 adjustFitHeigths[idx + i] = [NSNumber numberWithFloat:height];
            }
        }
    }];
    return optmizeWidth;
    
}
#pragma mark - 计算宽度
-(CGFloat)fitWidthOf:(NSInteger)type ForHeight:(CGFloat)height ByModel:(WD_QTableModel *)model AtIndex:(NSIndexPath *)indexPath{
    __block CGFloat resValue = 0.f;
    dispatch_sync(dispatch_get_main_queue(), ^{
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
    });
    return resValue;
}
#pragma mark - 计算高度
-(CGFloat)fitHeightOf:(NSInteger)type ForWidth:(CGFloat)width ByModel:(WD_QTableModel *)model AtIndex:(NSIndexPath *)indexPath{
    __block CGFloat resValue = 0.f;
    dispatch_sync(dispatch_get_main_queue(), ^{
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
    });
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
