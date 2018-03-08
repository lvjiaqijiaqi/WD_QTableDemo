//
//  WD_QTableParse.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/7.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WD_QTableModel.h"

@interface WD_QTableParse : NSObject

+(NSArray<WD_QTableModel *> *)parseHeadingFromJsonStr:(NSString *)jsonStr AtLevel:(NSInteger)level;
+(NSArray<WD_QTableModel *> *)parseLeadingFromJsonStr:(NSString *)jsonStr AtLevel:(NSInteger)level;

@end
