//
//  JQ_CollectionViewLayout.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "JQ_CollectionViewLayoutDelegate.h"

@interface JQ_CollectionViewLayout : UICollectionViewLayout

@property(nonatomic,weak) id<JQ_CollectionViewLayoutDelegate> layoutDelegate;
-(void)resetLayout;
-(void)updateLayout;
-(void)invalidLayoutAtRowIndex:(NSInteger)rowIdx;
-(void)invalidLayoutAtColIndex:(NSInteger)colIdx;
-(void)invalidLayoutAtRow:(NSInteger)rowIdx InCol:(NSInteger)colIdx;
@end
