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
            break;
        case 1:
            controller = [[ComplexTableViewController alloc] init];
            break;
        case 2:
            controller = [[RefreashTableCrossViewController alloc] init];
            break;
        case 3:
            controller = [[RefreashTableViewController alloc] init];
            break;
        case 4:
            controller = [[CustomStyleTableViewController alloc] init];
            break;
        case 5:
            controller = [[CustomLayoutViewController alloc] init];
            break;
        case 6:
            controller = [[AutoComplexTableViewController alloc] init];
            break;
        case 7:
            controller = [[TipsViewController alloc] init];
            break;
        default:
            controller = [[BaseTableViewController alloc] init];
            break;
    }
    [self showViewController:controller sender:nil];
}
@end
