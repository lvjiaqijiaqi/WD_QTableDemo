//
//  WD_QTableOtherViewCell.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/13.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableOtherViewCell.h"

#define LabelEdge 5

@interface WD_QTableOtherViewCell()

@property(strong,nonatomic) UIView *topLine;
@property(strong,nonatomic) UIView *bottomLine;

@property(strong,nonatomic) UIButton *arrowView;

@end

@implementation WD_QTableOtherViewCell

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
        self.mainText.frame = CGRectMake(LabelEdge, LabelEdge, CGRectGetWidth(self.frame) - 2*LabelEdge, CGRectGetHeight(self.frame) - 2*LabelEdge - 30);
        self.arrowView.frame = CGRectMake(CGRectGetWidth(self.frame) - 30 - LabelEdge, CGRectGetHeight(self.frame) - LabelEdge - 30, 30, 30);
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
    
    self.arrowView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.arrowView addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.arrowView];
    
}

-(void)clickBtn{
    if (self.delegate) {
        [self.delegate WD_QTableDidSelectAtIndexPath:self.indexPath];
    }
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeZero;
}
-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [self.mainText sizeThatFits:CGSizeMake(width, MAXFLOAT)].height + 50;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    return [self.mainText sizeThatFits:CGSizeMake(MAXFLOAT, height)].width + 10;
}

@end
