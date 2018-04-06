//
//  WD_QTableModelProtocol.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/6.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#ifndef WD_QTableModelProtocol_h
#define WD_QTableModelProtocol_h

#import <Foundation/Foundation.h>

@protocol WD_QTableModelProtocol

-(NSInteger)collapseRow;
-(NSInteger)collapseCol;
-(NSMutableDictionary *)extraDic;
-(NSIndexPath *)indexPath;
-(BOOL)isPlace;
-(NSArray<id<WD_QTableModelProtocol>> *)childrenModels;
-(void)setTitle:(NSString *)title;

+(id<WD_QTableModelProtocol>)placeModel;
+(id<WD_QTableModelProtocol>)emptyModel;

@end

#endif /* WD_QTableModelProtocol_h */
