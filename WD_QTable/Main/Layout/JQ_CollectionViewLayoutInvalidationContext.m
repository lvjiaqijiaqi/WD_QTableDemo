//
//  JQ_CollectionViewLayoutInvalidationContext.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "JQ_CollectionViewLayoutInvalidationContext.h"

@implementation JQ_CollectionViewLayoutInvalidationContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionSupplementary = [NSMutableArray array];
        _leadingSupplementary = [NSMutableArray array];
        _mainSupplementary = [NSMutableArray array];
        _headingSupplementary = [NSMutableArray array];
        
        _sectionSupplementaryInvalid = [NSMutableArray array];
        _leadingSupplementaryInvalid = [NSMutableArray array];
        _mainSupplementaryInvalid = [NSMutableArray array];
        _headingSupplementaryInvalid = [NSMutableArray array];
        
        _lastLayoutBounds = CGRectZero;
        _currentSection = NSNotFound;
    }
    return self;
}

-(NSDictionary<NSString *,NSArray<NSIndexPath *> *> *)invalidatedSupplementaryIndexPaths{
    return @{
             @"sectionSupplementaryView":self.sectionSupplementaryInvalid,
             @"leadingSupplementaryView":self.leadingSupplementaryInvalid,
             @"mainSupplementaryView":self.mainSupplementaryInvalid,
             @"headingSupplementaryView":self.headingSupplementaryInvalid,
             };
}

@end
