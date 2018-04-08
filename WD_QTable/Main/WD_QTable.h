//
//  WD_QFitTable.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QBaseTable.h"

@protocol WD_QTableStyleConstructorDelegate;
@protocol WD_QTableLayoutConstructorDelegate;
@protocol WD_QTableChangeDelegate;
@protocol JQ_CollectionViewLayoutDelegate;
@class WD_QTableModel;
@class JQ_CollectionViewLayout;

@interface WD_QTable : WD_QBaseTable<UICollectionViewDataSource,UICollectionViewDelegate>

/*
 数据转置:对数据二维数组的处理方式
 NO(默认) : 以列为基准
 YES(默认) : 以行为基准
 */
@property(nonatomic,assign) BOOL needTranspostionForModel;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign,readonly) NSInteger colsNum;
@property (nonatomic,assign,readonly) NSInteger rowsNum;
@property (nonatomic,assign,readonly) NSInteger LeadingRowNum;
@property (nonatomic,assign,readonly) NSInteger HeadingColNum;
@property (nonatomic,assign,readonly) NSInteger LeadingLevel;
@property (nonatomic,assign,readonly) NSInteger HeadingLevel;

@property(nonatomic,strong) id<WD_QTableChangeDelegate> autoLayoutHandle;

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
 @param  row 行索引
 @param  col 列索引
 @param  model 数据模型
 **/
@property(nonatomic,copy) void(^didSelectItemBlock)(NSInteger row, NSInteger col , WD_QTableModel * model);
@property(nonatomic,copy) void(^didLongPressItemBlock)(NSInteger row, NSInteger col , WD_QTableModel *model);

#pragma mark - 初始化方法
/**
 初始化整个WD_QTable，唯一的初始化方法
 通过layoutConstructor(带有WD_QTableLayoutConstructorDelegate布局管理的类)和styleConstructor(带有WD_QTableStyleConstructorDelegate样式管理的类)
 @param  layoutConstructor 布局layout管理
 @param  styleConstructor 样式style管理
 **/
-(instancetype)initWithLayoutConfig:(id<WD_QTableLayoutConstructorDelegate>)layoutConstructor StyleConstructor:(id<WD_QTableStyleConstructorDelegate>)styleConstructor;

/**
 更新布局和样式管理
 通过layoutConstructor(带有WD_QTableDefaultLayoutConstructorDelegate布局管理的类)和styleConstructor(带有WD_QTableDefaultStyleConstructorDelegate样式管理的类)
 @param  styleConstructor 布局layout管理
 @param  layoutConstructor 样式style管理
 **/
-(void)changeStyleConstructor:(id<WD_QTableStyleConstructorDelegate>)styleConstructor LayoutConstructor:(id<WD_QTableLayoutConstructorDelegate>)layoutConstructor;

/**
 更新表格header的高度
 **/
-(void)updateHeadH:(CGFloat)newH;


#pragma mark - 数据处理Models
/**
 重新刷新表格，会重新布局
 **/
-(void)reloadData;
/**
 重新刷新表格，不会重新布局
 **/
-(void)updateData;
/**
 重新刷新表格，会重新布局
 @param  isToTop 刷新后是否回到顶部
 **/
-(void)reloadDataToTop:(BOOL)isToTop;

/**
 设置左上角mainCell的model
 @param  mainModel 模型
 **/
-(void)setMain:(WD_QTableModel *)mainModel;

#pragma mark - item处理 重置，更新，插入

/**
 重置数据
 @param  newData 二维数组
 **/
-(void)resetItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData;

/**
 插入数据
 @param  newData 二维数组
 **/
-(void)insertItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData;

/**
插入行数据
 @param  newModels 一维数组
 @param  rowIdx 行索引
 **/
-(void)insertModels:(NSArray<WD_QTableModel *> *)newModels AtRow:(NSInteger)rowIdx;

/**
 插入列数据
 @param  newModels 一维数组
 @param  colIdx 列索引
 **/
-(void)insertModels:(NSArray<WD_QTableModel *> *)newModels AtCol:(NSInteger)colIdx;

#pragma mark - Heading处理 重置，更新，插入

/**
 重置Heading，newModels的count会作为新的列数
 @param  newModels 一维数组
 **/
-(void)resetHeadingModel:(NSArray<WD_QTableModel *> *)newModels;

/**
 添加Heading，newData的count会作为新增加的列数
 @param  newModels 一维数组
 **/
-(void)insertHeadingModel:(NSArray<WD_QTableModel *> *)newModels;
/**
 重置Heading，newData的count会作为新的列数
 @param  newArr NSString一维数组
 **/
-(void)resetHeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 添加Heading，newData的count会作为新增加的列数
 @param  newArr WD_QTableModel一维数组
 **/
-(void)insertHeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 重置Heading，该方法用做多表头情况.
 @param  newModels NSString二维数组
 **/
-(void)resetMultipleHeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

/**
 添加Heading，该方法用做多表头情况.
 @param  newModels NSString二维数组
 **/
-(void)insertMultipleHeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

/**
 插入Heading，
 @param  newModels NSString二维数组
 @param colId 列Id
 **/
-(void)insertHeadingModels:(NSArray<WD_QTableModel *> *)newModels atCol:(NSInteger)colId;

#pragma mark - leading处理 重置，更新，插入

/**
 重置Leading，newData的count会作为新的列数
 @param  newModels WD_QTableModel一维数组
 **/
-(void)resetLeadingModel:(NSArray<WD_QTableModel *> *)newModels;

/**
 添加Leading，newData的count会作为新增加的列数
 @param  newModels WD_QTableModel一维数组
 **/
-(void)insertLeadingModel:(NSArray<WD_QTableModel *> *)newModels;

/**
 重置Leading，newData的count会作为新的列数
 @param  newArr NSString一维数组
 **/
-(void)resetLeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 添加Leading，newData的count会作为新增加的列数
 @param  newArr WD_QTableModel一维数组
 **/
-(void)insertLeadingModelWithArr:(NSArray<NSString *> *)newArr;

/**
 重置Leading，该方法用做多表头情况.
 @param  newModels NSString二维数组
 **/
-(void)resetMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

/**
 添加Leading，该方法用做多表头情况.
 @param  newModels NSString二维数组
 **/
-(void)insertMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels;

/**
 插入Leading，
 @param  newModels NSString二维数组
 @param  rowId 行索引
 **/
-(void)insertLeadingModels:(NSArray<WD_QTableModel *> *)newModels atRow:(NSInteger)rowId;

#pragma - mark 更新内容

-(void)updateItem:(WD_QTableModel *)updateModel AtCol:(NSInteger)Col InRow:(NSInteger)Row;
-(void)updateLeading:(WD_QTableModel *)updateModel AtRow:(NSInteger)row InLevel:(NSInteger)level;
-(void)updateHeading:(WD_QTableModel *)updateModel AtCol:(NSInteger)col InLevel:(NSInteger)level;

#pragma - mark 插入缺省
-(void)insertEmptyRowAtRow:(NSInteger)rowId;
-(void)insertEmptyColAtCol:(NSInteger)colId;

-(void)deleteRowAtRow:(NSInteger)rowId;
-(void)deleteColAtCol:(NSInteger)colId;

#pragma mark - 辅助方法
-(WD_QTableModel *)modelForLeading:(NSInteger)idx level:(NSInteger)level;
-(WD_QTableModel *)modelForHeading:(NSInteger)idx level:(NSInteger)level;
-(WD_QTableModel *)modelForItem:(NSIndexPath *)indexPath;

@end
