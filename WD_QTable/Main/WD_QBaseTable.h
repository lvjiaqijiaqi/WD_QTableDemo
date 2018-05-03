//
//  WD_QBaseTable.h
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WD_QBaseTable : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *bottomView;

-(void)setHeadView:(UIView *)headView;
-(void)setBottomView:(UIView *)bottomView;

@end

