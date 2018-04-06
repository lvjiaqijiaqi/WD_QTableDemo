//
//  WD_QTableBaseViewCell.h
//  IHQ
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QTableCellDelegate.h"

@interface WD_QTableBaseViewCell : UICollectionViewCell

@property (weak, nonatomic)  id<WD_QTableBaseCellViewDelegate> delegate;

@property (strong, nonatomic)  NSIndexPath *indexPath;

@property(strong,nonatomic) UITapGestureRecognizer *tapPressGesture;
@property(strong,nonatomic) UILongPressGestureRecognizer *longPressGesture;

- (void)initComponent;
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width;
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height;

@end
