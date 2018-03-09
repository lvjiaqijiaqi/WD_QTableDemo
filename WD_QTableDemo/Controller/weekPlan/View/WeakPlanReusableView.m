//
//  WeakPlanReusableView.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/8.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WeakPlanReusableView.h"

#define LabelEdge 5

@implementation WeakPlanReusableView

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
        self.leftLabel.frame = CGRectMake(LabelEdge, CGRectGetHeight(self.frame)/2, (CGRectGetWidth(self.frame) - 2*LabelEdge)/2, (CGRectGetHeight(self.frame) - 2*LabelEdge)/2);
        self.rightLabel.frame = CGRectMake(CGRectGetWidth(self.frame)/2, LabelEdge, (CGRectGetWidth(self.frame) - 2*LabelEdge)/2, (CGRectGetHeight(self.frame) - 2*LabelEdge)/2);
    }
    [super layoutSubviews];
}

- (void)initComponent
{
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.leftLabel.numberOfLines = 0;
    self.leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.leftLabel];

    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rightLabel];
    
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeZero;
}
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [self.rightLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height + 10;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    return [self.rightLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width + 10;
}


@end
