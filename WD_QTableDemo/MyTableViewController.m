//
//  MyTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2017/11/27.
//  Copyright © 2017年 jqlv. All rights reserved.
//

#import "MyTableViewController.h"
#import "BaseTableViewController.h"
#import "ComplexTableViewController.h"
#import "RefreashTableCrossViewController.h"
#import "RefreashTableViewController.h"
#import "CustomStyleTableViewController.h"
#import "CustomLayoutViewController.h"
#import "TipsViewController.h"
#import "AutoComplexTableViewController.h"

@interface MyTableViewController ()

@property(nonatomic,strong) NSArray *lists;

@end

@implementation MyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lists = @[@"基本表格",@"复合表头表格",@"纵向加载更多",@"横向加载更多",@"自定义样式",@"自定义布局",@"自动布局表格：本周计划",@"设计思路和使用小结"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)viewDidAppear:(BOOL)animated{
   
    
}
-(void)doFireTimer{
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.lists[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *controller = nil;
    switch (indexPath.row) {
        case 0:
            controller = [[BaseTableViewController alloc] init];
            controller.navigationItem.title = @"BaseTableViewController";
            break;
        case 1:
            controller = [[ComplexTableViewController alloc] init];
            controller.navigationItem.title = @"ComplexTableViewController";
            break;
        case 2:
            controller = [[RefreashTableCrossViewController alloc] init];
            controller.navigationItem.title = @"RefreashTableCrossViewController";
            break;
        case 3:
            controller = [[RefreashTableViewController alloc] init];
            controller.navigationItem.title = @"RefreashTableViewController";
            break;
        case 4:
            controller = [[CustomStyleTableViewController alloc] init];
            controller.navigationItem.title = @"CustomStyleTableViewController";
            break;
        case 5:
            controller = [[CustomLayoutViewController alloc] init];
            controller.navigationItem.title = @"CustomLayoutViewController";
            break;
        case 6:
            controller = [[AutoComplexTableViewController alloc] init];
            controller.navigationItem.title = @"AutoComplexTableViewController";
            break;
        case 7:
            controller = [[TipsViewController alloc] init];
            controller.navigationItem.title = @"TipsViewController";
            break;
        default:
            controller = [[BaseTableViewController alloc] init];
            controller.navigationItem.title = @"BaseTableViewController";
            break;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:nil  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor blackColor];
    [self showViewController:controller sender:nil];
}
@end
