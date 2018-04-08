//
//  WD_QTableParse.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/7.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableParse.h"
#import "WD_QTable.h"

@implementation WD_QTableParse


+(NSString *)parseOut:(WD_QTable *)table{
    NSMutableArray *leadingArr = [NSMutableArray array];
    for (NSInteger i = 0; i < table.LeadingLevel; i++) {
        for (NSInteger j = 0; j < table.LeadingRowNum ; j++) {
            [leadingArr addObject:[table modelForLeading:j level:i].title];
        }
    }
    NSMutableArray *headingArr = [NSMutableArray array];
    for (NSInteger i = 0; i < table.HeadingLevel; i++) {
        for (NSInteger j = 0; j < table.HeadingColNum ; j++) {
            [headingArr addObject:[table modelForHeading:j level:i].title];
        }
    }
    NSMutableArray<NSMutableArray *> *datas = [NSMutableArray array];
    for (NSInteger i = 0; i < table.rowsNum ; i++) {
        NSMutableArray<NSString *> *rows = [NSMutableArray array];
        for (NSInteger j = 0; j < table.colsNum ; j++) {
            [rows addObject:[table modelForItem:[NSIndexPath indexPathForItem:i inSection:j]].title];
        }
        [datas addObject:rows];
    }
    
    NSDictionary *dic = @{@"Leadings":leadingArr,
                          @"Headings":headingArr,
                          @"datas":datas
                          };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        return @"";
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //NSLog(@"%@",jsonString);
    return jsonString;
}

+(void)parseIn:(WD_QTable *)table ByJsonStr:(NSString *)jsonStr{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    [table resetHeadingModelWithArr:jsonDic[@"Headings"]];
    [table resetLeadingModelWithArr:jsonDic[@"Leadings"]];
    [table resetItemModel:[self parseItems:jsonDic[@"Items"]]];
    
}

+(NSArray<NSArray<WD_QTableModel *> *> *)parseItems:(NSArray<NSArray *> *)jsonArr{
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


/*
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
*/


@end
