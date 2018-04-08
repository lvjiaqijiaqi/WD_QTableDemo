//
//  AutoComplexTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/3/8.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "AutoComplexTableViewController.h"
#import "WD_QTableHeader.h"
#import "WD_QTableAdaptor.h"
#import "WD_QTableAutoLayoutConstructor.h"
#import "WeakPlanTableStyleConstructor.h"
#import "WD_QTableParse.h"
#import "WD_QTableBaseColAdaptor.h"

#import "Masonry.h"

@interface AutoComplexTableViewController ()

@property(nonatomic,strong) WD_QTable *table;
@property(nonatomic,strong) WD_QTableAutoLayoutConstructor *config;

@end

@implementation AutoComplexTableViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.f)];
    label.text = @"本周计划";
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor colorWithRed:235.0/256 green:235.0/256 blue:255.0/256 alpha:1];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    label.editable = NO;
    return label;
}
-(WD_QTable *)table{
    if (!_table) {
        WD_QTableAutoLayoutConstructor *config =  [[WD_QTableAutoLayoutConstructor alloc] init];
        config.inset = UIEdgeInsetsMake(50, 0, 0, 0);
        WeakPlanTableStyleConstructor *style = [[WeakPlanTableStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        WD_QTableBaseColAdaptor *autoHandle =  [[WD_QTableBaseColAdaptor alloc] initWithTableStyle:style ToLayout:config];
        _config = config;
        autoHandle.defaultRowH = 50.f;
        _table.autoLayoutHandle = autoHandle;
        _table.headView = [self tipsLabel];
        __weak typeof(self) weakSelf = self;
        _table.didSelectItemBlock = ^(NSInteger row, NSInteger col, WD_QTableModel *model) {
            weakSelf.config.RowsH[2] = [NSNumber numberWithFloat:100];
            [weakSelf.table reloadData];
        };
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"解析" style:0 target:self action:@selector(paresOut)];
    // Do any additional setup after loading the view.
}

-(void)paresOut{
    [WD_QTableParse parseOut:self.table];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

-(void)loadData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"coursePlan" ofType:@"json"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [WD_QTableParse parseIn:self.table ByJsonStr:content];
    [self.table reloadData];
}

@end
