//
//  WD_QTableAutoLayoutConstructor.h
//  IHQ
//
//  Created by jqlv on 2018/2/26.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QTableDefaultLayoutConstructor.h"

@interface WD_QTableAutoLayoutConstructor : WD_QTableDefaultLayoutConstructor

@property (nonatomic, strong) NSMutableArray<NSNumber *> *RowsH;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *colsW;
@property (nonatomic, strong) NSArray<NSNumber *> *optmizeColsW;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *HeadingsW;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *HeadingsH;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *LeadingsH;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *LeadingsW;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *SectionsH;

@end
