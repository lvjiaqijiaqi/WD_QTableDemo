//
//  EditTableCell.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EditTableCell.h"

#define LabelEdge 5

@interface EditTableCell()

@property (strong, nonatomic)  UIView *leftLine;
@property (strong, nonatomic)  UIView *rightLine;
@property (strong, nonatomic)  UIView *topLine;
@property (strong, nonatomic)  UIView *bottomLine;

@end

@implementation EditTableCell

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
        self.mainLabel.frame = CGRectMake(LabelEdge, LabelEdge, CGRectGetWidth(self.frame) - 2 * LabelEdge, CGRectGetHeight(self.frame) - 2 * LabelEdge);
        self.leftLine.frame = CGRectMake(0, 0, 1, CGRectGetHeight(self.frame));
        self.rightLine.frame = CGRectMake(CGRectGetWidth(self.frame) - 1, 0, 1, CGRectGetHeight(self.frame));
        self.topLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1);
        self.bottomLine.frame = CGRectMake(0,  CGRectGetHeight(self.frame) - 1 , CGRectGetWidth(self.frame), 1);
    }
    [super layoutSubviews];
}

- (void)initComponent
{
    [super initComponent];
    self.leftLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.rightLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.leftLine.backgroundColor = [UIColor whiteColor];
    self.rightLine.backgroundColor = [UIColor whiteColor];
    self.topLine.backgroundColor = [UIColor whiteColor];
    self.bottomLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftLine];
    [self addSubview:self.rightLine];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mainLabel.numberOfLines = 0;
    [self addSubview:self.mainLabel];
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
