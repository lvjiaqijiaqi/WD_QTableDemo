//
//  WD_QRefreshTable.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.

//  WD_QRefreshTable简介
//  继承WD_QTable，支持滑动加载刷新


#import "WD_QFitTable.h"

/*
 WD_QRefreshTableDirection 枚举
 刷新方向
 */
typedef NS_ENUM(NSUInteger, WD_QRefreshTableDirection) {
    WD_QRefreshTableDirectionNone,
    WD_QRefreshTableDirectionHorizontal,
    WD_QRefreshTableDirectionVertical
};

@interface WD_QRefreshTable : WD_QFitTable

@property(nonatomic,assign) NSInteger refreshDirection;

/*
 刷新触发时候调用的block
*/
@property(nonatomic,copy) void(^loadMoreHandle)(void);

/*
 刷新完成调用，
 调用该方法后才可以再次触发刷新
 */
-(void)reloadComplete;

/*
 加载更多数据
 调用该方法会自动调用reload方法并且调用reloadComplete
 */
-(void)loadMoreData;

@end
