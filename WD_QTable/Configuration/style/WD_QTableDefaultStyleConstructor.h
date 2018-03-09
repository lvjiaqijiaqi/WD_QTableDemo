//
//  WD_QTableDefaultStyleConstructor.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

/*
 WD_QTableDefaultStyleConstructorDelegate
 意义:将cell的设置从WD_QTableDefault抽离出来,为表单配置cell的样式。
 
 WD_QTableDefaultLayoutConstructor:WIND表格标准配置类。
 如果需要自定义可以继承该类，或者自己重新写只需要实现WD_QTableDefaultStyleConstructorDelegate协议即可。
 */

#import <UIKit/UIKit.h>

@class WD_QTableModel;

@protocol WD_QTableDefaultStyleConstructorDelegate

@required
/*
   为WD_QTable提供复用的view的Class，该Class是UICollectionViewcell和UICollectionReuseCell的子类。
*/
-(Class)itemCollectionViewCellClass;
-(Class)leadingSupplementaryViewClass;
-(Class)headingSupplementaryViewClass;
-(Class)mainSupplementaryViewClass;
-(Class)sectionSupplementaryViewClass;

-(NSString *)itemCollectionViewCellIdentifier;
-(NSString *)leadingSupplementaryIdentifier;
-(NSString *)headingSupplementaryCellIdentifier;
-(NSString *)mainSupplementaryCellIdentifier;
-(NSString *)sectionSupplementaryCellIdentifier;
    
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

@interface WD_QTableDefaultStyleConstructor : NSObject<WD_QTableDefaultStyleConstructorDelegate>

-(NSArray *)calculateLeadingH:(NSArray<WD_QTableModel *> *)leadingModels ForWidth:(CGFloat)weight;
-(NSArray *)calculateHeadingW:(NSArray<WD_QTableModel *> *)headingModels ForHeight:(CGFloat)height;

@end
