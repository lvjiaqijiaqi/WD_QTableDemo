//
//  JQ_CollectionViewLayoutInvalidationContext.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQ_CollectionViewLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *sectionSupplementaryInvalid;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *leadingSupplementaryInvalid;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *headingSupplementaryInvalid;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *mainSupplementaryInvalid;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *leadingSupplementary;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *sectionSupplementary;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *headingSupplementary;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *mainSupplementary;

@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) CGRect lastLayoutBounds;

@end
