//
//  WD_QTableViewModel.h
//  IHQ
//
//  Created by jqlv on 2018/2/27.
//  Copyright © 2018年 wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WD_QTableModel.h"

typedef NS_ENUM(NSUInteger, WD_QTableModelType) {
    WD_QTableModelTypeItem,
    WD_QTableModelTypeLeading,
    WD_QTableModelTypeHeading,
    WD_QTableModelTypeMain
};

@interface WD_QTableViewModel : NSObject

@property (nonatomic, strong) WD_QTableModel *model;
@property (nonatomic, assign) WD_QTableModelType modelType;

@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;

@property (nonatomic,assign,readonly) NSInteger collapse;

@end
