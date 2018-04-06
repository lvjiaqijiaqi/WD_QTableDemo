//
//  WD_QRefreshTable.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QRefreshTable.h"

#define loadMoreThresholdValue 10.f

@interface WD_QRefreshTable ()

@property(nonatomic,assign) BOOL refreshStatus;
@property(nonatomic,assign) CGFloat offsetXOld;
@property(nonatomic,assign) CGFloat offsetYOld;

@end

@implementation WD_QRefreshTable

-(instancetype)initWithLayoutConfig:(id<WD_QTableLayoutConstructorDelegate>)layoutConstructor StyleConstructor:(id<WD_QTableStyleConstructorDelegate>)styleConstructor{
    self = [super initWithLayoutConfig:layoutConstructor StyleConstructor:styleConstructor];
    if (self) {
        _refreshDirection = WD_QRefreshTableDirectionHorizontal;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.refreshStatus = NO;
    self.offsetXOld = self.collectionView.contentOffset.x;
    self.offsetYOld = self.collectionView.contentOffset.y;
    [self.collectionView addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:NULL];
}
-(void)loadMoreData{
    [self updateData];
    [self reloadComplete];
}
-(void)reloadComplete{
    self.refreshStatus = NO;
}

- (void)scrollViewDidScrollForGesture:(UIScrollView *)scrollView
{
    
    CGFloat offsetXNew = scrollView.contentOffset.x;
    CGFloat offsetYNew = scrollView.contentOffset.y;
    
    NSInteger scrollDirection = -1;
    if (offsetXNew > self.offsetXOld) {
        scrollDirection = 1;
    }else if (offsetXNew < self.offsetXOld){
        scrollDirection = 0;
    }else{
        if (offsetYNew > self.offsetYOld) {
            scrollDirection = 3;
        }else if (offsetYNew < self.offsetYOld){
            scrollDirection = 2;
        }
    }
    self.offsetXOld = offsetXNew;
    self.offsetYOld = offsetYNew;
    
    if (!self.refreshStatus) {
        if (self.refreshDirection == WD_QRefreshTableDirectionHorizontal) {//横向
            if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width - loadMoreThresholdValue))  {
                self.refreshStatus  =  YES;
                if(self.loadMoreHandle) self.loadMoreHandle();
            }
        }else if (self.refreshDirection == WD_QRefreshTableDirectionVertical){//纵向
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - loadMoreThresholdValue) && scrollDirection == 3)  {
                self.refreshStatus  =  YES;
                if(self.loadMoreHandle) self.loadMoreHandle();
            }
        }
        
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (self.collectionView.panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        [self scrollViewDidScrollForGesture:self.collectionView];
    }
}

-(void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
}

@end
