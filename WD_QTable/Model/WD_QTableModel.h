//
//  WD_QTableModel.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WD_QTableCellType) {
    WD_QTableCellTypeCellUnknown,
    WD_QTableCellTypeCellString,
    WD_QTableCellTypeCellNumber,
    WD_QTableCellTypeCellDate
};

@interface WD_QTableModel : NSObject

/* title */
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *subTitle;

@property(nonatomic,assign) NSInteger sign;
@property(nonatomic,assign) NSInteger level;

/* 跨度 */
@property(nonatomic,assign) NSInteger collapseRow;
@property(nonatomic,assign) NSInteger collapseCol;

/* 存储额外信息 */
@property(nonatomic,strong) NSMutableDictionary *extraDic;

/* section头Model */
@property(nonatomic,strong) WD_QTableModel *sectionModel;

@property(nonatomic,assign) WD_QTableCellType cellType;

/* 索引 */
@property(nonatomic,strong) NSIndexPath *indexPath;

/* 是否是占位Model */
@property(nonatomic,assign) BOOL isPlace;

/* 子集model数组 */
@property(nonatomic,strong) NSArray<WD_QTableModel *> *childrenModels;

+(WD_QTableModel *)placeModel;

@end
