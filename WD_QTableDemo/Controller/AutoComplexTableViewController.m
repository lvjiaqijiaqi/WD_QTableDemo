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
#import "WD_QTableParse.h"
#import "Masonry.h"

@interface AutoComplexTableViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation AutoComplexTableViewController

-(WD_QTable *)table{
    if (!_table) {
        WD_QTableAutoLayoutConstructor *config =  [[WD_QTableAutoLayoutConstructor alloc] init];
        //config.inset = UIEdgeInsetsMake(300, 0, 0, 0);
        WD_QTableDefaultStyleConstructor *style = [[WD_QTableDefaultStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        WD_QTableAdaptor *autoHandle =  [[WD_QTableAdaptor alloc] initWithTableStyle:style ToLayout:config];
        _table.autoLayoutHandle = autoHandle;
        //_table.headView = [self tipsLabel];
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
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}

-(void)loadData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *Headings = [WD_QTableParse parseHeadingFromJsonStr:content AtLevel:3];
    NSArray *Leadings = [WD_QTableParse parseLeadingFromJsonStr:content AtLevel:3];
    
    [self.table resetLeadingModels:Leadings DependLevel:3];
    [self.table resetHeadingModels:Headings DependLevel:3];
    [self.table reloadData];
}

@end
