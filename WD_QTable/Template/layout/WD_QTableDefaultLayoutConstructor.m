//
//  WD_QTableDefaultLayoutConstructor.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTableDefaultLayoutConstructor.h"
#import "WD_QTableModel.h"

#define WD_QTableDefaultItemW 100.f

@implementation WD_QTableDefaultLayoutConstructor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectZero;
        self.inset = UIEdgeInsetsZero;
        self.itemEdge = UIEdgeInsetsZero;
        self.headingH = 40.f;
        self.leadingW = WD_QTableDefaultItemW;
        self.itemH = 40.f;
        self.itemW = WD_QTableDefaultItemW;
    }
    return self;
}
-(CGRect)QTableFrame{
    return self.frame;
}
-(UIEdgeInsets)QTableInset{
    return self.inset;
}
-(UIEdgeInsets)QTableItemCellInset:(NSIndexPath *)index{
    return self.itemEdge;
}
-(CGFloat)rowHeightAtRowId:(NSInteger)rowId{
    return self.itemH;
}
-(CGFloat)colWidthAtcolId:(NSInteger)colId{
    return self.itemW;
}
-(CGFloat)leadingWAtLevel:(NSInteger)level{
    return self.leadingW;
}
-(CGFloat)headingHAtLevel:(NSInteger)level{
    return self.headingH;
}

-(BOOL)adjustLayoutForNewFrame:(CGRect)frame colCount:(NSInteger)colCount andRowCount:(NSInteger)rowCount{
    
    if (self.minW > 0 && colCount) {
        if (colCount * self.minW + self.leadingW > CGRectGetWidth(frame)) {
            [self setFrame:frame WithMinWidth:self.minW];
            return YES;
        }else{
            CGFloat itemWAll = CGRectGetWidth(frame) - self.leadingW;
            self.itemW = itemWAll / colCount;
            return YES;
        }
    }
    return NO;
}

-(void)setFrame:(CGRect)frame WithMinWidth:(CGFloat)width{
    self.minW = width;
    if (width > 0) {
        CGFloat itemWAll = CGRectGetWidth(frame) - self.leadingW;
        CGFloat itemW = itemWAll;
        NSInteger spliteRatio = 1;
        while ((itemWAll / spliteRatio) > width) {
            itemW = itemWAll / spliteRatio++;
        }
        self.itemW = itemWAll / (spliteRatio - 1);
    }
    self.frame = frame;
}

@end
