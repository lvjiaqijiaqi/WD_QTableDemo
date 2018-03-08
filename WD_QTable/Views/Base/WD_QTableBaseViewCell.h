//
//  WD_QTableBaseViewCell.h
//  IHQ
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 wind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WD_QTableBaseViewCell : UICollectionViewCell

-(CGFloat)sizeThatFitHeighByWidth:(CGFloat)width;
-(CGFloat)sizeThatFitWidthByHeight:(CGFloat)height;

@end
