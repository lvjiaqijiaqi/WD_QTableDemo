//
//  WD_QTableAdaptor.h
//  IHQ
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 wind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WD_QTableDefaultStyleConstructor.h"
#import "WD_QTableAutoLayoutConstructor.h"
#import "WD_QTableChangeDelegate.h"

typedef NS_ENUM(NSUInteger, WD_QTableCellIdx) {
    WD_QTableCellIdxItem,
    WD_QTableCellIdxLeading,
    WD_QTableCellIdxHeading,
};
@class WD_QTableDefaultViewCell;

@interface WD_QTableAdaptor : NSObject<WD_QTableChangeDelegate>

@property (nonatomic, strong) id<WD_QTableStyleConstructorDelegate> styleConstructor;
@property (nonatomic, strong) WD_QTableAutoLayoutConstructor* layoutConstructor;

@property (nonatomic, assign) CGFloat MaxRowW;
@property (nonatomic, assign) CGFloat MinRowW;
@property (nonatomic, assign) CGFloat defaultRowH;


-(instancetype)initWithTableStyle:(id<WD_QTableStyleConstructorDelegate>)style ToLayout:(WD_QTableAutoLayoutConstructor *)layout;

@end
