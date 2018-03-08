//
//  WD_QTable.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QTable.h"

#import "WD_QTableBaseReusableView.h"

#import "WD_QTableDefaultStyleConstructor.h"
#import "WD_QTableDefaultLayoutConstructor.h"

#import "WD_QTableModel.h"

#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self.lock)

@interface WD_QTable ()<WD_QTableBaseReusableViewDelegate,JQ_CollectionViewLayoutDelegate>

@property (nonatomic,strong) id<WD_QTableDefaultStyleConstructorDelegate> styleConstructor;
@property (nonatomic,strong) id<WD_QTableDefaultLayoutConstructorDelegate> layoutConstructor;

@property (nonatomic,strong) JQ_CollectionViewLayout *collectionLayout;

@property (nonatomic,strong) WD_QTableModel *mainModel;
@property (nonatomic,strong) NSMutableArray<NSMutableArray<WD_QTableModel *> *> *datas;
@property (nonatomic,strong) NSMutableArray<NSMutableArray<WD_QTableModel *> *> *headings;
@property (nonatomic,strong) NSMutableArray<NSMutableArray<WD_QTableModel *> *> *leadings;

@property (nonatomic,strong) WD_QViewModel *variationModel;
@property (nonatomic,strong) dispatch_semaphore_t lock;

@end

@implementation WD_QTable

#pragma mark - 辅助GET方法
-(JQ_CollectionViewLayout *)layout{
    return self.collectionLayout;
}
#pragma mark - LayoutConstructor相关
-(void)updateLayoutConstructor:(id<WD_QTableDefaultLayoutConstructorDelegate>)layoutConstructor{
    self.view.frame = [layoutConstructor QTableFrame];
    self.collectionView.contentInset = [layoutConstructor QTableInset];
}

#pragma mark - StyleConstructor相关

-(void)updateStyleConstructor:(id<WD_QTableDefaultStyleConstructorDelegate>)styleConstructor{
    [self registerCell];
}
-(void)registerCell{
    self.collectionView.backgroundColor = [self.styleConstructor WD_QTableBackgroundColor];
    [self.collectionView registerClass:[self.styleConstructor itemCollectionViewCellClass] forCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%@",[self.styleConstructor WD_QTableReuseCellPrefix]]];
    [self.collectionView registerClass:[self.styleConstructor mainSupplementaryViewClass] forSupplementaryViewOfKind:@"mainSupplementaryView" withReuseIdentifier:[NSString stringWithFormat:@"supplmentCell%@",[self.styleConstructor WD_QTableReuseCellPrefix]]];
    [self.collectionView registerClass:[self.styleConstructor headingSupplementaryViewClass] forSupplementaryViewOfKind:@"headingSupplementaryView" withReuseIdentifier:[NSString stringWithFormat:@"supplmentCell%@",[self.styleConstructor WD_QTableReuseCellPrefix]]];
    [self.collectionView registerClass:[self.styleConstructor leadingSupplementaryViewClass] forSupplementaryViewOfKind:@"leadingSupplementaryView" withReuseIdentifier:[NSString stringWithFormat:@"supplmentCell%@",[self.styleConstructor WD_QTableReuseCellPrefix]]];
    [self.collectionView registerClass:[self.styleConstructor sectionSupplementaryViewClass] forSupplementaryViewOfKind:@"sectionSupplementaryView" withReuseIdentifier:[NSString stringWithFormat:@"supplmentCell%@",[self.styleConstructor WD_QTableReuseCellPrefix]]];
}
#pragma mark - 初始化方法
- (instancetype)initWithLayoutConfig:(id<WD_QTableDefaultLayoutConstructorDelegate> )layoutConstructor StyleConstructor:(id<WD_QTableDefaultStyleConstructorDelegate> )styleConstructor
{
    self = [super init];
    if (self) {
        _needTranspostionForModel = NO;
        /* 初始化数据数组 */
        self.datas = [NSMutableArray array];
        self.headings = [NSMutableArray array];
        self.leadings = [NSMutableArray array];
        self.variationModel = [[WD_QViewModel alloc] init];
        [self initCollectionView];
        self.styleConstructor  = styleConstructor;
        self.layoutConstructor = layoutConstructor;
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}
#pragma mark - 配置函数
-(void)initCollectionView{
    self.collectionLayout = [[JQ_CollectionViewLayout alloc] init];
    self.collectionLayout.layoutDelegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
    self.collectionView.directionalLockEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate  = self;
    self.collectionView.bounces = NO;
}

-(void)changeStyleConstructor:(id<WD_QTableDefaultStyleConstructorDelegate>)constructor LayoutConstructor:(id<WD_QTableDefaultLayoutConstructorDelegate>)layoutConstructor{
    if (constructor){
        self.styleConstructor = constructor;
        [self updateStyleConstructor:self.styleConstructor];
    }
    if (layoutConstructor) {
        self.layoutConstructor = layoutConstructor;
        [self updateLayoutConstructor:self.layoutConstructor];
    }
    [self reloadData];
}
#pragma mark - collectionHead处理
-(void)setHeadView:(UIView *)headView{
    [super setHeadView:headView];
    [self.collectionView addSubview:self.headView];
    CGRect rect = headView.frame;
    rect.origin.y = -[self.layoutConstructor QTableInset].top;
    self.headView.frame = rect;
}

-(void)updateHeadH:(CGFloat)newH{
    
    CGRect rect = self.headView.frame;
    rect.origin.y = -newH;
    rect.size.height = newH;
    self.headView.frame = rect;
    
    UIEdgeInsets HeaderInset = self.collectionView.contentInset;
    HeaderInset.top = newH;
    self.collectionView.contentInset = HeaderInset;
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    contentOffset.y = -self.collectionView.contentInset.top;
    [self.collectionView setContentOffset:contentOffset animated:NO];
    
    [self reloadData];
}
-(void)updateSupplementaryPosition{
    [self moveView:self.headView ToBasePoint:self.collectionView.contentInset];
    [self moveView:self.bottomView ToBasePoint:self.collectionView.contentInset];
}
-(void)moveView:(UIView *)view ToBasePoint:(UIEdgeInsets)insets{
    if (!view) return;
    CGRect frame = view.frame;
    frame.origin.y = -insets.top;
    frame.origin.x = -insets.left;
    view.frame = frame;
}
#pragma mark - 刷新控制
-(void)updateData{
    if (self.autoLayoutHandle) {
        self.variationModel.frame = self.collectionView.frame;
        [self.autoLayoutHandle commitChange:self.variationModel Reset:NO];
        [self.variationModel clear];
    }
    [self.collectionLayout invalidateLayout];
    [self.collectionView reloadData];
}
-(void)reloadData{ //会清空原有布局
    if (self.autoLayoutHandle) {
        Lock(); //锁住 避免多次调用卡主
        self.variationModel.frame = self.collectionView.frame;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.variationModel.needTranspostionForModel = self.needTranspostionForModel;
            [self.autoLayoutHandle commitChange:self.variationModel Reset:YES];
            [self.variationModel clear];
            Unlock();
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionLayout resetLayout];
                [self.collectionLayout invalidateLayout];
                [self.collectionView reloadData];
            });
        });
    }else{
        [self.collectionLayout resetLayout];
        [self.collectionLayout invalidateLayout];
        [self.collectionView reloadData];
    }
}
-(void)reloadDataToTop:(BOOL)isToTop{
    [self reloadData];
    if (isToTop) {
        CGPoint offect = self.collectionView.contentOffset;
        offect.x = - self.collectionView.contentInset.left;
        offect.y = - self.collectionView.contentInset.top;
        [self.collectionView setContentOffset:offect animated:NO];
    }
}

#pragma mark - Item 处理 重置，更新，插入
-(void)setMain:(WD_QTableModel *)mainModel{
    self.mainModel = mainModel;
}
-(void)resetItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData{
    [self.datas removeAllObjects];
    [self updateItemModel:newData];
}
-(void)updateItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData{
    [newData enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.datas addObject:[NSMutableArray arrayWithArray:obj]];
    }];
    self.variationModel.datas = newData;
}
-(void)updateItemModel:(NSArray<WD_QTableModel *>*)newModels atCol:(NSInteger)col{
    if (self.datas.count > col) {
        self.datas[col] = [NSMutableArray arrayWithArray:newModels];
    }
}

#pragma mark - Heading 处理 重置，更新，插入
-(void)resetHeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    [self.headings removeAllObjects];
    [self updateHeadingModel:newModels];
}
-(void)updateHeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    if (self.headings.count == 0) {
        [self.headings addObject:[NSMutableArray array]];
    }
    [self.headings[0] addObjectsFromArray:newModels];
    self.variationModel.headings = [NSArray arrayWithObject:newModels];
}
-(void)resetHeadingModelWithArr:(NSArray<NSString *> *)newArr{
    [self.headings removeAllObjects];
    NSMutableArray<WD_QTableModel *> *headingModels = [NSMutableArray arrayWithCapacity:newArr.count];
    [newArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WD_QTableModel *headingModel = [[WD_QTableModel alloc] init];
        headingModel.title = obj;
        [headingModels addObject:headingModel];
    }];
    [self resetHeadingModel:headingModels];
}
-(void)updateHeadingModelWithArr:(NSArray<NSString *> *)newArr{
    NSMutableArray<WD_QTableModel *> *headingModels = [NSMutableArray arrayWithCapacity:newArr.count];
    [newArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WD_QTableModel *headingModel = [[WD_QTableModel alloc] init];
        headingModel.title = obj;
        [headingModels addObject:headingModel];
    }];
    [self updateHeadingModel:headingModels];
}
-(void)resetMultipleHeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels{
    [self.headings removeAllObjects];
    for (NSInteger i = self.headings.count ; i < newModels.count ; i++) {
        [self.headings addObject:[NSMutableArray array]];
    }
    [self updateMultipleHeadingModel:newModels];
}
-(void)updateMultipleHeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels{
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *ModifyModels = [NSMutableArray array];
    for (NSInteger i = newModels.count; i > 0 ; i--) {
        [ModifyModels addObject:[NSMutableArray array]];
    }
    for (NSInteger levelIdx = newModels.count - 1; levelIdx >= 0; levelIdx--) {
        if (levelIdx < ModifyModels.count) {
            NSArray<WD_QTableModel *> * _Nonnull obj = newModels[levelIdx];
            [obj enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger startIdx = ModifyModels[levelIdx].count;
                [ModifyModels[levelIdx] addObject:obj];
                for (NSInteger collapseCol = 1; collapseCol < obj.collapseCol; collapseCol++) {
                    [ModifyModels[levelIdx] addObject:[WD_QTableModel placeModel]];
                };
                for (NSInteger collapseRow = obj.collapseRow; collapseRow > 1; collapseRow--) {
                    NSInteger subLevel = levelIdx + collapseRow - 1;
                    if (subLevel < ModifyModels.count) {
                        for (NSInteger collapseCol = 0; collapseCol < obj.collapseCol; collapseCol++) {
                            [ModifyModels[subLevel] insertObject:[WD_QTableModel placeModel] atIndex:startIdx];
                        };
                    }
                }
            }];
        }
    }
    [ModifyModels enumerateObjectsUsingBlock:^(NSMutableArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.headings[idx] addObjectsFromArray:obj];
    }];
    self.variationModel.headings = ModifyModels;
}
#pragma mark - leading处理 重置，更新，插入

-(void)resetLeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    [self.leadings removeAllObjects];
    [self updateLeadingModel:newModels];
}
-(void)updateLeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    if (self.leadings.count == 0) {
        [self.leadings addObject:[NSMutableArray array]];
    }
    [self.leadings[0] addObjectsFromArray:newModels];
    self.variationModel.leadings = [NSArray arrayWithObject:newModels];
}
-(void)resetLeadingModels:(NSArray<WD_QTableModel *> *)newModels DependLevel:(NSInteger)level{
    [self.leadings removeAllObjects];
    [self updateLeadingModels:newModels DependLevel:level];
}
-(void)updateLeadingModels:(NSArray<WD_QTableModel *> *)newModels DependLevel:(NSInteger)level{
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *ModifyModels = [NSMutableArray array];
    for (NSInteger i = level; i > 0 ; i--) {
        [ModifyModels addObject:[NSMutableArray array]];
    }
    NSMutableArray<WD_QTableModel *> *modelStack =  [NSMutableArray array];
    [modelStack addObjectsFromArray:[[newModels reverseObjectEnumerator] allObjects]];
    [newModels lastObject].extraDic[@"tag"] = [NSNumber numberWithBool:YES];
    NSInteger le = 0;
    for (WD_QTableModel *newModel = [modelStack lastObject]; newModel != nil; newModel = [modelStack lastObject]) {
        [ModifyModels[le] addObject:newModel];
        for (NSInteger i = newModel.collapseCol - 1; i >= 0; i--) {
            for (NSInteger j = newModel.collapseRow - 1; j >= 0; j--) {
                if (i || j) {
                   [ModifyModels[le + i] addObject:[WD_QTableModel placeModel]];
                }
            }
        }
        if (newModel.childrenModels) {
            [newModel.childrenModels lastObject].extraDic[@"tag"] = @YES;
            [modelStack addObjectsFromArray:[[newModel.childrenModels reverseObjectEnumerator] allObjects]];
            le++;
        }else{
            [modelStack removeLastObject];
            if ([newModel.extraDic[@"tag"] boolValue]) {
                le--;
            }
        }
    }
    [ModifyModels enumerateObjectsUsingBlock:^(NSMutableArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(self.leadings.count <= idx) [self.leadings addObject:[NSMutableArray array]];
        [self.leadings[idx] addObjectsFromArray:obj];
    }];
    self.variationModel.leadings = [NSArray arrayWithObject:newModels];
}

-(void)resetLeadingModelWithArr:(NSArray<NSString *> *)newArr{
    [self.leadings removeAllObjects];
    NSMutableArray<WD_QTableModel *> *leadingModels = [NSMutableArray arrayWithCapacity:newArr.count];
    [newArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WD_QTableModel *leadingModel = [[WD_QTableModel alloc] init];
        leadingModel.title = obj;
        [leadingModels addObject:leadingModel];
    }];
    [self resetLeadingModel:leadingModels];
}
-(void)updateLeadingModelWithArr:(NSArray<NSString *> *)newArr{
    NSMutableArray<WD_QTableModel *> *leadingModels = [NSMutableArray arrayWithCapacity:newArr.count];
    [newArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WD_QTableModel *leadingModel = [[WD_QTableModel alloc] init];
        leadingModel.title = obj;
        [leadingModels addObject:leadingModel];
    }];
    [self updateLeadingModel:leadingModels];
}
-(void)resetHeadingModels:(NSArray<WD_QTableModel *> *)newModels DependLevel:(NSInteger)level{
    [self.headings removeAllObjects];
    [self updateHeadingModels:newModels DependLevel:level];
}
-(void)updateHeadingModels:(NSArray<WD_QTableModel *> *)newModels DependLevel:(NSInteger)level{
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *ModifyModels = [NSMutableArray array];
    for (NSInteger i = level; i > 0 ; i--) {
        [ModifyModels addObject:[NSMutableArray array]];
    }
    NSMutableArray<WD_QTableModel *> *modelStack =  [NSMutableArray array];
    [modelStack addObjectsFromArray:[[newModels reverseObjectEnumerator] allObjects]];
    [newModels lastObject].extraDic[@"tag"] = [NSNumber numberWithInteger:0];
    NSInteger le = 0;
    for (WD_QTableModel *newModel = [modelStack lastObject]; newModel != nil; newModel = [modelStack lastObject]) {
        [modelStack removeLastObject];
        [ModifyModels[le] addObject:newModel];
        for (NSInteger i = newModel.collapseRow - 1; i >= 0; i--) {
            for (NSInteger j = newModel.collapseCol - 1; j >= 0; j--) {
                if (i || j) {
                    [ModifyModels[le + i] addObject:[WD_QTableModel placeModel]];
                }
            }
        }
        if (newModel.childrenModels) {
            le++;
            [newModel.childrenModels lastObject].extraDic[@"tag"] = [NSNumber numberWithInteger:le];
            [modelStack addObjectsFromArray:[[newModel.childrenModels reverseObjectEnumerator] allObjects]];
        }
    }
    [ModifyModels enumerateObjectsUsingBlock:^(NSMutableArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(self.headings.count <= idx) [self.headings addObject:[NSMutableArray array]];
        [self.headings[idx] addObjectsFromArray:obj];
    }];
    self.variationModel.headings = ModifyModels;
}

-(void)resetMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels{
    //清空
    [self.leadings removeAllObjects];
    //添加
    for (NSInteger i = self.leadings.count ; i < newModels.count ; i++) {
        [self.leadings addObject:[NSMutableArray array]];
    }
    [self updateMultipleLeadingModel:newModels];
}
-(void)updateMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels{
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *ModifyModels = [NSMutableArray array];
    for (NSInteger i = newModels.count; i > 0 ; i--) {
        [ModifyModels addObject:[NSMutableArray array]];
    }
    for (NSInteger levelIdx = newModels.count - 1; levelIdx >= 0; levelIdx--) {
        if (levelIdx < ModifyModels.count) {
            NSArray<WD_QTableModel *> * _Nonnull obj = newModels[levelIdx];
            [obj enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger startIdx = ModifyModels[levelIdx].count;
                [ModifyModels[levelIdx] addObject:obj];
                for (NSInteger collapseRow = 1; collapseRow < obj.collapseRow; collapseRow++) {
                    [ModifyModels[levelIdx] addObject:[WD_QTableModel placeModel]];
                };
                for (NSInteger collapseCol = obj.collapseCol; collapseCol > 1; collapseCol--) {
                    NSInteger subLevel = levelIdx + collapseCol - 1;
                    if (subLevel < ModifyModels.count) {
                        for (NSInteger collapseRow = 0; collapseRow < obj.collapseRow; collapseRow++) {
                            [ModifyModels[subLevel] insertObject:[WD_QTableModel placeModel] atIndex:startIdx];
                        };
                    }
                }
            }];
        }
    }
    [ModifyModels enumerateObjectsUsingBlock:^(NSMutableArray<WD_QTableModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.leadings[idx] addObjectsFromArray:obj];
    }];
    self.variationModel.leadings = ModifyModels;
}

#pragma mark - Model辅助方法

-(WD_QTableModel *)modelForHeading:(NSInteger)idx level:(NSInteger)level{
    if (self.headings.count > level) {
        if (self.headings[level].count > idx) {
            WD_QTableModel *model = self.headings[level][idx];
            model.indexPath = [NSIndexPath indexPathForRow:idx inSection:level];
            return model;
        }
    }
    return [WD_QTableModel placeModel];
}
-(WD_QTableModel *)modelForLeading:(NSInteger)idx level:(NSInteger)level{
    if (self.leadings.count > level) {
        if (self.leadings[level].count > idx) {
            WD_QTableModel *model = self.leadings[level][idx];
            model.indexPath = [NSIndexPath indexPathForRow:idx inSection:level];
            return model;
        }
    }
    return [WD_QTableModel placeModel];
}

-(WD_QTableModel *)modelForItem:(NSIndexPath *)indexPath{
    //常规数据是以列为基准的， data:列:行  section:列 item:行
    if (!self.needTranspostionForModel) {
        if (self.datas.count > indexPath.section) {
            if (self.datas[indexPath.section].count > indexPath.item) {
                WD_QTableModel *model = self.datas[indexPath.section][indexPath.item];
                model.indexPath = indexPath;
                return model;
            }
        }
    }else{ //needTranspostionForModel data:行:列 section:行 item:列
        if (self.datas.count > indexPath.item) {
            if (self.datas[indexPath.item].count > indexPath.section) {
                WD_QTableModel *model = self.datas[indexPath.item][indexPath.section];
                model.indexPath = indexPath;
                return model;
            }
        }
    }
    return [[WD_QTableModel alloc] init];
}
-(NSString *)titleForModel:(NSIndexPath *)indexPath{
    WD_QTableModel *model = [self modelForItem:indexPath];
    if (model) {
        return model.title != nil ? model.title : @"";
    }
    return @"";
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger colNum = [self colsNum];
    if(self.leadings.count > colNum) colNum = self.leadings.count;
    if (self.headings.count && [self.headings lastObject].count > colNum) colNum = [self.headings lastObject].count;
    return colNum ? colNum : 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger rowNum = [self rowsNum];
    if(self.headings.count > rowNum) rowNum = self.headings.count;
    if (self.leadings.count && [self.leadings lastObject].count > rowNum) rowNum = [self.leadings lastObject].count;
    return rowNum ? rowNum : 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"cell%@",[self.styleConstructor WD_QTableReuseCellPrefix]] forIndexPath:indexPath];
    [self.styleConstructor constructItemCollectionView:cell By:[self modelForItem:indexPath]];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WD_QTableBaseReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[NSString stringWithFormat:@"supplmentCell%@",[self.styleConstructor WD_QTableReuseCellPrefix]] forIndexPath:indexPath];
    cell.supplementaryName = kind;
    cell.delegate = self;
    cell.indexPath = indexPath;
    if ([kind isEqualToString:@"leadingSupplementaryView"]) {
        [self.styleConstructor constructLeadingSupplementary:cell By:[self modelForLeading:indexPath.item level:indexPath.section]];
    }else if ([kind isEqualToString:@"headingSupplementaryView"]){
        [self.styleConstructor constructHeadingSupplementary:cell By:[self modelForHeading:indexPath.item level:indexPath.section]];
    }else if ([kind isEqualToString:@"mainSupplementaryView"]){
        [self.styleConstructor constructMainSupplementary:cell By:self.mainModel];
    }else if ([kind isEqualToString:@"sectionSupplementaryView"]){
        [self.styleConstructor constructSectionSupplementary:cell By:[self modelForLeading:indexPath.item level:0].sectionModel];
    }
    return cell;
}

#pragma mark - EventDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.didSelectItemBlock) self.didSelectItemBlock(indexPath.row,indexPath.section,[self modelForItem:indexPath]);
}

-(void)WD_QTableReusableViewName:(NSString *)SupplementaryName didSelectSupplementaryAtIndexPath:(NSIndexPath *)indexPath{
    if ([SupplementaryName isEqualToString:@"mainSupplementaryView"]) {
    }else if ([SupplementaryName isEqualToString:@"headingSupplementaryView"]) {
        if(self.didSelectHeadingBlock) self.didSelectHeadingBlock(indexPath);
    }else if ([SupplementaryName isEqualToString:@"leadingSupplementaryView"]) {
        if(self.didSelectLeadingBlock) self.didSelectLeadingBlock(indexPath);
    }else if ([SupplementaryName isEqualToString:@"sectionSupplementaryView"]) {
        if(self.didSelectSectionBlock)  self.didSelectSectionBlock(indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    CGRect headerRect = self.headView.frame;
    headerRect.origin.x = scrollView.contentOffset.x;
    if(self.headView) self.headView.frame = headerRect;
    if (self.bottomView) {
        CGRect bottomViewRect = self.bottomView.frame;
        bottomViewRect.origin.x = scrollView.contentOffset.x;
        self.bottomView.frame = bottomViewRect;
    }
}

#pragma mark - 控制器方法
-(void)viewWillLayoutSubviews{
    if (!CGSizeEqualToSize(self.view.frame.size, CGSizeZero) && !CGSizeEqualToSize(self.collectionView.frame.size, self.view.frame.size)) {
        CGRect rect = self.collectionView.frame;
        rect.size = self.view.frame.size;
        self.collectionView.frame = rect;
        
        [self updateSupplementaryPosition];
        
        BOOL needLayout = [self.layoutConstructor adjustLayoutForNewFrame:rect colCount:[self colsNum] andRowCount:[self rowsNum]];
        if (needLayout) [self reloadData];
        
    }
    [super viewWillLayoutSubviews];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self updateStyleConstructor:self.styleConstructor];
    [self updateLayoutConstructor:self.layoutConstructor];
    [self.view addSubview:self.collectionView];
}

#pragma mark - layout callBack

-(NSInteger)colsNum{
    NSInteger colNum = 0 ;
    if (self.needTranspostionForModel) {
        colNum = self.datas.count ? self.datas[0].count : 0;
    }else{
        colNum = self.datas.count;
    }
    return colNum >= [self.headings lastObject].count ? colNum : [self.headings lastObject].count;
}
-(NSInteger)rowsNum{
    NSInteger rowNum = 0;
    if (self.needTranspostionForModel) {
        rowNum = self.datas.count;
    }else{
        rowNum = self.datas.count ? self.datas[0].count : 0;
    }
    return rowNum >= [self.leadings lastObject].count ? rowNum : [self.leadings lastObject].count;
}

-(NSInteger)colNumberOfCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return [self colsNum];
}
-(NSInteger)rowNumberOfCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return [self rowsNum];
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout heightOfRow:(NSInteger)row{
    return [self.layoutConstructor rowHeightAtRowId:row];
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout widthOfCol:(NSInteger)col{
    return [self.layoutConstructor colWidthAtcolId:col];
}

/* 可选 边界宽度 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginTopOfRow:(NSInteger)row{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginBottomOfRow:(NSInteger)row {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginLeftOfCol:(NSInteger)col {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginRightOfCol:(NSInteger)col {
    return 0;
}

/* 可选 Leading-Heading配置 */

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout leadingWidthOfLevel:(NSInteger)level{
    return [self.layoutConstructor leadingWAtLevel:level];
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout HeadingheightOfLevel:(NSInteger)level{
    return [self.layoutConstructor headingHAtLevel:level];
}
-(CGFloat)sectionOfItemInCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout InRow:(NSInteger)row{
    if ([self modelForLeading:row level:0].sectionModel) {
        return [self.layoutConstructor headingHAtLevel:0];
    }
    return 0.f;
}

/* 可选 Leading-Heading级数 */

-(NSInteger)leadingLevelOfcollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return self.leadings.count;
}
-(NSInteger)headingLevelOfcollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return self.headings.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout ItemCollapseColNumberInRow:(NSInteger)row AtCol:(NSInteger)col{
        return [self modelForItem:[NSIndexPath indexPathForItem:row inSection:col]].collapseCol;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout ItemCollapseRowNumberInCol:(NSInteger)col AtRow:(NSInteger)row{
        return [self modelForItem:[NSIndexPath indexPathForItem:row inSection:col]].collapseRow;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout LeadingCollapseColNumberInRow:(NSInteger)row AtLevel:(NSInteger)level{
    return [self modelForLeading:row level:level].collapseCol;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout LeadingCollapseRowNumberInLevel:(NSInteger)level AtRow:(NSInteger)row{
    return [self modelForLeading:row level:level].collapseRow;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout HeadingCollapseColNumberInLevel:(NSInteger)level AtCol:(NSInteger)col{
    return [self modelForHeading:col level:level].collapseCol;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout HeadingCollapseRowNumberInCol:(NSInteger)col AtLevel:(NSInteger)level{
    return [self modelForHeading:col level:level].collapseRow;
}

@end

