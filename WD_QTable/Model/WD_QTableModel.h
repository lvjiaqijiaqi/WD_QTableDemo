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

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *subTitle;

@property(nonatomic,assign) NSInteger sign;
@property(nonatomic,assign) NSInteger level;
@property(nonatomic,assign) NSInteger collapse;

@property(nonatomic,assign) NSInteger collapseRow;
@property(nonatomic,assign) NSInteger collapseCol;

@property(nonatomic,strong) NSMutableDictionary *extraDic;
@property(nonatomic,strong) WD_QTableModel *sectionModel;

@property(nonatomic,assign) WD_QTableCellType cellType;

@property(nonatomic,strong) NSIndexPath *indexPath;

@property(nonatomic,assign) BOOL isPlace;

@property(nonatomic,strong) NSArray<WD_QTableModel *> *childrenModels;

+(WD_QTableModel *)placeModel;

@end
