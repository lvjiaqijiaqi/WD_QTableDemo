//
//  RefreashTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "RefreashTableViewController.h"
#import "WD_QTableHeader.h"
#import "Masonry.h"

@interface RefreashTableViewController ()

@property(nonatomic,strong) WD_QRefreshTable *table;

@end

@implementation RefreashTableViewController

-(WD_QRefreshTable *)table{
    if (!_table) {
        WD_QTableDefaultLayoutConstructor *config =  [[WD_QTableDefaultLayoutConstructor alloc] init];
        WD_QTableDefaultStyleConstructor *style = [[WD_QTableDefaultStyleConstructor alloc] init];
        _table = [[WD_QRefreshTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        //_table.needTranspostionForModel = YES;
    }
    return _table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.table.view];
    [self.table.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    __weak typeof(self) weakSelf = self;
    self.table.refreshDirection = WD_QRefreshTableDirectionHorizontal;
    self.table.loadMoreHandle = ^{
        [weakSelf loadMore];
    };
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadMore{
    static NSInteger index = 2;
    NSInteger rowNum = 20;
    NSInteger colNum = 10;
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = [NSString stringWithFormat:@"Heading%ld",(long)index];
        [headings addObject:model];
    }
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger col = 0; col < colNum; col++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger row = 0; row < rowNum; row++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = [NSString stringWithFormat:@"Item%ld",(long)index];
            [rowArr addObject:model];
        }
        [data addObject:rowArr];
    }
    [self.table updateHeadingModel:headings];
    [self.table updateItemModel:data];
    [self.table loadMoreData];
    index++;
}

-(void)loadData{
    
    NSInteger rowNum = 20;
    NSInteger colNum = 30;
    
    WD_QTableModel *mainModel = [[WD_QTableModel alloc] init];
    mainModel.title = @"Main";
    
    NSMutableArray<WD_QTableModel *> *leadings = [NSMutableArray array];
    for (NSInteger i = 0; i < rowNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"Leading";
        [leadings addObject:model];
    }
    WD_QTableModel *sectionModel = [[WD_QTableModel alloc] init];
    sectionModel.title = @"Section";
    leadings[2].sectionModel = sectionModel;
    leadings[5].sectionModel = sectionModel;
    
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"Heading";
        [headings addObject:model];
    }
    
    
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger col = 0; col < colNum; col++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger row = 0; row < rowNum; row++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = @"Item";
            [rowArr addObject:model];
        }
        [data addObject:rowArr];
    }
    [self.table setMain:mainModel];
    [self.table resetItemModel:data];
    [self.table resetHeadingModel:headings];
    [self.table resetLeadingModel:leadings];
    [self.table reloadData];
}


@end
