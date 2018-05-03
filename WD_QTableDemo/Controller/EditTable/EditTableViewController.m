//
//  EditTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/4/4.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "EditTableViewController.h"
#import "WD_QTableHeader.h"
#import "Masonry.h"
#import "EditTableStyleConstructor.h"

@interface EditTableViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation EditTableViewController

-(WD_QTable *)table{
    if (!_table) {
        WD_QTableAutoLayoutConstructor *config =  [[WD_QTableAutoLayoutConstructor alloc] init];
        EditTableStyleConstructor *style = [[EditTableStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        WD_QTableAdaptor *autoHandle =  [[WD_QTableAdaptor alloc] initWithTableStyle:style ToLayout:config];
        _table.autoLayoutHandle = autoHandle;
        config.inset = UIEdgeInsetsMake(0, 0, 0, 0);
        _table.needTranspostionForModel = YES;
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

    self.table.didSelectItemBlock = ^(NSInteger row, NSInteger col, WD_QTableModel *model,WD_QTableBaseViewCell *cell) {
        model.title = @"dasdasdasdasdasdasdasdasdasdascasdasdasdasdasdasdasdadsdasdasdasdasdasdasd";
        [weakSelf.table updateItem:model AtCol:col InRow:row];
    };
    
    [self loadData];
    UIBarButtonItem *addRowBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(insertRowNew:)];
    UIBarButtonItem *addColBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(insertColNew:)];
    self.navigationItem.rightBarButtonItems = @[addRowBtn,addColBtn];
    
}

-(void)insertRowNew:(id)sender{
    [self.table insertEmptyRowAtRow:0];
}
-(void)insertColNew:(id)sender{
    [self.table insertEmptyColAtCol:0];
}

-(void)loadData{
    
    NSInteger rowNum = 1;
    NSInteger colNum = 1;
    
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
    
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"Heading";
        [headings addObject:model];
    }
    
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger row = 0; row < rowNum; row++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger col = 0; col < colNum; col++) {
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
