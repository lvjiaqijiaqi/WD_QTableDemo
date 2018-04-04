//
//  WeakPlanTableViewCell.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/8.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WeakPlanTableViewCell.h"

#define LabelEdge 5

@implementation WeakPlanTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponent];
    }
    return self;
}

-(void)layoutSubviews{
    if (!CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        self.mainText.frame = CGRectMake(LabelEdge, LabelEdge, CGRectGetWidth(self.frame) - 2*LabelEdge, CGRectGetHeight(self.frame) - 2*LabelEdge);
    }
    [super layoutSubviews];
}

- (void)initComponent
{
    [super initComponent];
    self.mainText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.mainText.editable = NO;
    self.mainText.scrollEnabled = NO;
    [self addSubview:self.mainText];
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeZero;
}
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [self.mainText sizeThatFits:CGSizeMake(width, MAXFLOAT)].height + 10;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    return [self.mainText sizeThatFits:CGSizeMake(MAXFLOAT, height)].width + 10;
}


@end
