//
//  WD_QTableCellDelegate.h
//  WD_QTableDemo
//
//  Created by lvjiaqi on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#ifndef WD_QTableCellDelegate_h
#define WD_QTableCellDelegate_h

#import <UIKit/UIKit.h>

@protocol WD_QTableBaseReusableViewDelegate

-(void)WD_QTableReusableViewName:(NSString *)SupplementaryName didSelectSupplementaryAtIndexPath:(NSIndexPath *)indexPath;
-(void)WD_QTableReusableViewName:(NSString *)SupplementaryName didLongPressSupplementaryAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol WD_QTableBaseCellViewDelegate

-(void)WD_QTableDidSelectAtIndexPath:(NSIndexPath *)indexPath;
-(void)WD_QTableDidLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end


#endif /* WD_QTableCellDelegate_h */
