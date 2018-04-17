//
//  WD_QTableBaseViewCell.m
//  IHQ
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QTableBaseViewCell.h"

@implementation WD_QTableBaseViewCell

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
        [self.delegate WD_QTableDidLongPressCell:self AtIndexPath:self.indexPath];
    }
}

- (void)tapPress:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate) {
        [self.delegate WD_QTableDidSelectCell:self AtIndexPath:self.indexPath];
    }
}

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
