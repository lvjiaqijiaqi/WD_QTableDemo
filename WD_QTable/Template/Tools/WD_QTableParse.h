//
//  WD_QTableParse.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/7.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WD_QTableModel.h"

@class WD_QTable;

@interface WD_QTableParse : NSObject

+(void)parseIn:(WD_QTable *)table ByJsonStr:(NSString *)jsonStr;
+(NSString *)parseOut:(WD_QTable *)table;

@end
