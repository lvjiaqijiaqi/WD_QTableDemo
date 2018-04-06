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
#import "WD_QTableStyleConstructorDelegate.h"
@class WD_QTableModel;

@interface WD_QTableDefaultStyleConstructor : NSObject<WD_QTableStyleConstructorDelegate>

-(NSArray *)calculateLeadingH:(NSArray<WD_QTableModel *> *)leadingModels ForWidth:(CGFloat)weight;
-(NSArray *)calculateHeadingW:(NSArray<WD_QTableModel *> *)headingModels ForHeight:(CGFloat)height;

@end
