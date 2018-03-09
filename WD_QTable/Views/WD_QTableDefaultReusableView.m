//
//  WD_QTableDefaultReusableView.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableDefaultReusableView.h"


#define LabelEdge 5

@interface WD_QTableDefaultReusableView()

@property(strong,nonatomic) UIView *topLine;
@property(strong,nonatomic) UIView *bottomLine;

@property(strong,nonatomic) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation WD_QTableDefaultReusableView

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
    self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.mainLabel.numberOfLines = 0;
    self.mainLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:self.mainLabel];
    
    self.topLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    self.topLine.backgroundColor = [UIColor blackColor];
    self.bottomLine.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    
    
}

-(void)showTopLine:(BOOL)topLine andBottomLine:(BOOL)bottomLine{
    self.topLine.hidden = !topLine;
    self.bottomLine.hidden = !bottomLine;
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeZero;
}

-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width{
    return [self.mainLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height + 10;
}
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height{
    //CGRect frame = [self.mainLabel.attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    //return frame.size.width + 10;
    return [self.mainLabel sizeThatFits:CGSizeMake(MAXFLOAT, height)].width + 10;
}



@end
