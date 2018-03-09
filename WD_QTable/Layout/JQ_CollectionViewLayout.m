//
//  JQ_CollectionViewLayout.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "JQ_CollectionViewLayout.h"
#import "JQ_CollectionViewLayoutInvalidationContext.h"

typedef NS_ENUM(NSInteger, CellzIndexLevel) {
    CellzIndexItem = 65533,
    CellzIndexLeading = 2147483645,
    CellzIndexSection = 2147483646,
    CellzIndexHeading = 2147483645,
    CellzIndexMain = 2147483647,
};

@interface JQ_CollectionViewLayout()

#pragma mark - 自定义invalidContext
@property (nonatomic, strong) JQ_CollectionViewLayoutInvalidationContext *invalidContext;

@property(nonatomic,assign) CGFloat leadingMarginToItem;
@property(nonatomic,assign) CGFloat headingMarginToItem;

#pragma mark - 缓存
@property (nonatomic, strong) NSMutableIndexSet *sectionIndexs;
@property (nonatomic, strong) NSMutableArray *LeadingPos;
@property (nonatomic, strong) NSMutableArray *HeadingPos;

@property (nonatomic,strong) NSMutableArray<NSNumber *> *rowsPosition;
@property (nonatomic,strong) NSMutableArray<NSNumber *> *colsPosition;

@property (nonatomic,assign) CGSize boundSize;

@property (nonatomic,assign) NSInteger rowNum;
@property (nonatomic,assign) NSInteger colNum;

@end

@implementation JQ_CollectionViewLayout

#pragma mark -  初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultConfig];
    }
    return self;
}

-(void)initDefaultConfig{
    
    _leadingMarginToItem = 0.f;
    _headingMarginToItem = 0.f;
    _boundSize = CGSizeZero;
    
    self.invalidContext = [[JQ_CollectionViewLayoutInvalidationContext alloc] init];
    
    /* 缓存初始化 */
    _LeadingPos = [NSMutableArray array];
    _HeadingPos = [NSMutableArray array];
    
    self.sectionIndexs = [[NSMutableIndexSet alloc] init];
    
    self.rowsPosition = [NSMutableArray array];
    self.colsPosition = [NSMutableArray array];
    
}
-(void)resetLayout{ /* 清空缓存,重新开始预布局  */
    
    [self.sectionIndexs removeAllIndexes];
    [self.rowsPosition removeAllObjects];
    [self.colsPosition removeAllObjects];
    
    _rowNum = 0;
    _colNum = 0;
    
    /* headingMarginToItem */
    self.headingMarginToItem = 0.f;
    for (NSInteger col = 0 ; col < [self headingLevel] ; col++ ) {
        [self.HeadingPos addObject:[NSNumber numberWithFloat:self.headingMarginToItem]];
        self.headingMarginToItem += [self headingHeight:col];
    }
    /* leadingMarginToItem */
    self.leadingMarginToItem = 0.f;
    for (NSInteger row = 0 ; row < [self leadingLevel] ; row++ ) {
        [self.LeadingPos addObject:[NSNumber numberWithFloat:self.leadingMarginToItem]];
        self.leadingMarginToItem  += [self leadingWidth:row];
    }
    self.invalidContext = [[JQ_CollectionViewLayoutInvalidationContext alloc] init];
    
}

#pragma mark - 辅助函数

/* 滑动时候修正Leading和Heading，使其始终保持在offset = 0处 */
-(CGFloat)layoutOffsetY{
    CGFloat OffsetY = 0.f;
    if (self.collectionView.contentOffset.y > 0) OffsetY = self.collectionView.contentOffset.y;
    return OffsetY;
}
-(CGFloat)layoutOffsetX{
    CGFloat OffsetX = 0.f;
    if (self.collectionView.contentOffset.x > 0) OffsetX = self.collectionView.contentOffset.x;
    return OffsetX;
}
-(CGFloat)leadingPosX:(NSInteger)level{
    if (level < self.LeadingPos.count) {
        return [self.LeadingPos[level] floatValue] + [self layoutOffsetX];
    }
    /* 缓存丢失 添加*/
    CGFloat PosX = [self layoutOffsetX];
    NSInteger start = 0;
    if(self.LeadingPos.count) {
        start = self.LeadingPos.count - 1;
        PosX = [[self.LeadingPos lastObject] floatValue] + [self leadingWidth:start];
    }
    for (; start <= level ; start++ ) {
        [self.LeadingPos addObject:[NSNumber numberWithFloat:PosX]];
        PosX += [self leadingWidth:start];
    }
    return PosX + [self layoutOffsetX];
}
-(CGFloat)headingPosY:(NSInteger)level{
    if (level < self.HeadingPos.count) {
        return [self.HeadingPos[level] floatValue] + [self layoutOffsetY];
    }
    /* 缓存丢失 添加*/
    CGFloat PosY = [self layoutOffsetY];
    NSInteger start = 0;
    if(self.HeadingPos.count) {
        start = self.HeadingPos.count - 1;
        PosY = [[self.HeadingPos lastObject] floatValue] + [self headingHeight:start];
    }
    for (; start <= level ; start++ ) {
        [self.HeadingPos addObject:[NSNumber numberWithFloat:PosY]];
        PosY += [self headingHeight:start];
    }
    return PosY + [self layoutOffsetY];
            
}
#pragma mark - frame配置函数 delegate形式

/* 计算bounds */
-(CGFloat)ContentSizeWidth{
    return [self itemOffsetXInCol:self.colsNumber] ;
}
-(CGFloat)ContentSizeHeight{
    return [self itemOffsetYInRow:self.rowsNumber] ;
}

#pragma mark Item配置
-(NSInteger)rowsNumber{
   return [self.layoutDelegate rowNumberOfCollectionView:self.collectionView layout:self];
}
-(NSInteger)colsNumber{
   return [self.layoutDelegate colNumberOfCollectionView:self.collectionView layout:self];
}
-(CGFloat)heightInRow:(NSInteger)row{
    return [self.layoutDelegate collectionView:self.collectionView layout:self heightOfRow:row];
}
-(CGFloat)widthInCol:(NSInteger)col{
    return [self.layoutDelegate collectionView:self.collectionView layout:self widthOfCol:col];
}

#pragma mark  Heading-Leading配置

-(CGFloat)sectionHeight:(NSInteger)row{
    return [self.layoutDelegate sectionOfItemInCollectionView:self.collectionView layout:self InRow:row];
}
-(NSInteger)leadingLevel{
    return [self.layoutDelegate leadingLevelOfcollectionView:self.collectionView layout:self];
}
-(NSInteger)headingLevel{
    return [self.layoutDelegate headingLevelOfcollectionView:self.collectionView layout:self];
}
-(CGFloat)headingHeight:(NSInteger)level{
    return [self.layoutDelegate collectionView:self.collectionView layout:self HeadingheightOfLevel:level];
}
-(CGFloat)leadingWidth:(NSInteger)level{
    return [self.layoutDelegate collectionView:self.collectionView layout:self leadingWidthOfLevel:level];
}

-(NSInteger)LeadingCollapseColInRow:(NSInteger)row AtLevel:(NSInteger)level{
   return [self.layoutDelegate collectionView:self.collectionView layout:self LeadingCollapseColNumberInRow:row AtLevel:level];
}
-(NSInteger)LeadingCollapseRowInLevel:(NSInteger)level AtRow:(NSInteger)row{
    return [self.layoutDelegate collectionView:self.collectionView layout:self LeadingCollapseRowNumberInLevel:level AtRow:row];
}

-(NSInteger)HeadingCollapseColInLevel:(NSInteger)level AtCol:(NSInteger)col{
    return [self.layoutDelegate collectionView:self.collectionView layout:self HeadingCollapseColNumberInLevel:level AtCol:col];
}
-(NSInteger)HeadingCollapseRowInCol:(NSInteger)col AtLevel:(NSInteger)level{
    return [self.layoutDelegate collectionView:self.collectionView layout:self HeadingCollapseRowNumberInCol:col AtLevel:level];
}

-(NSInteger)ItemCollapseRowInCol:(NSInteger)col AtRow:(NSInteger)row{
    return [self.layoutDelegate collectionView:self.collectionView layout:self ItemCollapseRowNumberInCol:col AtRow:row];
}
-(NSInteger)ItemCollapseColInRow:(NSInteger)row AtRow:(NSInteger)col{
    return [self.layoutDelegate collectionView:self.collectionView layout:self ItemCollapseColNumberInRow:row AtCol:col];
}

#pragma mark - UICollectionLayout父类方法继承(必须)
-(void)prepareLayout{
    [super prepareLayout];
    self.boundSize = CGSizeMake([self ContentSizeWidth], [self ContentSizeHeight]);
}
-(CGSize)collectionViewContentSize{
    if (!CGSizeEqualToSize(CGSizeZero, self.boundSize)) {
        return self.boundSize;
    }
    return CGSizeMake([self ContentSizeWidth],  [self ContentSizeHeight]);
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    if (!CGSizeEqualToSize(newBounds.size, self.boundSize)) {
        
        /* 计算固定在顶部的Section */
        self.invalidContext.currentSection = [self.sectionIndexs indexLessThanOrEqualToIndex:[self rowIndexFromYCoordinate:newBounds.origin.y  + self.headingMarginToItem]];
        
        [self invalidateLayoutWithContext:[self invalidationContextForBoundsChange:newBounds]];
        return NO;
    }
    return YES;
}
-(UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds{
    if (!CGRectEqualToRect(newBounds, CGRectZero)){
        return self.invalidContext;
    }
    return [super invalidationContextForBoundsChange:newBounds];
}
-(void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context{
    /* iphoneX 这个地方有问题 */
    [super invalidateLayoutWithContext:[self invalidationContextForBoundsChange:self.collectionView.bounds]];
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray array];
    NSArray *visibleIndexPaths = [self indexPathOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    NSArray *leadingSupplementaryIndexPath = [self indexPathOfLeadingSuplementaryInRect:CGRectUnion(rect, self.invalidContext.lastLayoutBounds)];
    NSArray *diffLeadingIndex = [self differentIndexsArr:leadingSupplementaryIndexPath inOtherArr:self.invalidContext.leadingSupplementary];
    for (NSIndexPath *indexPath in diffLeadingIndex) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"leadingSupplementaryView" atIndexPath:indexPath];
        [self.invalidContext.leadingSupplementary addObject:indexPath];
        [layoutAttributes addObject:attributes];
    }
    self.invalidContext.leadingSupplementaryInvalid = [NSMutableArray arrayWithArray:leadingSupplementaryIndexPath];
    
    NSArray *headingSupplementaryIndexPath = [self indexPathOfHeadingSuplementaryInRect:CGRectUnion(rect, self.invalidContext.lastLayoutBounds)];
    NSArray *diffHeadingIndex = [self differentIndexsArr:headingSupplementaryIndexPath inOtherArr:self.invalidContext.headingSupplementary];
    for (NSIndexPath *indexPath in diffHeadingIndex) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"headingSupplementaryView" atIndexPath:indexPath];
        [self.invalidContext.headingSupplementary addObject:indexPath];
        [layoutAttributes addObject:attributes];
    }
    self.invalidContext.headingSupplementaryInvalid = [NSMutableArray arrayWithArray:headingSupplementaryIndexPath];
    
    NSArray *mainIndexPaths = [self indexPathOfMainSuplementaryInRect:rect];
    NSArray *diffMainIndex = [self differentIndexsArr:mainIndexPaths inOtherArr:self.invalidContext.mainSupplementary];
    for (NSIndexPath *indexPath in diffMainIndex) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"mainSupplementaryView" atIndexPath:indexPath];
        [self.invalidContext.mainSupplementary addObject:indexPath];
        [layoutAttributes addObject:attributes];
    }
    self.invalidContext.mainSupplementaryInvalid = [NSMutableArray arrayWithArray:mainIndexPaths];
    
    NSArray *sectionSupplementaryIndexPath = [self indexPathOfSectionSuplementaryInRect:rect];
    NSArray *diffSectionIndex = [self differentIndexsArr:sectionSupplementaryIndexPath inOtherArr:self.invalidContext.sectionSupplementary];
    for (NSIndexPath *indexPath in diffSectionIndex) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"sectionSupplementaryView" atIndexPath:indexPath];
        [self.invalidContext.sectionSupplementary addObject:indexPath];
        [layoutAttributes addObject:attributes];
    }
    self.invalidContext.sectionSupplementaryInvalid = self.invalidContext.sectionSupplementary;
    
    self.invalidContext.lastLayoutBounds = rect;
    return layoutAttributes;
    
}

/* layout改变的时候（比如转屏）调用的方法 */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
    return proposedContentOffset;
}
/* 加速滑动的时候 可以改变滑动结束的CGPoint */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    return proposedContentOffset;
}

#pragma mark - UICollectionViewLayoutAttributes配置函数

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = [self frameAtCol:indexPath.section andRow:indexPath.item];
    attribute.zIndex = CellzIndexItem - (indexPath.section + indexPath.item);
    return attribute;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    attributes.frame = [self frameOfSupplementary:kind AtIndex:indexPath];
    if ([kind isEqualToString:@"leadingSupplementaryView"]) {
        attributes.zIndex = CellzIndexLeading - (indexPath.section + indexPath.item);
    } else if ([kind isEqualToString:@"sectionSupplementaryView"]) {
        attributes.zIndex = CellzIndexSection;
    }else if ([kind isEqualToString:@"mainSupplementaryView"]){
        attributes.zIndex = CellzIndexMain;
    }else if ([kind isEqualToString:@"headingSupplementaryView"]){
        attributes.zIndex = CellzIndexHeading - (indexPath.section + indexPath.item);
    }
    return attributes;
}

#pragma mark - 布局函数

-(CGRect)frameOfSupplementary:(NSString *)name AtIndex:(NSIndexPath *)indexPath{
    if ([name isEqualToString:@"sectionSupplementaryView"]) {
        return  [self sectionFrame:indexPath.item];
    }else if ([name isEqualToString:@"leadingSupplementaryView"]){
        return [self leadingFrame:indexPath.item ofLevel:indexPath.section];
    }else if ([name isEqualToString:@"headingSupplementaryView"]){
        return [self headingFrame:indexPath.item ofLevel:indexPath.section];
    }else if ([name isEqualToString:@"mainSupplementaryView"]){
        return [self mainFrame:indexPath.item];
    }
    return CGRectZero;
}
-(NSArray *)indexPathOfItemsInRect:(CGRect)rect{
    /*  item:row  section:col  */
    NSInteger minVisibleCol =  [self colIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleCol =  [self colIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleRow =  [self rowIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleRow =  [self rowIndexFromYCoordinate:CGRectGetMaxY(rect)];
    NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray array];
    for (NSInteger col = minVisibleCol;  col <= maxVisibleCol && col >= 0; col++) {
        for (NSInteger row = minVisibleRow;  row <= maxVisibleRow && row >= 0 ; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:col];
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths;
}
-(NSArray *)indexPathOfHeadingSuplementaryInRect:(CGRect)rect{
    NSInteger minVisibleCol =  [self colIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleCol =  [self colIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minVisibleCol; idx <= maxVisibleCol && idx >= 0; idx++) {
        for (NSInteger level = 0 ; level < [self headingLevel] ; level++ ) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:level];
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths;
}
-(NSArray *)indexPathOfLeadingSuplementaryInRect:(CGRect)rect{
    NSInteger minVisibleRow =  [self rowIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleRow =  [self rowIndexFromYCoordinate:CGRectGetMaxY(rect)];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minVisibleRow; idx <= maxVisibleRow && idx >= 0; idx++) {
        for (NSInteger level = 0 ; level < [self leadingLevel] ; level++ ) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:level];
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths;
}
-(NSArray *)indexPathOfMainSuplementaryInRect:(CGRect)rect{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [indexPaths addObject:indexPath];
    return indexPaths;
}
-(NSArray *)indexPathOfSectionSuplementaryInRect:(CGRect)rect{
    NSInteger minVisibleRow =  [self rowIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleRow =  [self rowIndexFromYCoordinate:CGRectGetMaxY(rect)];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minVisibleRow; idx <= maxVisibleRow && idx >= 0; idx++) {
        if ([self.sectionIndexs containsIndex:idx]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }
    return indexPaths;
}

#pragma mark - frame计算

-(CGRect)frameAtCol:(NSInteger)col andRow:(NSInteger)row{
    CGFloat width = 0.f;
    for (NSInteger collapseCol = [self ItemCollapseColInRow:row AtRow:col] - 1; collapseCol >= 0; collapseCol--) {
        width += [self widthInCol:col + collapseCol];
    }
    CGFloat height = 0.f;
    for (NSInteger collapseRow = [self ItemCollapseRowInCol:col AtRow:row] - 1; collapseRow >= 0; collapseRow--) {
        height += [self heightInRow:row + collapseRow];
    }
    CGRect itemFrame = CGRectMake([self itemOffsetXInCol:col], [self itemOffsetYInRow:row] + [self sectionHeight:row], width, height);
    return itemFrame;
}
-(CGRect)leadingFrame:(NSInteger)idx ofLevel:(NSInteger)level{
    CGFloat width = 0.f;
    for (NSInteger collapseCol = [self LeadingCollapseColInRow:idx AtLevel:level] - 1; collapseCol >= 0; collapseCol--) {
        width += [self leadingWidth:level + collapseCol];
    }
    CGFloat height = 0.f;
    for (NSInteger collapseRow = [self LeadingCollapseRowInLevel:level AtRow:idx] - 1; collapseRow >= 0; collapseRow--) {
        height += [self heightInRow:idx + collapseRow];
    }
    return CGRectMake([self leadingPosX:level] , [self itemOffsetYInRow:idx] + [self sectionHeight:idx], width, height);
}
-(CGRect)headingFrame:(NSInteger)idx ofLevel:(NSInteger)level{
    CGFloat width = 0.f;
    for (NSInteger collapseCol = [self HeadingCollapseColInLevel:level AtCol:idx] - 1; collapseCol >= 0; collapseCol--) {
        width += [self widthInCol:idx + collapseCol];
    }
    CGFloat height = 0.f;
    for (NSInteger collapseRow = [self HeadingCollapseRowInCol:idx AtLevel:level] - 1; collapseRow >= 0; collapseRow--) {
        height += [self headingHeight:level + collapseRow];
    }
    return CGRectMake([self itemOffsetXInCol:idx], [self headingPosY:level], width, height);
}
-(CGRect)sectionFrame:(NSInteger)row{
    CGRect rect = CGRectZero;
    rect = CGRectMake([self layoutOffsetX], [self itemOffsetYInRow:row] , self.collectionView.frame.size.width, [self sectionHeight:row]);
    if (row == self.invalidContext.currentSection) rect.origin.y = self.headingMarginToItem + [self layoutOffsetY];
    return rect;
}
-(CGRect)mainFrame:(NSInteger)idx{
    return CGRectMake([self layoutOffsetX], [self layoutOffsetY], self.leadingMarginToItem, self.headingMarginToItem);
}
#pragma mark - 坐标转索引
- (NSInteger)colIndexFromXCoordinate:(CGFloat)xPosition{
    return [self colIndexFromXCoordinate:xPosition Form:0 ToEnd:self.colsNumber - 1];
}
- (NSInteger)rowIndexFromYCoordinate:(CGFloat)yPosition{
    return [self rowIndexFromYCoordinate:yPosition Form:0 ToEnd:self.rowsNumber - 1];
}
/* 2分查找 */
-(NSInteger)colIndexFromXCoordinate:(CGFloat)xPosition Form:(NSInteger)start ToEnd:(NSInteger)end {
    if (start >= end) {
        return start;
    }
    NSInteger middle = (end + start) / 2;
    CGFloat offsetXMin = [self itemOffsetXInCol:middle];
    CGFloat offsetXMax = [self itemOffsetMaxXInCol:middle];
    if (offsetXMin <= xPosition && xPosition <= offsetXMax) {
        return middle;
    }
    if (offsetXMin < xPosition) {
        if (middle+1 > end) return end;
        return [self colIndexFromXCoordinate:xPosition Form:middle+1 ToEnd:end];
    }else{
        if (middle-1 < start) return start;
        return [self colIndexFromXCoordinate:xPosition Form:start ToEnd:middle-1];
    }
}
-(NSInteger)rowIndexFromYCoordinate:(CGFloat)yPosition Form:(NSInteger)start ToEnd:(NSInteger)end {
    if (start >= end) {
        return start;
    }
    NSInteger middle = (end + start) / 2;
    CGFloat offsetYMin = [self itemOffsetYInRow:middle];
    CGFloat offsetYMax = [self itemOffsetMaxYInRow:middle];
    if (offsetYMin <= yPosition && yPosition <= offsetYMax) {
        return middle;
    }
    if (offsetYMin < yPosition) {
        return [self rowIndexFromYCoordinate:yPosition Form:middle+1 ToEnd:end];
    }else{
        return [self rowIndexFromYCoordinate:yPosition Form:start ToEnd:middle-1];
    }
}

#pragma mark - 索引转坐标  PS:缓存这存储
-(CGFloat)itemOffsetXInCol:(NSInteger)colId{
    __block CGFloat offsetX = self.leadingMarginToItem;
    NSInteger col = 0;
    if (self.colsPosition.count > 0) {
        col = self.colsPosition.count > colId ? colId : self.colsPosition.count - 1;
        offsetX = [self.colsPosition[col] floatValue];
    }else{
        [self.colsPosition addObject:[NSNumber numberWithFloat:offsetX]];
    }
    for (; col < colId; col++) {
        offsetX = offsetX + [self widthInCol:col];
        [self.colsPosition addObject:[NSNumber numberWithFloat:offsetX]];
    }
    return offsetX;
}
-(CGFloat)itemOffsetMaxXInCol:(NSInteger)colId{
    return [self itemOffsetXInCol:colId + 1];
}

-(CGFloat)itemOffsetYInRow:(NSInteger)rowId{
    __block CGFloat offsetY = self.headingMarginToItem;
    NSInteger row = 0;
    if (self.rowsPosition.count > 0) {
        row = self.rowsPosition.count > rowId ? rowId : self.rowsPosition.count - 1;
        offsetY = [self.rowsPosition[row] floatValue];
    }else{
        [self.rowsPosition addObject:[NSNumber numberWithFloat:offsetY]];
    }
    for (; row < rowId; row++) {
        offsetY = offsetY + [self heightInRow:row] + [self sectionHeight:row];
        [self.rowsPosition addObject:[NSNumber numberWithFloat:offsetY]];
        if([self sectionHeight:row] != 0) [self.sectionIndexs addIndex:row];
    }
    return offsetY;
}
-(CGFloat)itemOffsetMaxYInRow:(NSInteger)rowId{
    return [self itemOffsetYInRow:rowId + 1];
}

#pragma mark - 工具函数
//差集计算
-(NSArray *)differentIndexsArr:(NSArray *)arr1 inOtherArr:(NSArray *)arr2{
    NSMutableSet *set1 = [NSMutableSet setWithArray:arr1];
    NSMutableSet *set2 = [NSMutableSet setWithArray:arr2];
    [set1 minusSet:set2];
    return [set1 allObjects];
}


@end
