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
    
    UILongPressGestureRecognizer *longPressGesture =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPressGesture];
    self.longPressGesture = longPressGesture;
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate WD_QTableReusableViewName:self.supplementaryName didLongPressSupplementaryAtIndexPath:self.indexPath];
    }
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
