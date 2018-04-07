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
        WD_QTableModel *model = [self parseJsonStr:obj ForLevel:0 ByMaxLevel:level ForType:0];
        [resArr addObject:model];
    }];
    return resArr;
}

+(NSArray<WD_QTableModel *> *)parseLeadingFromJsonStr:(NSString *)jsonStr AtLevel:(NSInteger)level{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray<WD_QTableModel *> *resArr = [NSMutableArray array];
    [jsonArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WD_QTableModel *model = [self parseJsonStr:obj ForLevel:0 ByMaxLevel:level ForType:1];
        [resArr addObject:model];
    }];
    return resArr;
}

+(NSArray<NSArray<WD_QTableModel *> *> *)parseDataFromJsonStr:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *resArr = [NSMutableArray array];
    [jsonArr enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *colsArr = [NSMutableArray array];
        [obj enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WD_QTableModel *model =  [[WD_QTableModel alloc] init];
            model.title = obj;
            [colsArr addObject:model];
        }];
        [resArr addObject:colsArr];
    }];
    return resArr;
}

+(WD_QTableModel *)parseJsonStr:(NSDictionary *)jsonDic ForLevel:(NSInteger)level ByMaxLevel:(NSInteger)maxLevel ForType:(NSInteger)type{
    WD_QTableModel *model =  [[WD_QTableModel alloc] init];
    model.level = level;
    model.title = jsonDic[@"title"];
    if (jsonDic[@"children"] && ![jsonDic[@"children"] isKindOfClass:[NSString class]]) {
        NSMutableArray *childrenArr = [NSMutableArray array];
        __block NSInteger count = 0;
        [jsonDic[@"children"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WD_QTableModel *m = [self parseJsonStr:obj ForLevel:level+1 ByMaxLevel:maxLevel ForType:type];
            if (type) {
                count += m.collapseRow;
            }else{
                count += m.collapseCol;
            }
            [childrenArr addObject:m];
        }];
        if (type) {
            model.collapseRow = count;
        }else{
            model.collapseCol = count;
        }
        model.childrenModels = [childrenArr copy];
    }else{
        if (type) {
            model.collapseCol = maxLevel - level;
        }else{
            model.collapseRow = maxLevel - level;
        }
    }
    return model;
}



@end
