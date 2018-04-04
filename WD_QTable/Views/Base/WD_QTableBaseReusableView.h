//
//  WD_QTableBaseReusableView.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WD_QTableBaseReusableView;

@protocol WD_QTableBaseReusableViewDelegate

-(void)WD_QTableReusableViewName:(NSString *)SupplementaryName didSelectSupplementaryAtIndexPath:(NSIndexPath *)indexPath;
-(void)WD_QTableReusableViewName:(NSString *)SupplementaryName didLongPressSupplementaryAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface WD_QTableBaseReusableView : UICollectionReusableView

@property (weak, nonatomic)  id<WD_QTableBaseReusableViewDelegate> delegate;

@property (strong, nonatomic)  NSIndexPath *indexPath;
@property(strong,nonatomic) NSString *supplementaryName;

@property(strong,nonatomic) UITapGestureRecognizer *tapPressGesture;
@property(strong,nonatomic) UILongPressGestureRecognizer *longPressGesture;

- (void)initComponent;
-(CGSize)sizeThatFits:(CGSize)size;
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width;
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height;

@end
