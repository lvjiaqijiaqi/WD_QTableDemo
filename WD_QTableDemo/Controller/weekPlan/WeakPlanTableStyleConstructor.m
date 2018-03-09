//
//  WeakPlanTableStyleConstructor.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/8.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WeakPlanTableStyleConstructor.h"
#import "WeakPlanTableViewCell.h"
#import "WD_QTableDefaultReusableView.h"
#import "WeakPlanReusableView.h"
#import "WD_QTableModel.h"

@interface WeakPlanTableStyleConstructor()

@property(nonatomic,strong) NSString *itemCollectionViewCellIdentifier;
@property(nonatomic,strong) NSString *leadingSupplementaryIdentifier;
@property(nonatomic,strong) NSString *headingSupplementaryCellIdentifier;
@property(nonatomic,strong) NSString *mainSupplementaryCellIdentifier;
@property(nonatomic,strong) NSString *sectionSupplementaryCellIdentifier;

@end

@implementation WeakPlanTableStyleConstructor

-(UIColor *)WD_QTableBackgroundColor
{
    return [UIColor colorWithRed:235.0/256 green:235.0/256 blue:255.0/256 alpha:1];
}
-(NSString *)WD_QTableReuseCellPrefix
{
    return NSStringFromClass([self class]);
}

-(NSString *)itemCollectionViewCellIdentifier{
    if (!_itemCollectionViewCellIdentifier) {
        _itemCollectionViewCellIdentifier = [NSString stringWithFormat:@"cell%@%@",[self WD_QTableReuseCellPrefix],NSStringFromClass([self itemCollectionViewCellClass])];
    }
    return _itemCollectionViewCellIdentifier;
}
-(NSString *)leadingSupplementaryIdentifier{
    if (!_leadingSupplementaryIdentifier) {
        _leadingSupplementaryIdentifier = [NSString stringWithFormat:@"supplmentCell%@%@",[self WD_QTableReuseCellPrefix],NSStringFromClass([self leadingSupplementaryViewClass])];
    }
    return _leadingSupplementaryIdentifier;
}
-(NSString *)headingSupplementaryCellIdentifier{
    if (!_headingSupplementaryCellIdentifier) {
        _headingSupplementaryCellIdentifier = [NSString stringWithFormat:@"supplmentCell%@%@",[self WD_QTableReuseCellPrefix],NSStringFromClass([self headingSupplementaryViewClass])];
    }
    return _headingSupplementaryCellIdentifier;
}
-(NSString *)mainSupplementaryCellIdentifier{
    if (!_mainSupplementaryCellIdentifier) {
        _mainSupplementaryCellIdentifier = [NSString stringWithFormat:@"supplmentCell%@%@",[self WD_QTableReuseCellPrefix],NSStringFromClass([self mainSupplementaryViewClass])];
    }
    return _mainSupplementaryCellIdentifier;
}
-(NSString *)sectionSupplementaryCellIdentifier{
    if (!_sectionSupplementaryCellIdentifier) {
        _sectionSupplementaryCellIdentifier = [NSString stringWithFormat:@"supplmentCell%@%@",[self WD_QTableReuseCellPrefix],NSStringFromClass([self sectionSupplementaryViewClass])];
    }
    return _sectionSupplementaryCellIdentifier;
}

-(Class)itemCollectionViewCellClass{return [WeakPlanTableViewCell class];}
-(Class)leadingSupplementaryViewClass{return [WD_QTableDefaultReusableView class];}
-(Class)headingSupplementaryViewClass{return [WD_QTableDefaultReusableView class];}
-(Class)mainSupplementaryViewClass{return [WeakPlanReusableView class];}
-(Class)sectionSupplementaryViewClass{return [WD_QTableDefaultReusableView class];}

-(void)constructItemCollectionView:(UICollectionViewCell *)cell By:(WD_QTableModel *)model
{
    WeakPlanTableViewCell* _cell = (WeakPlanTableViewCell *)cell;
    _cell.backgroundColor  =  [UIColor colorWithRed:235.0/256 green:235.0/256 blue:255.0/256 alpha:1];
    _cell.mainText.font = [UIFont systemFontOfSize:14];
    _cell.mainText.backgroundColor = [UIColor colorWithRed:235.0/256 green:235.0/256 blue:255.0/256 alpha:1];
    _cell.mainText.textColor = [UIColor blackColor];
    _cell.mainText.text = model.title;
}
-(void)constructSectionSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor whiteColor];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor blackColor];
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:NO andBottomLine:NO];
    
}
-(void)constructLeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:250.0/256 alpha:1];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor blackColor];
    _cell.mainLabel.textAlignment = NSTextAlignmentCenter;
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:NO andBottomLine:NO];
}
-(void)constructMainSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WeakPlanReusableView* _cell = (WeakPlanReusableView *)cell;
    _cell.backgroundColor  = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:250.0/256 alpha:1];
    
    _cell.leftLabel.font = [UIFont systemFontOfSize:14];
    _cell.leftLabel.textColor = [UIColor blackColor];
    _cell.leftLabel.text = @"时间";
    
    _cell.rightLabel.font = [UIFont systemFontOfSize:14];;
    _cell.rightLabel.textColor = [UIColor blackColor];
    _cell.rightLabel.text = @"日期";
    
}
-(void)constructHeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    WD_QTableDefaultReusableView* _cell = (WD_QTableDefaultReusableView *)cell;
    _cell.backgroundColor  = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:250.0/256 alpha:1];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor blackColor];
    _cell.mainLabel.text = model.title;
    [_cell showTopLine:NO andBottomLine:NO];
}

@end
