//
//  EditTableStyleConstructor.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EditTableStyleConstructor.h"
#import "EditTableCell.h"
#import "EditTableReusableView.h"
#import "WD_QTableModel.h"

@interface EditTableStyleConstructor()

@property(nonatomic,strong) NSString *itemCollectionViewCellIdentifier;
@property(nonatomic,strong) NSString *leadingSupplementaryIdentifier;
@property(nonatomic,strong) NSString *headingSupplementaryCellIdentifier;
@property(nonatomic,strong) NSString *mainSupplementaryCellIdentifier;
@property(nonatomic,strong) NSString *sectionSupplementaryCellIdentifier;

@end


@implementation EditTableStyleConstructor

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
        _itemCollectionViewCellIdentifier = @"EditTableCell";
    }
    return _itemCollectionViewCellIdentifier;
}
-(NSString *)leadingSupplementaryIdentifier:(NSIndexPath *)indexPath{
    if (!_leadingSupplementaryIdentifier) {
        _leadingSupplementaryIdentifier = @"EditTableReusableView";
    }
    return _leadingSupplementaryIdentifier;
}
-(NSString *)headingSupplementaryCellIdentifier:(NSIndexPath *)indexPath{
    if (!_headingSupplementaryCellIdentifier) {
        _headingSupplementaryCellIdentifier = @"EditTableReusableView";
    }
    return _headingSupplementaryCellIdentifier;
}
-(NSString *)mainSupplementaryCellIdentifier:(NSIndexPath *)indexPath{
    if (!_mainSupplementaryCellIdentifier) {
        _mainSupplementaryCellIdentifier = @"EditTableReusableView";
    }
    return _mainSupplementaryCellIdentifier;
}
-(NSString *)sectionSupplementaryCellIdentifier:(NSIndexPath *)indexPath{
    if (!_sectionSupplementaryCellIdentifier) {
        _sectionSupplementaryCellIdentifier = @"EditTableReusableView";
    }
    return _sectionSupplementaryCellIdentifier;
}

-(NSArray<Class> *)itemCollectionViewCellClass{
    return @[[EditTableCell class]];
}
-(NSArray<Class> *)leadingSupplementaryViewClass{
    return @[[EditTableReusableView class]];
}
-(NSArray<Class> *)headingSupplementaryViewClass{
    return @[[EditTableReusableView class]];
}
-(NSArray<Class> *)mainSupplementaryViewClass{
    return @[[EditTableReusableView class]];
}
-(NSArray<Class> *)sectionSupplementaryViewClass{
    return @[[EditTableReusableView class]];
}

-(void)constructItemCollectionView:(UICollectionViewCell *)cell By:(WD_QTableModel *)model
{
    EditTableCell* _cell = (EditTableCell *)cell;
    _cell.backgroundColor  =  [UIColor blackColor];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
}
-(void)constructSectionSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    
}
-(void)constructLeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    EditTableReusableView* _cell = (EditTableReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
}
-(void)constructMainSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    EditTableReusableView* _cell = (EditTableReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
}
-(void)constructHeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model
{
    EditTableReusableView* _cell = (EditTableReusableView *)cell;
    _cell.backgroundColor  = [UIColor blackColor];
    _cell.mainLabel.font = [UIFont systemFontOfSize:14];;
    _cell.mainLabel.textColor = [UIColor whiteColor];
    _cell.mainLabel.text = model.title;
}

@end
