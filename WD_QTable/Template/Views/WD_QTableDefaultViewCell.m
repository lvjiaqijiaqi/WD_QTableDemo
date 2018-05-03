//
//  WD_QTableBaseViewCell.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableDefaultViewCell.h"

#define LabelEdge 5

@interface WD_QTableDefaultViewCell()

@property(strong,nonatomic) UIView *topLine;
@property(strong,nonatomic) UIView *bottomLine;

@end

@implementation WD_QTableDefaultViewCell

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
        self.mainLabel.frame = CGRectMake(LabelEdge, LabelEdge, CGRectGetWidth(self.frame) - 2*LabelEdge, CGRectGetHeight(self.frame) - 2*LabelEdge);
        self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
        self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
    }
    [super layoutSubviews];
}
- (void)initComponent
{
    [super initComponent];
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mainLabel.numberOfLines = 0;
    [self addSubview:self.mainLabel];
    
    self.topLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.topLine.backgroundColor = [UIColor blackColor];
    self.topLine.hidden = YES;
    self.bottomLine.backgroundColor = [UIColor blackColor];
    self.bottomLine.hidden = NO;
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
 
}

-(void)showTopLine:(BOOL)topLine andBottomLine:(BOOL)bottomLine{
    self.topLine.hidden = topLine;
    self.bottomLine.hidden = bottomLine;
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeZero;
}
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [self.mainLabel sizeThatFits:CGSizeMake(width - 10, MAXFLOAT)].height + 10;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    return [self.mainLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width + 10;
}

@end
