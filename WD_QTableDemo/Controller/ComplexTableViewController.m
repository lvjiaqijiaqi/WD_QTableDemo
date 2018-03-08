//
//  ComplexTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "ComplexTableViewController.h"
#import "WD_QTableHeader.h"
#import "Masonry.h"

@interface ComplexTableViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation ComplexTableViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200.f)];
    label.text = @"WD_QTable支持一个复合表头的表格，你只需要像demo一样对数据进行配置，WD_QTable会自动的将复合表头展示出来，WD_QTableModel的collapseRow和collapseCol分别表示该元素跨行行数和跨列列数,复合表头包括对Leading和Heading的支持!";
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    label.editable = NO;
    return label;
}

-(WD_QTable *)table{
    if (!_table) {
        WD_QTableDefaultLayoutConstructor *config =  [[WD_QTableDefaultLayoutConstructor alloc] init];
        config.inset = UIEdgeInsetsMake(200, 0, 0, 0);
        WD_QTableDefaultStyleConstructor *style = [[WD_QTableDefaultStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        _table.headView = [self tipsLabel];
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
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    
    NSInteger rowNum = 30;
    NSInteger colNum = 10;
    
    WD_QTableModel *mainModel = [[WD_QTableModel alloc] init];
    mainModel.title = @"Main";
    
    NSMutableArray<WD_QTableModel *> *leadings1 = [NSMutableArray array];
    NSMutableArray<WD_QTableModel *> *leadings2 = [NSMutableArray array];
    for (NSInteger i = 0; i < rowNum/2 ; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"一级Leading";
        if (i == 0 || i == 2) {
            model.collapseCol = 2;
        }
        model.collapseRow = 2;
        [leadings1 addObject:model];
    }
    for (NSInteger i = 0; i < rowNum - 4; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"二级Leading";
        [leadings2 addObject:model];
    }
    NSArray *leadings = [NSArray arrayWithObjects:leadings1,leadings2, nil];
    
    WD_QTableModel *sectionModel = [[WD_QTableModel alloc] init];
    sectionModel.title = @"Section";
    
    NSMutableArray<WD_QTableModel *> *headings1 = [NSMutableArray array];
    NSMutableArray<WD_QTableModel *> *headings2 = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum/2 ; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"一级Heading";
        model.collapseCol = 2;
        if (i == 1) {
            model.collapseRow = 2;
        }
        [headings1 addObject:model];
    }
    for (NSInteger i = 0; i < colNum - 2; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"二级Heading";
        [headings2 addObject:model];
    }
    NSArray *headings = [NSArray arrayWithObjects:headings1,headings2, nil];
    
    
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
    [self.table resetMultipleHeadingModel:headings];
    [self.table resetMultipleLeadingModel:leadings];
    [self.table reloadData];
}

@end
