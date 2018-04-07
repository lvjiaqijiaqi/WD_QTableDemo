//
//  WD_QTableDefaultLayoutConstructorDelegate.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#ifndef WD_QTableLayoutConstructorDelegate_h
#define WD_QTableLayoutConstructorDelegate_h

#import <UIKit/UIKit.h>

@protocol WD_QTableLayoutConstructorDelegate

@required

-(CGRect)QTableFrame;
-(UIEdgeInsets)QTableInset;

-(UIEdgeInsets)QTableItemCellInset:(NSIndexPath *)index;
-(CGFloat)rowHeightAtRowId:(NSInteger)rowId;
-(CGFloat)colWidthAtcolId:(NSInteger)colId;
-(CGFloat)leadingWAtLevel:(NSInteger)level;
-(CGFloat)headingHAtLevel:(NSInteger)level;

-(BOOL)adjustLayoutForNewFrame:(CGRect)frame colCount:(NSInteger)colCount andRowCount:(NSInteger)rowCount;

@end


#endif /* WD_QTableLayoutConstructorDelegate_h */
