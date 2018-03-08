//
//  WD_QTableParse.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/7.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableParse.h"

@implementation WD_QTableParse

+(NSArray<WD_QTableModel *> *)parseHeadingFromJsonStr:(NSString *)jsonStr AtLevel:(NSInteger)level{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray<WD_QTableModel *> *resArr = [NSMutableArray array];
    [jsonArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WD_QTableModel *model = [self parseJsonStr:obj ForLevel:0 ByMaxLevel:level];
        [resArr addObject:model];
    }];
    return resArr;
}

+(WD_QTableModel *)parseJsonStr:(NSDictionary *)jsonDic ForLevel:(NSInteger)level ByMaxLevel:(NSInteger)maxLevel{
    WD_QTableModel *model =  [[WD_QTableModel alloc] init];
    model.title = jsonDic[@"title"];
    if (jsonDic[@"children"] && ![jsonDic[@"children"] isKindOfClass:[NSString class]]) {
        NSMutableArray *childrenArr = [NSMutableArray array];
        __block NSInteger countCol = 0;
        [jsonDic[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WD_QTableModel *m = [self parseJsonStr:obj ForLevel:level+1 ByMaxLevel:maxLevel];
            countCol += m.collapseCol;
            [childrenArr addObject:m];
        }];
        model.collapseCol = countCol;
        model.childrenModels = [childrenArr copy];
    }else{
        model.collapseRow = maxLevel - level;
    }
    return model;
}


+(void)parseLeadingFromJsonStr:(NSString *)jsonStr AtLevel:(NSInteger)level{
    
}

@end
