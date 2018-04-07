//
//  WD_QTableDefaultReusableView.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableBaseReusableView.h"

@interface WD_QTableDefaultReusableView : WD_QTableBaseReusableView

@property (strong, nonatomic)  UILabel *mainLabel;

-(void)showTopLine:(BOOL)topLine andBottomLine:(BOOL)bottomLine;

@end
