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

-(instancetype)initWithTableStyle:(id<WD_QTableDefaultStyleConstructorDelegate>)style ToLayout:(WD_QTableAutoLayoutConstructor *)layout;
{
    self = [self init];
    if (self) {
        self.styleConstructor = style;
        self.layoutConstructor = layout;
    }
    return self;
}

-(void)commitChange:(WD_QViewModel *)models Reset:(BOOL)reset{
    if (models.headings.count) {
        [self commitHeadingChange:models.headings Reset:reset];
    }
    if (models.leadings.count) {
        [self commitLeadingChange:models.leadings Reset:reset];
    }
    if (models.datas.count) {
        [self commitDataChange:models.datas Reset:reset needTrans:models.needTranspostionForModel];
        /*表头和数据布局合并*/
    }
    self.layoutConstructor.colsW = [self mergeMaxValueToArr:self.layoutConstructor.colsW FromArr:self.layoutConstructor.HeadingsW];
    self.layoutConstructor.RowsH = [self mergeMaxValueToArr:self.layoutConstructor.RowsH FromArr:self.layoutConstructor.LeadingsH];
    
    /* 贴边处理 */
    __block CGFloat leadingsW = 0.f;
    [self.layoutConstructor.LeadingsW enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        leadingsW += obj.floatValue;
    }];
    self.layoutConstructor.optmizeColsW = [self optimizeWidth:self.layoutConstructor.colsW ByContainerWidth:CGRectGetWidth(models.frame) - leadingsW];
    
}
-(void)commitHeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)Headings Reset:(BOOL)reset{
    if (Headings.count == 0) return;
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (!reset) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.HeadingsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.HeadingsH];
    }
    if (!fitWidths.count) {
        for (NSInteger i = [Headings lastObject].count; i > 0; i--) [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    if (!fitHeights.count) {
        for (NSInteger i = Headings.count; i > 0; i--) [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    [Headings enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [self fitRowHeightToColsWidth:fitWidths ByRowModel:obj ForType:2];
        fitHeights[idx] = [NSNumber numberWithFloat:height];
    }];
    self.layoutConstructor.HeadingsW = fitWidths;
    self.layoutConstructor.HeadingsH = fitHeights;
}
-(void)commitLeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)leadings Reset:(BOOL)reset{
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (!reset) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.LeadingsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.LeadingsH];
    }
    if (!fitHeights.count) {
        for (NSInteger i = [leadings lastObject].count; i > 0; i--) [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    if (!fitWidths.count) {
        for (NSInteger i = leadings.count; i > 0; i--) [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    [leadings enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self fitColWidthToRowHeights:fitHeights ByRowModel:obj ForType:1];
        fitWidths[idx] = [NSNumber numberWithFloat:width];
    }];
    self.layoutConstructor.LeadingsH = fitHeights;
    self.layoutConstructor.LeadingsW = fitWidths;
}

-(void)commitDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models Reset:(BOOL)reset needTrans:(BOOL)needTrans{
    if (models.count == 0) {
        return;
    }
    const NSInteger colsNum = needTrans ? models[0].count : models.count;
    const NSInteger rowsNum = needTrans ? models.count : models[0].count;
    /* 预设 */
    NSMutableArray<NSNumber *> *fitWidths = [NSMutableArray array];
    NSMutableArray<NSNumber *> *fitHeights = [NSMutableArray array];
    if (!reset) {
        fitWidths = [NSMutableArray arrayWithArray:self.layoutConstructor.colsW];
        fitHeights = [NSMutableArray arrayWithArray:self.layoutConstructor.RowsH];
    }
    if (!fitWidths.count) {
        for (NSInteger i = colsNum; i > 0; i--) [fitWidths addObject:[NSNumber numberWithFloat:self.MinxRowW]]; //预设
    }
    if (!fitHeights.count) {
        for (NSInteger i = rowsNum; i > 0; i--) [fitHeights addObject:[NSNumber numberWithFloat:self.defaultRowH]]; //预设
    }
    if(needTrans){
        [models enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull rows, NSUInteger rowIdx, BOOL * _Nonnull stop) {
            CGFloat fitHeight = [self fitRowHeightToColsWidth:fitWidths ByRowModel:rows ForType:0];
            if ([fitHeights[rowIdx] floatValue] < fitHeight) {
                fitHeights[rowIdx] = [NSNumber numberWithFloat:fitHeight];
            }
        }];
    }else{
        [models enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull cols, NSUInteger colIdx, BOOL * _Nonnull stop) {
            CGFloat fitWidth = [self fitColWidthToRowHeights:fitHeights ByRowModel:cols ForType:0];
            if ([fitWidths[colIdx] floatValue] < fitWidth) {
                fitWidths[colIdx] = [NSNumber numberWithFloat:fitWidth];
            }
        }];
    }
    self.layoutConstructor.RowsH = fitHeights;
    self.layoutConstructor.colsW = fitWidths;
}

-(void)calculateAutoFitForTable:(NSArray<NSArray<WD_QTableModel *> *> *)models ToFitWidths:(NSMutableArray<NSNumber *> *)fitWidths andToFitHeights:(NSMutableArray<NSNumber *> *)fitHeights{
    [models enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull rows, NSUInteger rowIdx, BOOL * _Nonnull stop) {
        CGFloat fitHeight = [self fitRowHeightToColsWidth:fitWidths ByRowModel:rows ForType:0];
        if ([fitHeights[rowIdx] floatValue] < fitHeight) {
            fitHeights[rowIdx] = [NSNumber numberWithFloat:fitHeight];
        }
    }];
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

-(CGFloat)fitRowHeightToColsWidth:(NSMutableArray<NSNumber *> *)adjustFitWidths ByRowModel:(NSArray<WD_QTableModel *> *)models ForType:(NSInteger)type{
    NSMutableIndexSet *overMaxWCellIndexs =  [[NSMutableIndexSet alloc] init];
    NSInteger idx = 0;
    while (idx < models.count) {
        WD_QTableModel * _Nonnull obj = models[idx];
        if (!obj.isPlace) {
            //计算宽度
            CGFloat width = [self fitWidthOf:type ForHeight:self.defaultRowH ByModel:obj] / obj.collapseCol;
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
        CGFloat height = [self fitHeightOf:type ForWidth:self.MaxRowW * models[idx].collapseCol ByModel:models[idx]];
        if (fitHeight * models[idx].collapseRow < height) {
            fitHeight = height;
        }
    }];
    return fitHeight; //返回最新行高
}
#pragma mark - 适配列宽
-(CGFloat)fitColWidthToRowHeights:(NSMutableArray<NSNumber *> *)adjustFitHeigths ByRowModel:(NSArray<WD_QTableModel *> *)models ForType:(NSInteger)type{
    //const maxW =
    __block CGFloat optmizeWidth = self.MinxRowW;
    [models enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = [self fitWidthOf:type ForHeight:self.defaultRowH * obj.collapseRow  ByModel:obj];
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
        CGFloat height = [self fitHeightOf:type ForWidth:optmizeWidth + (self.MinxRowW * (obj.collapseCol - 1)) ByModel:models[idx]] / obj.collapseRow;
        if (height > self.defaultRowH) {
            for (NSInteger i = 0; i < obj.collapseRow; i++) {
                 adjustFitHeigths[idx + i] = [NSNumber numberWithFloat:height];
            }
        }
    }];
    return optmizeWidth;
    
}
#pragma mark - 计算宽度
-(CGFloat)fitWidthOf:(NSInteger)type ForHeight:(CGFloat)height ByModel:(WD_QTableModel *)model{
    __block CGFloat resValue = 0.f;
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (type == 0) {
            Class qTableCellClass = [self.styleConstructor itemCollectionViewCellClass];
            WD_QTableBaseViewCell *reuseCell = [[qTableCellClass alloc] init];
            [self.styleConstructor constructItemCollectionView:reuseCell By:model];
            resValue = [reuseCell sizeThatFitWidthByHeight:height];
        }if (type == 1){
            Class qTableCellClass = [self.styleConstructor leadingSupplementaryViewClass];
            WD_QTableBaseReusableView *reuseCell = [[qTableCellClass alloc] init];
            [self.styleConstructor constructLeadingSupplementary:reuseCell By:model];
            resValue = [reuseCell sizeThatFitWidthByHeight:height];
        }else if (type == 2){
            Class qTableCellClass = [self.styleConstructor headingSupplementaryViewClass];
            WD_QTableBaseReusableView *reuseCell = [[qTableCellClass alloc] init];
            [self.styleConstructor constructHeadingSupplementary:reuseCell By:model];
            resValue = [reuseCell sizeThatFitWidthByHeight:height];
        }
    });
    return resValue;
}
#pragma mark - 计算高度
-(CGFloat)fitHeightOf:(NSInteger)type ForWidth:(CGFloat)width ByModel:(WD_QTableModel *)model{
    __block CGFloat resValue = 0.f;
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (type == 0) {
            Class qTableCellClass = [self.styleConstructor itemCollectionViewCellClass];
            WD_QTableBaseViewCell *reuseCell = [[qTableCellClass alloc] init];
            [self.styleConstructor constructItemCollectionView:reuseCell By:model];
            resValue = [reuseCell sizeThatFitHeighByWidth:width];
        }if (type == 1){
            Class qTableCellClass = [self.styleConstructor leadingSupplementaryViewClass];
            WD_QTableBaseViewCell *reuseCell = [[qTableCellClass alloc] init];
            [self.styleConstructor constructLeadingSupplementary:reuseCell By:model];
            resValue = [reuseCell sizeThatFitHeighByWidth:width];
        }else if (type == 2){
            Class qTableCellClass = [self.styleConstructor headingSupplementaryViewClass];
            WD_QTableBaseViewCell *reuseCell = [[qTableCellClass alloc] init];
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
