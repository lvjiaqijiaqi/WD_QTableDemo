//
//  WD_QTableChangeDelegate.h
//  WD_QTableDemo
//
//  Created by lvjiaqi on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#ifndef WD_QTableChangeDelegate_h
#define WD_QTableChangeDelegate_h

@protocol WD_QTableChangeDelegate<NSObject>

-(void)addHeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)Headings AtIndex:(NSInteger)index;
-(void)addLeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)leadings AtIndex:(NSInteger)index;
-(void)addDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models AtRowIndex:(NSInteger)index;
-(void)addDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models AtColIndex:(NSInteger)index;
-(void)commitChange;

@end

#endif /* WD_QTableChangeDelegate_h */
