//
//  WD_QTableDefaultLayoutConstructor.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//
/*
  WD_QTableDefaultLayoutConstructorDelegate，继承JQ_CollectionViewLayoutDelegate
  意义:将布局的设置从WD_QTableDefault抽离出来,为表单配置布局属性。
 
  WD_QTableDefaultLayoutConstructor:WIND表格标准配置类,
  如果需要自定义可以继承该类，或者自己重新写只需要实现WD_QTableDefaultLayoutConstructorDelegate协议即可。
*/
#import "JQ_CollectionViewLayout.h"
#import "WD_QTableLayoutConstructorDelegate.h"

@class WD_QTable;

@interface WD_QTableDefaultLayoutConstructor : NSObject<WD_QTableLayoutConstructorDelegate>

@property(nonatomic,assign) CGRect frame;
@property(nonatomic,assign) UIEdgeInsets inset;
@property(nonatomic,assign) UIEdgeInsets itemEdge;

@property(nonatomic,assign) CGFloat leadingW;
@property(nonatomic,assign) CGFloat headingH;
@property(nonatomic,assign) CGFloat itemW;
@property(nonatomic,assign) CGFloat itemH;

@property(nonatomic,assign) CGFloat minW;

-(void)setFrame:(CGRect)frame WithMinWidth:(CGFloat)width;

@end
