//
//  BaseTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "BaseTableViewController.h"
#import "WD_QTableHeader.h"
#import "Masonry.h"

@interface BaseTableViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation BaseTableViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180.f)];
    label.text = @"WD_QTable提供了一个标准的表格,本demo主要展示了一个标准WD_QTable表格的元素。包括\n1.Main\n2.Item\n3.Leading\n4.Heading\n5.Section\n并且支持点击，你可以试一试!";
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.editable = NO;
    label.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return label;
}

-(WD_QTable *)table{
    if (!_table) {
        WD_QTableDefaultLayoutConstructor *config =  [[WD_QTableDefaultLayoutConstructor alloc] init];
        WD_QTableDefaultStyleConstructor *style = [[WD_QTableDefaultStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        config.inset = UIEdgeInsetsMake(200, 0, 0, 0);
        _table.headView = [self tipsLabel];
        _table.needTranspostionForModel = YES;
    }
    return _table;
}


-(void)createAlert:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)insertNew:(id)sender{
    [self.table insertEmptyRowAtRow:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.table.view];
    [self.table.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    __weak typeof(self) weakSelf = self;
    /*self.table.didSelectItemBlock = ^(NSInteger row, NSInteger col, WD_QTableModel *model) {
        NSString *title = [NSString stringWithFormat:@"我是Item%ld行%ld列",row,col];
        [weakSelf createAlert:title];
    };
    self.table.didSelectHeadingBlock = ^(NSIndexPath *indexPath) {
        NSString *title = [NSString stringWithFormat:@"我是%ld列Heading",indexPath.row];
        [weakSelf createAlert:title];
    };
    self.table.didSelectLeadingBlock = ^(NSIndexPath *indexPath) {
        NSString *title = [NSString stringWithFormat:@"我是%ld行Leading",indexPath.row];
        [weakSelf createAlert:title];
    };*/

    [self loadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(insertNew:)];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    
    NSInteger rowNum = 30;
    NSInteger colNum = 10;
    
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
