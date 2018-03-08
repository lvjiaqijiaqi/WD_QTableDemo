//
//  WD_QTableBaseViewCell.m
//  IHQ
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QTableBaseViewCell.h"

@implementation WD_QTableBaseViewCell

-(CGSize)sizeThatFits:(CGSize)size{
    return [super sizeThatFits:size];
}
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [super sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    return [super sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
}
@end
