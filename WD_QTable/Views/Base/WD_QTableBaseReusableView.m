//
//  WD_QTableBaseReusableView.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableBaseReusableView.h"

@implementation WD_QTableBaseReusableView

- (void)initComponent
{
    UITapGestureRecognizer *tapPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self addGestureRecognizer:tapPressGesture];
    self.tapPressGesture = tapPressGesture;
}

- (void)tapPress:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate WD_QTableReusableViewName:self.supplementaryName didSelectSupplementaryAtIndexPath:self.indexPath];
    }
}

-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [super sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    return [super sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
}
-(CGSize)sizeThatFits:(CGSize)size{
    return [super sizeThatFits:size];
}
@end
