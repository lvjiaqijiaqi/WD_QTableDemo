//
//  WD_QModel.h
//  IHQ
//
//  Created by jqlv on 2018/2/26.
//  Copyright © 2018年 wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WD_QTableModel.h"

@interface WD_QViewModel : NSObject

@property (nonatomic,strong) NSArray<NSArray<WD_QTableModel *> *> *datas;
@property (nonatomic,strong) NSArray<NSArray<WD_QTableModel *> *> *headings;
@property (nonatomic,strong) NSArray<NSArray<WD_QTableModel *> *> *leadings;
@property (nonatomic,strong) WD_QTableModel *mainModel;

@property (nonatomic,assign) CGRect frame;
@property (nonatomic,assign) BOOL needTranspostionForModel;

-(void)clear;

@end
