//
//  WD_QBaseTable.m
//
//  Created by jqlv on 2018/1/30.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QBaseTable.h"

@interface WD_QBaseTable ()

@property (nonatomic,assign) CGPoint scrollViewStartPosPoint;
@property (nonatomic,assign) NSInteger scrollDirection;

@end

@implementation WD_QBaseTable

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setHeadView:(UIView *)headView{
    _headView = headView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /* 消除45°滑动bug */
    if (self.scrollDirection == 0){
        if (fabs(self.scrollViewStartPosPoint.x-scrollView.contentOffset.x)<
            fabs(self.scrollViewStartPosPoint.y-scrollView.contentOffset.y)){
            self.scrollDirection = 1;
        } else {
            self.scrollDirection = 2;
        }
    }
    if (self.scrollDirection == 1) {
        scrollView.contentOffset = CGPointMake(self.scrollViewStartPosPoint.x,scrollView.contentOffset.y);
    } else if (self.scrollDirection == 2){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x,self.scrollViewStartPosPoint.y);
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.scrollViewStartPosPoint = scrollView.contentOffset;
    self.scrollDirection = 0;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        self.scrollDirection = 0;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.scrollDirection = 0;
}


@end

