//
//  WD_QTableStyleConstructorDelegate.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#ifndef WD_QTableStyleConstructorDelegate_h
#define WD_QTableStyleConstructorDelegate_h

#import <UIKit/UIKit.h>
#import "WD_QTableModel.h"

@protocol WD_QTableStyleConstructorDelegate

@required
/*
 为WD_QTable提供复用的view的Class，该Class是UICollectionViewcell和UICollectionReuseCell的子类。
 */
-(NSArray<Class> *)itemCollectionViewCellClass;
-(NSArray<Class> *)leadingSupplementaryViewClass;
-(NSArray<Class> *)headingSupplementaryViewClass;
-(NSArray<Class> *)mainSupplementaryViewClass;
-(NSArray<Class> *)sectionSupplementaryViewClass;

/* indexPath section:列ID item:行ID */
-(NSString *)itemCollectionViewCellIdentifier:(NSIndexPath *)indexPath;
-(NSString *)leadingSupplementaryIdentifier:(NSIndexPath *)indexPath;
-(NSString *)headingSupplementaryCellIdentifier:(NSIndexPath *)indexPath;
-(NSString *)mainSupplementaryCellIdentifier:(NSIndexPath *)indexPath;
-(NSString *)sectionSupplementaryCellIdentifier:(NSIndexPath *)indexPath;

/*
 通过WD_QTableModel为cell填充数据并且配置样式。
 */
-(void)constructItemCollectionView:(UICollectionViewCell *)cell By:(WD_QTableModel *)model;
-(void)constructSectionSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model;
-(void)constructLeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model;
-(void)constructMainSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model;
-(void)constructHeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model;

/*
 表格的背景色
 */
-(UIColor *)WD_QTableBackgroundColor;

/*
 WD_QTableReuseCellPrefix
 */
-(NSString *)WD_QTableReuseCellPrefix;

@optional

@end

#endif /* WD_QTableStyleConstructorDelegate_h */
