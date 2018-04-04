//
//  WD_QEditTable.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/3.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTable.h"

@interface WD_QEditTable : WD_QTable

-(void)insertEmptyRowAtRow:(NSInteger)rowId;
-(void)insertEmptyColAtCol:(NSInteger)colId;

@end
