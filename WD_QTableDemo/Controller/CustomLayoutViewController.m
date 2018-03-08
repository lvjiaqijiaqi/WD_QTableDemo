//
//  CustomLayoutViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "CustomLayoutViewController.h"
#import "WD_QTableHeader.h"
#import "WD_QTableAdaptor.h"
#import "WD_QTableAutoLayoutConstructor.h"
#import "WD_QTableParse.h"

#import "Masonry.h"

@interface CustomLayoutViewController ()

@property(nonatomic,strong) WD_QTable *table;

@end

@implementation CustomLayoutViewController


-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300.f)];
    label.text = @"WD_QTableDefaultLayoutConstructorDelegate协议是WD_QTable自定义布局接口，本demo展示了如何为WD_QTable提供自定义布局，WD_QTableAutoLayoutConstructor是一个实现WD_QTableDefaultLayoutConstructorDelegate协议的布局构造器，实现接口为为WD_QTable提供布局信息。\nautoLayoutHandle是一个实现了WD_QTableAdaptorDelegate协议的WD_QTable内部的对象，当数据源变化重新刷新的时候，WD_QTableAdaptor会收到变化的数据，我们可以提供自定义策略去更具数据重新计算layout属性，然后提交到layout构造器，WD_QTableAdaptor就是这么一个提供策略的对象";
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
        WD_QTableAutoLayoutConstructor *config =  [[WD_QTableAutoLayoutConstructor alloc] init];
        config.inset = UIEdgeInsetsMake(300, 0, 0, 0);
        WD_QTableDefaultStyleConstructor *style = [[WD_QTableDefaultStyleConstructor alloc] init];
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        WD_QTableAdaptor *autoHandle =  [[WD_QTableAdaptor alloc] initWithTableStyle:style ToLayout:config];
        _table.autoLayoutHandle = autoHandle;
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
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
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
    
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"Heading";
        [headings addObject:model];
    }
    
    
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger col = 0; col < colNum; col++) {
        NSMutableArray *colArr = [NSMutableArray array];
        NSString *title = [self randomProductContent];
        for (NSInteger row = 0; row < rowNum; row++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = title;
            [colArr addObject:model];
        }
        [data addObject:colArr];
    }
    [self.table setMain:mainModel];
    [self.table resetItemModel:data];
    [self.table resetHeadingModel:headings];
    [self.table resetLeadingModel:leadings];
    [self.table reloadData];
    
}

-(NSString *)randomProductContent{
    const static NSString *str = @"随机数据";
    int x = arc4random() % 20 + 1;
    NSMutableString *resStr =  [[NSMutableString alloc] init];
    for (; x>0; x--) {
        [resStr appendString:[str copy]];
    }
    return resStr;
}

@end
