//
//  CustomStyleConstructor2.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "CustomStyleConstructor2.h"
#import "WD_QTableModel.h"

@implementation CustomStyleConstructor2

-(void)constructItemCollectionView:(UICollectionViewCell *)cell By:(WD_QTableModel *)model
{
    [super constructItemCollectionView:cell By:model];
    if (model.indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    }
}
-(void)constructLeadingSupplementary:(UICollectionReusableView *)cell By:(WD_QTableModel *)model{
    [super constructLeadingSupplementary:cell By:model];
    if (model.indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    }
}

@end
