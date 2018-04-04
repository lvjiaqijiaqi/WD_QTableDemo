//
//  WD_QFitTable.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "WD_QFitTable.h"

#import "WD_QTableBaseReusableView.h"
#import "WD_QTableBaseViewCell.h"

#import "WD_QTableDefaultStyleConstructor.h"
#import "WD_QTableDefaultLayoutConstructor.h"

#import "WD_QTableModel.h"

#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self.lock)

@interface WD_QFitTable ()<WD_QTableBaseReusableViewDelegate,JQ_CollectionViewLayoutDelegate,WD_QTableBaseCellViewDelegate>

@property (nonatomic,strong) id<WD_QTableDefaultStyleConstructorDelegate> styleConstructor;
@property (nonatomic,strong) id<WD_QTableDefaultLayoutConstructorDelegate> layoutConstructor;

@property (nonatomic,strong) JQ_CollectionViewLayout *collectionLayout;

@property (nonatomic,strong) WD_QTableModel *mainModel;
@property (nonatomic,strong) dispatch_semaphore_t lock;

@property (nonatomic,strong) WD_QViewModel *variationModel;

@property (nonatomic,strong) NSMutableArray<WD_QTableModel *> *headings;
@property (nonatomic,strong) NSMutableArray<WD_QTableModel *> *leadings;
@property (nonatomic,strong) NSMutableArray<WD_QTableModel *> *datas;

@property (nonatomic,assign) NSInteger colsNum;
@property (nonatomic,assign) NSInteger rowsNum;

@property (nonatomic,assign) NSInteger LeadingRowNum;
@property (nonatomic,assign) NSInteger HeadingColNum;

@property (nonatomic,assign) NSInteger LeadingLevel;
@property (nonatomic,assign) NSInteger HeadingLevel;

@end

@implementation WD_QFitTable

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
    [[self.styleConstructor itemCollectionViewCellClass] enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
    }];
    [[self.styleConstructor mainSupplementaryViewClass] enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView registerClass:obj forSupplementaryViewOfKind:@"mainSupplementaryView" withReuseIdentifier:NSStringFromClass(obj)];
    }];
    [[self.styleConstructor headingSupplementaryViewClass] enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView registerClass:obj forSupplementaryViewOfKind:@"headingSupplementaryView" withReuseIdentifier:NSStringFromClass(obj)];
    }];
    [[self.styleConstructor leadingSupplementaryViewClass] enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView registerClass:obj forSupplementaryViewOfKind:@"leadingSupplementaryView" withReuseIdentifier:NSStringFromClass(obj)];
    }];
    [[self.styleConstructor sectionSupplementaryViewClass] enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView registerClass:obj forSupplementaryViewOfKind:@"sectionSupplementaryView" withReuseIdentifier:NSStringFromClass(obj)];
    }];
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
        //self.variationModel = [[WD_QViewModel alloc] init];
        [self initCollectionView];
        self.styleConstructor  = styleConstructor;
        self.layoutConstructor = layoutConstructor;
        
        self.rowsNum = 0;
        self.colsNum = 0;
        self.LeadingLevel = 0;
        self.HeadingLevel = 0;
        self.LeadingRowNum = 0;
        self.HeadingColNum = 0;
        
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
    CGRect rect = headView.frame;
    rect.origin.y = - [self.layoutConstructor QTableInset].top;
    self.headView.frame = rect;
    [self.collectionView addSubview:self.headView];
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
        [self.autoLayoutHandle commitChange:self.variationModel FromIndex:0];
        [self.variationModel clear];
    }
    [self.collectionLayout invalidateLayout];
    [self.collectionView reloadData];
}
-(void)reloadData{ //会清空原有布局
    if (self.autoLayoutHandle) {
        Lock(); //锁住 避免多次调用卡主线程
        self.variationModel.frame = self.collectionView.frame;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.variationModel.needTranspostionForModel = self.needTranspostionForModel;
            [self.autoLayoutHandle commitChange:self.variationModel FromIndex:0];
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



#pragma mark - 更新内容

-(void)updateItem:(WD_QTableModel *)updateModel AtCol:(NSInteger)Col InRow:(NSInteger)Row{
    self.datas[[self indexAtCol:Col InRow:Row]] = updateModel;
    [self.layout invalidLayoutAtRow:Row InCol:Col];
    [self.collectionView reloadData];
}
-(void)updateLeading:(WD_QTableModel *)updateModel AtRow:(NSInteger)row InLevel:(NSInteger)level{
    NSInteger validIndex = [self indexLeadingAtIdx:row InLevel:level];
    if (validIndex < self.leadings.count) {
        self.leadings[validIndex] = updateModel;
        [self.layout invalidLayoutAtRow:row InCol:0];
        [self.collectionView reloadData];
    }
}
-(void)updateHeading:(WD_QTableModel *)updateModel AtCol:(NSInteger)col InLevel:(NSInteger)level{
    NSInteger validIndex = [self indexHeadingAtIdx:col InLevel:level];
    if (validIndex < self.leadings.count) {
        self.leadings[validIndex] = updateModel;
        [self.layout invalidLayoutAtRow:0 InCol:col];
        
    }
}

#pragma mark - 插入缺省
-(void)insertEmptyRowAtRow:(NSInteger)rowId{
    
    NSMutableArray<WD_QTableModel *> *leadingModels = [NSMutableArray array];
    for (NSInteger index = self.LeadingLevel ; index > 0; index-- ) {
        [leadingModels addObject:[WD_QTableModel emptyModel]];
    }
    [self insertLeadingModels:leadingModels atRow:rowId];
    
    NSMutableArray<WD_QTableModel *> *models = [NSMutableArray array];
    for (NSInteger index = self.colsNum ; index > 0; index-- ) {
        [models addObject:[WD_QTableModel emptyModel]];
    }
    [self insertModels:models AtRow:rowId];
    [self.layout invalidLayoutAtRowIndex:rowId];
    [self reloadData];
}
-(void)insertEmptyColAtCol:(NSInteger)colId{
    NSMutableArray<WD_QTableModel *> *headingModels = [NSMutableArray array];
    for (NSInteger index = self.HeadingLevel ; index > 0; index-- ) {
        [headingModels addObject:[WD_QTableModel emptyModel]];
    }
    [self insertHeadingModels:headingModels atCol:colId];
    
    NSMutableArray<WD_QTableModel *> *models = [NSMutableArray array];
    for (NSInteger index = self.rowsNum ; index > 0; index-- ) {
        [models addObject:[WD_QTableModel emptyModel]];
    }
    [self insertModels:models AtCol:colId];
    [self.layout invalidLayoutAtColIndex:colId];
    [self reloadData];
}

#pragma mark - Item 处理 重置，更新，插入
-(void)setMain:(WD_QTableModel *)mainModel{
    self.mainModel = mainModel;
    self.mainModel.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
-(void)resetItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData{
    [self.datas removeAllObjects];
    [self updateItemModel:newData];
}
-(void)updateItemModel:(NSArray<NSArray<WD_QTableModel *> *>*)newData{
    [newData enumerateObjectsUsingBlock:^(NSArray<WD_QTableModel *> * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section enumerateObjectsUsingBlock:^(WD_QTableModel * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.datas addObject:item];
        }];
    }];
    /* 更新行数和列数 */
    if (self.needTranspostionForModel) { //行为基准
        self.rowsNum = newData.count;
        self.colsNum = [newData firstObject].count;
    } else { //列为基准
        self.rowsNum = [newData firstObject].count;
        self.colsNum = newData.count;
    }
}
-(void)insertModels:(NSArray<WD_QTableModel *> *)newModels AtRow:(NSInteger)rowIdx{
    NSMutableIndexSet *insetIndexSets =  [[NSMutableIndexSet alloc] init];
    if (self.needTranspostionForModel) {
        [insetIndexSets addIndexesInRange:NSMakeRange(rowIdx * self.colsNum, newModels.count)];
    }else{
        for (NSInteger i = self.colsNum - 1 ; i >= 0; i--) {
            [insetIndexSets addIndex:i * self.rowsNum + rowIdx];
        }
    }
    self.rowsNum++ ;
    [self.datas insertObjects:newModels atIndexes:insetIndexSets];
}
-(void)insertModels:(NSArray<WD_QTableModel *> *)newModels AtCol:(NSInteger)colIdx{
    NSMutableIndexSet *insetIndexSets =  [[NSMutableIndexSet alloc] init];
    if (self.needTranspostionForModel) {
        [insetIndexSets addIndexesInRange:NSMakeRange(colIdx * self.rowsNum, newModels.count)];
    }else{
        for (NSInteger i = self.rowsNum - 1 ; i >= 0; i--) {
            [insetIndexSets addIndex:i * self.colsNum + colIdx];
        }
    }
    self.colsNum++ ;
    [self.datas insertObjects:newModels atIndexes:insetIndexSets];
}

#pragma mark - Heading 处理 重置，更新，插入
-(void)resetHeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    [self.headings removeAllObjects];
    self.HeadingColNum = 0;
    self.HeadingLevel = 0;
    [self updateHeadingModel:newModels];
}

-(void)updateHeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    [self.headings addObjectsFromArray:newModels];
    self.HeadingColNum += newModels.count;
    self.HeadingLevel = 1;
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
    self.HeadingColNum = 0;
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
    for (NSInteger i = 0,itemCount = [ModifyModels firstObject].count ; i < itemCount ; i++) {
        for (NSInteger j = 0,levelCount = ModifyModels.count ; j < levelCount; j++) {
            [self.headings addObject:ModifyModels[i][j]];
        }
    }
    self.HeadingLevel = ModifyModels.count;
    self.HeadingColNum += [ModifyModels firstObject].count;
    //self.variationModel.headings = ModifyModels;
}

-(void)insertHeadingModels:(NSArray<WD_QTableModel *> *)newModels atCol:(NSInteger)colId{
    [self.headings insertObjects:newModels atIndexes:[NSIndexSet indexSetWithIndex:colId]];
    self.HeadingColNum ++;
}

#pragma mark - leading处理 重置，更新，插入
-(void)resetLeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    [self.leadings removeAllObjects];
    self.LeadingRowNum = 0;
    [self updateLeadingModel:newModels];
}
-(void)updateLeadingModel:(NSArray<WD_QTableModel *> *)newModels{
    [self.leadings addObjectsFromArray:newModels];
    self.LeadingRowNum += newModels.count;
    self.LeadingLevel = 1;
  //self.variationModel.leadings = [NSArray arrayWithObject:newModels];
}
-(void)resetLeadingModelWithArr:(NSArray<NSString *> *)newArr{
    [self.leadings removeAllObjects];
    self.LeadingRowNum = 0;
    [self updateLeadingModelWithArr:newArr];
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

-(void)resetMultipleLeadingModel:(NSArray<NSArray<WD_QTableModel *> *> *)newModels{
    [self.leadings removeAllObjects];
    self.LeadingRowNum = 0;
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
    for (NSInteger i = 0,itemCount = [ModifyModels firstObject].count ; i < itemCount ; i++) {
        for (NSInteger j = 0,levelCount = ModifyModels.count ; j < levelCount; j++) {
            [self.leadings addObject:ModifyModels[i][j]];
        }
    }
    self.LeadingLevel = ModifyModels.count;
    self.LeadingRowNum += [ModifyModels firstObject].count;
    //self.variationModel.leadings = ModifyModels;
}

-(void)insertLeadingModels:(NSArray<WD_QTableModel *> *)newModels atRow:(NSInteger)rowId{
    [self.leadings insertObjects:newModels atIndexes:[NSIndexSet indexSetWithIndex:rowId]];
    self.LeadingRowNum ++;
}

#pragma mark - Model辅助方法

-(NSInteger)indexAtCol:(NSInteger)colId InRow:(NSInteger)rowId{
    if (self.needTranspostionForModel) { //行为基准
        return self.colsNum * rowId + colId;
    } else { //列为基准
        return self.rowsNum * colId + rowId;
    }
}
-(NSInteger)indexLeadingAtIdx:(NSInteger)idx InLevel:(NSInteger)level{
    return idx * self.HeadingLevel + level;
}
-(NSInteger)indexHeadingAtIdx:(NSInteger)idx InLevel:(NSInteger)level{
    return idx * self.LeadingLevel + level;
}
-(WD_QTableModel *)modelForHeading:(NSInteger)idx level:(NSInteger)level{
    NSInteger validIndex = [self indexHeadingAtIdx:idx InLevel:level];
    if (validIndex < self.headings.count) {
        return self.headings[validIndex];
    }
    return [WD_QTableModel placeModel];
}
-(WD_QTableModel *)modelForLeading:(NSInteger)idx level:(NSInteger)level{
    NSInteger validIndex = [self indexLeadingAtIdx:idx InLevel:level];
    if (validIndex < self.leadings.count) {
        return self.leadings[validIndex];
    }
    return [WD_QTableModel placeModel];
}
-(WD_QTableModel *)modelForItem:(NSIndexPath *)indexPath{
    //常规数据是以列为基准的， data:列->行  section:列 item:行
    return [self modelForItemAtCol:indexPath.section InRow:indexPath.row];
}
-(WD_QTableModel *)modelForItemAtCol:(NSInteger)colId InRow:(NSInteger)rowId{
    NSInteger validIndex = [self indexAtCol:colId InRow:rowId];
    if (validIndex < self.datas.count) {
        return self.datas[validIndex];
    }
    return [WD_QTableModel placeModel];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numberOfSections = self.colsNum;
    if (self.HeadingLevel > numberOfSections ) numberOfSections = self.HeadingLevel;
    if (self.LeadingLevel > numberOfSections ) numberOfSections = self.LeadingLevel;
    if (self.HeadingColNum > numberOfSections ) numberOfSections = self.HeadingColNum;
    return numberOfSections;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numberInSection = self.rowsNum;
    if (self.HeadingColNum > numberInSection ) numberInSection = self.HeadingColNum;
    if (self.LeadingRowNum > numberInSection ) numberInSection = self.LeadingRowNum;
    return numberInSection;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WD_QTableBaseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.styleConstructor itemCollectionViewCellIdentifier:indexPath] forIndexPath:indexPath];
    [self.styleConstructor constructItemCollectionView:cell By:[self modelForItem:indexPath]];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WD_QTableBaseReusableView *cell = nil;
    if ([kind isEqualToString:@"leadingSupplementaryView"]) {
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self.styleConstructor leadingSupplementaryIdentifier:indexPath] forIndexPath:indexPath];
        [self.styleConstructor constructLeadingSupplementary:cell By:[self modelForLeading:indexPath.item level:indexPath.section]];
    }else if ([kind isEqualToString:@"headingSupplementaryView"]){
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self.styleConstructor headingSupplementaryCellIdentifier:indexPath] forIndexPath:indexPath];
        [self.styleConstructor constructHeadingSupplementary:cell By:[self modelForHeading:indexPath.item level:indexPath.section]];
    }else if ([kind isEqualToString:@"mainSupplementaryView"]){
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self.styleConstructor mainSupplementaryCellIdentifier:indexPath] forIndexPath:indexPath];
        [self.styleConstructor constructMainSupplementary:cell By:self.mainModel];
    }else if ([kind isEqualToString:@"sectionSupplementaryView"]){
        cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self.styleConstructor sectionSupplementaryCellIdentifier:indexPath] forIndexPath:indexPath];
        [self.styleConstructor constructSectionSupplementary:cell By:[self modelForLeading:indexPath.item level:0].sectionModel];
    }
    cell.supplementaryName = kind;
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - EventDelegate

-(void)WD_QTableDidSelectAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)WD_QTableDidLongPressAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didLongPressItemBlock) {
        self.didLongPressItemBlock(indexPath.row,indexPath.section,[self modelForItem:indexPath]);
    }
}

-(void)WD_QTableReusableViewName:(NSString *)SupplementaryName didLongPressSupplementaryAtIndexPath:(NSIndexPath *)indexPath{
    if ([SupplementaryName isEqualToString:@"mainSupplementaryView"]) {
    }else if ([SupplementaryName isEqualToString:@"headingSupplementaryView"]) {
        if(self.didLongPressHeadingBlock) self.didLongPressHeadingBlock(indexPath);
    }else if ([SupplementaryName isEqualToString:@"leadingSupplementaryView"]) {
        if(self.didLongPressLeadingBlock) self.didLongPressLeadingBlock(indexPath);
    }else if ([SupplementaryName isEqualToString:@"sectionSupplementaryView"]) {
        if(self.didLongPressSectionBlock)  self.didLongPressSectionBlock(indexPath);
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
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self updateStyleConstructor:self.styleConstructor];
    [self updateLayoutConstructor:self.layoutConstructor];
    [self.view addSubview:self.collectionView];
}

#pragma mark - layout callBack


-(NSInteger)colNumberOfCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return self.colsNum > self.HeadingColNum ? self.colsNum : self.HeadingColNum;
}
-(NSInteger)rowNumberOfCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return self.rowsNum > self.LeadingRowNum ? self.rowsNum : self.LeadingRowNum ;
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
    return self.LeadingLevel;
}
-(NSInteger)headingLevelOfcollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout{
    return self.HeadingLevel;
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
