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
#import "WD_QViewModel.h"

@protocol WD_QTableAdaptorDelegate<NSObject>

-(void)commitChange:(WD_QViewModel *)models Reset:(BOOL)reset;

@end

@class WD_QTableDefaultViewCell;

@interface WD_QTableAdaptor : NSObject<WD_QTableAdaptorDelegate>

@property (nonatomic, strong) id<WD_QTableDefaultStyleConstructorDelegate> styleConstructor;
@property (nonatomic, strong) WD_QTableAutoLayoutConstructor* layoutConstructor;

@property (nonatomic, assign) CGFloat MaxRowW;
@property (nonatomic, assign) CGFloat MinxRowW;
@property (nonatomic, assign) CGFloat defaultRowH;

-(instancetype)initWithTableStyle:(id<WD_QTableDefaultStyleConstructorDelegate>)style ToLayout:(WD_QTableAutoLayoutConstructor *)layout;

@end
