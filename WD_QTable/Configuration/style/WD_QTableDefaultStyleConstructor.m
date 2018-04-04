//
//  WD_QTableDefaultStyleConstructor.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableDefaultStyleConstructor.h"
#import "WD_QTableDefaultViewCell.h"
#import "WD_QTableDefaultReusableView.h"
#import "WD_QTableModel.h"

@interface WD_QTableDefaultStyleConstructor()

@property(nonatomic,strong) NSString *itemCollectionViewCellIdentifier;
@property(nonatomic,strong) NSString *leadingSupplementaryIdentifier;
@property(nonatomic,strong) NSString *headingSupplementaryCellIdentifier;
@property(nonatomic,strong) NSString *mainSupplementaryCellIdentifier;
@property(nonatomic,strong) NSString *sectionSupplementaryCellIdentifier;

@end

@implementation WD_QTableDefaultStyleConstructor

-(UIColor *)WD_QTableBackgroundColor
{
    return [UIColor blackColor];
}
-(NSString *)WD_QTableReuseCellPrefix
{
    return NSStringFromClass([self class]);
}
-(NSString *)itemCollectionViewCellIdentifier:(NSIndexPath *)indexPath{
    if (!_itemCollectionViewCellIdentifier) {
        _itemCollectionViewCellIdentifier = @"WD_QTableDefaultViewCell";
    }
    return _itemCollectionViewCellIdentifier;
}
-(NSString *)leadingSupplementaryIdentifier:(NSIndexPath *)indexPath{
    if (!_leadingSupplementaryIdentifier) {
        _leadingSupplementaryIdentifier = @"WD_QTableDefaultReusableView";
    }
    return _leadingSupplementaryIdentifier;
}
-(NSString *)headingSupplementaryCellIdentifier:(NSIndexPath *)indexPath{
    if (!_headingSupplementaryCellIdentifier) {
        _headingSupplementaryCellIdentifier = @"WD_QTableDefaultReusableView";
    }
    return _headingSupplementaryCellIdentifier;
}
-(NSString *)mainSupplementaryCellIdentifier:(NSIndexPath *)indexPath{
    if (!_mainSupplementaryCellIdentifier) {
        _mainSupplementaryCellIdentifier = @"WD_QTableDefaultReusableView";
    }
    return _mainSupplementaryCellIdentifier;
}
-(NSString *)sectionSupplementaryCellIdentifier:(NSIndexPath *)indexPath{
    if (!_sectionSupplementaryCellIdentifier) {
        _sectionSupplementaryCellIdentifier = @"WD_QTableDefaultReusableView";
    }
    return _sectionSupplementaryCellIdentifier;
}

-(NSArray<Class> *)itemCollectionViewCellClass{
    return @[[WD_QTableDefaultViewCell class]];
}
-(NSArray<Class> *)leadingSupplementaryViewClass{
    return @[[WD_QTableDefaultReusableView class]];
}
-(NSArray<Class> *)headingSupplementaryViewClass{
    return @[[WD_QTableDefaultReusableView class]];
}
-(NSArray<Class> *)mainSupplementaryViewClass{
    return @[[WD_QTableDefaultReusableView class]];
}
-(NSArray<Class> *)sectionSupplementaryViewClass{
    return @[[WD_QTableDefaultReusableView class]];
}

-(void)constructItemCollectionView:(UICollectionViewCell *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultViewCell* _cell = (WD_QTableDefaultViewCell *)cell;
    _cell.backgroundColor  =  [UIColor blackColor];
    _cell.mainLabel.textAlignment = [self getAligmentBy:model.cellType];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    if ([model.extraDic[@"needAdapt"] boolValue]) {
        _cell.mainLabel.adjustsFontSizeToFitWidth = YES;
        _cell.mainLabel.minimumScaleFactor = 0.5;
    }else{
        _cell.mainLabel.adjustsFontSizeToFitWidth = NO;
    }
    _cell.mainLabel.text = model.title;
}
-(void)constructSectionSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.textAlignment = [self getAligmentBy:model.cellType];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:NO andBottomLine:YES];
    
}
-(void)constructLeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.textAlignment = [self getAligmentBy:model.cellType];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:NO andBottomLine:YES];
}
-(void)constructMainSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.textAlignment = [self getAligmentBy:model.cellType];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:YES andBottomLine:YES];
}
-(void)constructHeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.textAlignment = [self getAligmentBy:model.cellType];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:YES andBottomLine:YES];
}

-(NSTextAlignment)getAligmentBy:(WD_QTableCellType)type
{
    switch (type) {
        case WD_QTableCellTypeCellString:
            return NSTextAlignmentLeft;
            break;
        case WD_QTableCellTypeCellDate:
            return NSTextAlignmentCenter;
            break;
        case WD_QTableCellTypeCellNumber:
            return NSTextAlignmentRight;
            break;
        default:
            return NSTextAlignmentCenter;
            break;
    }
}

#pragma mark - auto计算
-(NSArray *)calculateHeadingW:(NSArray<WD_QTableModel *> *)headingModels ForHeight:(CGFloat)height{
    WD_QTableDefaultReusableView *cell = [[WD_QTableDefaultReusableView alloc] init];
    NSMutableArray *widths = [[NSMutableArray alloc] init];
    [headingModels enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self constructHeadingSupplementary:cell By:obj];
        CGFloat width = [cell sizeThatFitWidthByHeight:height];
        [widths addObject:[NSNumber numberWithFloat:width]];
    }];
    return widths;
}
-(NSArray *)calculateLeadingH:(NSArray<WD_QTableModel *> *)leadingModels ForWidth:(CGFloat)weight{
    WD_QTableDefaultReusableView *cell = [[WD_QTableDefaultReusableView alloc] init];
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    [leadingModels enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self constructLeadingSupplementary:cell By:obj];
        CGFloat height = [cell sizeThatFitHeighByWidth:weight];
        [heights addObject:[NSNumber numberWithFloat:height]];
    }];
    return heights;
}

@end
