//
//  WD_QFitTable.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QBaseTable.h"

#import "JQ_CollectionViewLayout.h"
#import "WD_QTableAdaptor.h"

@protocol WD_QTableDefaultLayoutConstructorDelegate;
@protocol WD_QTableDefaultStyleConstructorDelegate;
@class WD_QTableModel;

@interface WD_QFitTable : WD_QBaseTable<UICollectionViewDataSource,UICollectionViewDelegate>

/*
 数据转置:对数据二维数组的处理方式
 NO(默认) : 以列为基准
 YES(默认) : 以行为基准
 */
@property(nonatomic,assign) BOOL needTranspostionForModel;
@property (nonatomic,strong) UICollectionView *collectionView;

@property(nonatomic,strong) id<WD_QTableAdaptorDelegate> autoLayoutHandle;

-(JQ_CollectionViewLayout *)layout;

#pragma mark - 事件block

/**
 响应Leading点击事件
 @param  indexPath 索引
 **/
@property(nonatomic,copy) void(^didSelectLeadingBlock)(NSIndexPath *indexPath);
@property(nonatomic,copy) void(^didLongPressLeadingBlock)(NSIndexPath *indexPath);
/**
 响应Heading点击事件
 @param  indexPath 索引
 **/
@property(nonatomic,copy) void(^didSelectHeadingBlock)(NSIndexPath *indexPath);
@property(nonatomic,copy) void(^didLongPressHeadingBlock)(NSIndexPath *indexPath);
/**
 响应Section点击事件
 @param  indexPath 索引
 **/
@property(nonatomic,copy) void(^didSelectSectionBlock)(NSIndexPath *indexPath);
@property(nonatomic,copy) void(^didLongPressSectionBlock)(NSIndexPath *indexPath);
/**
 响应cell点击事件
 @param  row
 @param  col
 @param  WD_QTableModel
 **/
@property(nonatomic,copy) void(^didSelectItemBlock)(NSInteger row, NSInteger col , WD_QTableModel *model);
@property(nonatomic,copy) void(^didLongPressItemBlock)(NSInteger row, NSInteger col , WD_QTableModel *model);

#pragma mark - 初始化方法
/**
 初始化整个WD_QTable，唯一的初始化方法
 通过layoutConstructor(带有WD_QTableDefaultLayoutConstructorDelegate布局管理的类)和styleConstructor(带有WD_QTableDefaultStyleConstructorDelegate样式管理的类)
 @param  layoutConstructor<WD_QTableDefaultLayoutConstructorDelegate> 布局layout管理
 @param  styleConstructor<WD_QTableDefaultStyleConstructorDelegate> 样式style管理
 **/
-(instancetype)initWithLayoutConfig:(id<WD_QTableDefaultLayoutConstructorDelegate>)layoutConstructor StyleConstructor:(id<WD_QTableDefaultStyleConstructorDelegate>)styleConstructor;

/**
 更新布局和样式管理
 通过layoutConstructor(带有WD_QTableDefaultLayoutConstructorDelegate布局管理的类)和styleConstructor(带有WD_QTableDefaultStyleConstructorDelegate样式管理的类)
 @param  layoutConstructor<WD_QTableDefaultLayoutConstructorDelegate> 布局layout管理
 @param  styleConstructor<WD_QTableDefaultStyleConstructorDelegate> 样式style管理
 **/
-(void)changeStyleConstructor:(id<WD_QTableDefaultStyleConstructorDelegate>)constructor LayoutConstructor:(id<WD_QTableDefaultLayoutConstructorDelegate>)layoutConstructor;

/**
 更新表格header的高度
 **/
-(void)updateHeadH:(CGFloat)newH;


#pragma mark - 数据处理Models
/**
 重新刷新表格，会重新布局
 **/
-(void)reloadData;
-(void)updateData;
/**
 重新刷新表格，会重新布局
 @param  isToTop 刷新后是否回到顶部
 **/
-(void)reloadDataToTop:(BOOL)isToTop;

/**
 设置左上角mainCell的model
 @param  WD_QTableModel 模型
 **/
-(void)setMain:(WD_QTableModel *)mainModel;

#pragma mark - item处理 重置，更新，插入

/**
 重置数据
 @param  newData WD_QTableModel二维数组
 **/
-(void)resetItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData;

/**
 更新数据
 @param  newData WD_QTableModel二维数组
 **/
-(void)updateItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData;

/**
 更新某列数据，不会重新布局
 @param  newData WD_QTableModel一维数组
 @param  col 列索引
 **/
-(void)updateItemModel:(NSArray<WD_QTableModel *>*)newModels atCol:(NSInteger)col;

#pragma mark - Heading处理 重置，更新，插入

/**
 重置Heading，newData的count会作为新的列数
 @param  newData WD_QTableModel一维数组
 **/
-(void)resetHeadingModel:(NSArray<WD_QTableModel *> *)newModels;

/**
 添加Heading，newData的count会作为新增加的列数
 @param  newData WD_QTableModel一维数组
 **/
-(void)updateHeadingModel:(NSArray<WD_QTableModel *> *)newModels;
/**
 重置Heading，newData的count会作为新的列数
 @param  newData NSString一维数组
 **/
-(void)resetHeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 添加Heading，newData的count会作为新增加的列数
 @param  newData WD_QTableModel一维数组
 **/
-(void)updateHeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 重置Heading，该方法用做多表头情况.
 @param  newData NSString二维数组
 @param  col 列数
 **/
-(void)resetMultipleHeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

/**
 添加Heading，该方法用做多表头情况.
 @param  newData NSString二维数组
 @param  col 列数
 **/
-(void)updateMultipleHeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

#pragma mark - leading处理 重置，更新，插入

/**
 重置Leading，newData的count会作为新的列数
 @param  newData WD_QTableModel一维数组
 **/
-(void)resetLeadingModel:(NSArray<WD_QTableModel *> *)newModels;

/**
 添加Leading，newData的count会作为新增加的列数
 @param  newData WD_QTableModel一维数组
 **/
-(void)updateLeadingModel:(NSArray<WD_QTableModel *> *)newModels;

/**
 重置Leading，newData的count会作为新的列数
 @param  newData NSString一维数组
 **/
-(void)resetLeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 添加Leading，newData的count会作为新增加的列数
 @param  newData WD_QTableModel一维数组
 **/
-(void)updateLeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 重置Leading，该方法用做多表头情况.
 @param  newData NSString二维数组
 @param  col 列数
 **/
-(void)resetMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

/**
 添加Leading，该方法用做多表头情况.
 @param  newData NSString二维数组
 @param  col 列数
 **/
-(void)updateMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

#pragma - mark 更新内容

-(void)updateItem:(WD_QTableModel *)updateModel AtCol:(NSInteger)Col InRow:(NSInteger)Row;
-(void)updateLeading:(WD_QTableModel *)updateModel AtRow:(NSInteger)row InLevel:(NSInteger)level;
-(void)updateHeading:(WD_QTableModel *)updateModel AtCol:(NSInteger)col InLevel:(NSInteger)level;

-(void)insertEmptyRowAtRow:(NSInteger)rowId;
-(void)insertEmptyColAtCol:(NSInteger)colId;

#pragma mark - 辅助方法
-(WD_QTableModel *)modelForLeading:(NSInteger)idx level:(NSInteger)level;
-(WD_QTableModel *)modelForHeading:(NSInteger)idx level:(NSInteger)level;
-(WD_QTableModel *)modelForItem:(NSIndexPath *)indexPath;

@end
