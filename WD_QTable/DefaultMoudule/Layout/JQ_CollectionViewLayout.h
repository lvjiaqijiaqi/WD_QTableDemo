//
//  JQ_CollectionViewLayout.h
//  WD_QTableDemo
//
//  Created by jqlv on 2018/1/9.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JQ_CollectionViewLayout;

@protocol JQ_CollectionViewLayoutDelegate<NSObject>

@required
/* ITEM配置 */
/* 列数 */
-(NSInteger)colNumberOfCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout;
/* 行数 */
-(NSInteger)rowNumberOfCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout;

/* 列宽 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout widthOfCol:(NSInteger)col;
/* 行高 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout heightOfRow:(NSInteger)row;

/* ITEM edges */
/*-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginLeftOfCol:(NSInteger)col;
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginTopOfRow:(NSInteger)row;
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginRightOfCol:(NSInteger)col;
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout marginBottomOfRow:(NSInteger)row;
*/
/* Item跨度 */
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout ItemCollapseColNumberInRow:(NSInteger)row AtCol:(NSInteger)col;
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout ItemCollapseRowNumberInCol:(NSInteger)col AtRow:(NSInteger)row;

-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout LeadingCollapseColNumberInRow:(NSInteger)row AtLevel:(NSInteger)level;
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout LeadingCollapseRowNumberInLevel:(NSInteger)level AtRow:(NSInteger)row;

-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout HeadingCollapseColNumberInLevel:(NSInteger)level AtCol:(NSInteger)col;
-(NSInteger)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout HeadingCollapseRowNumberInCol:(NSInteger)col AtLevel:(NSInteger)level;


/* Heading-Leading配置 支持多表头(Leading-Heading)*/

/* Leading级数 */
-(NSInteger)leadingLevelOfcollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout;
/* Heading级数 */
-(NSInteger)headingLevelOfcollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout;

/* Heading高度 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout HeadingheightOfLevel:(NSInteger)level;
/* Leading宽度 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout leadingWidthOfLevel:(NSInteger)level;

/* Section高度 */
-(CGFloat)sectionOfItemInCollectionView:(UICollectionView *)collectionView layout:(JQ_CollectionViewLayout *)collectionViewLayout InRow:(NSInteger)row;

@end


@interface JQ_CollectionViewLayout : UICollectionViewLayout

@property(nonatomic,weak) id<JQ_CollectionViewLayoutDelegate> layoutDelegate;
-(void)resetLayout;
-(void)updateLayout;
-(void)invalidLayoutAtRowIndex:(NSInteger)rowIdx;
-(void)invalidLayoutAtColIndex:(NSInteger)colIdx;
-(void)invalidLayoutAtRow:(NSInteger)rowIdx InCol:(NSInteger)colIdx;
@end
