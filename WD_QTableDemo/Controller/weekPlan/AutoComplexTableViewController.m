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
#import "Masonry.h"

@interface AutoComplexTableViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation AutoComplexTableViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.f)];
    label.text = @"本周计划";
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor whiteColor];
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
        WD_QTableAdaptor *autoHandle =  [[WD_QTableAdaptor alloc] initWithTableStyle:style ToLayout:config];
        autoHandle.defaultRowH = 50.f;
        _table.autoLayoutHandle = autoHandle;
        _table.headView = [self tipsLabel];
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
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

-(void)loadData{
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"weakPlanLeadingData" ofType:@"json"];
    NSString *content1 = [[NSString alloc] initWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
    NSArray *Leadings = [WD_QTableParse parseLeadingFromJsonStr:content1 AtLevel:2];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"weakPlanData" ofType:@"json"];
    NSString *content2 = [[NSString alloc] initWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    
    [self.table resetItemModel:[WD_QTableParse parseDataFromJsonStr:content2]];
    [self.table resetLeadingModels:Leadings DependLevel:2];
    [self.table resetHeadingModelWithArr:@[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"]];
    [self.table reloadData];
}

@end