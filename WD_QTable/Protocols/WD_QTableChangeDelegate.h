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

-(void)addHeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)Headings AtRange:(NSRange)range;
-(void)addLeadingChange:(NSArray<NSArray<WD_QTableModel *> *> *)leadings AtRange:(NSRange)range;
-(void)addDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models AtRowRange:(NSRange)range;
-(void)addDataChange:(NSArray<NSArray<WD_QTableModel *> *> *)models AtColRange:(NSRange)range;
-(void)commitChange;
-(void)addDataUpdate:(WD_QTableModel *)model AtRow:(NSInteger)rowId InCol:(NSInteger)colId;
@end

#endif /* WD_QTableChangeDelegate_h */
