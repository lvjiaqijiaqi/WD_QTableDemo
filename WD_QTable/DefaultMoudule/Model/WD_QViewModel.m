//
//  WD_QModel.m
//  IHQ
//
//  Created by jqlv on 2018/2/26.
//  Copyright © 2018年 wind. All rights reserved.
//

#import "WD_QViewModel.h"

@interface WD_QViewModel()

@end

@implementation WD_QViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}
-(void)clear{
    self.datas = nil;
    self.headings = nil;
    self.leadings = nil;
    self.frame = CGRectZero;
    self.needTranspostionForModel = NO;
}
@end
