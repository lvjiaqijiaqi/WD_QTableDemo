//
//  CustomStyleTableViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "CustomStyleTableViewController.h"
#import "WD_QTableHeader.h"
#import "CustomStyleConstructor.h"
#import "CustomStyleConstructor2.h"
#import "Masonry.h"

@interface CustomStyleTableViewController ()

@property(nonatomic,strong) WD_QTable *table;

@property(nonatomic,strong) id<WD_QTableDefaultStyleConstructorDelegate> style1;
@property(nonatomic,strong) id<WD_QTableDefaultStyleConstructorDelegate> style2;

@end

@implementation CustomStyleTableViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 10, 200.f)];
    label.text = @"WD_QTableDefaultStyleConstructorDelegate协议为WD_QTable提供样式逻辑，将该逻辑分离出来以方便单独配置，\n本demo展示了怎么去配置表格的样式。右上角的切换按钮可以让表格随意的切换不同的样式，而你只需要切换不同的实现WD_QTableDefaultStyleConstructorDelegate协议的对象即可，这也是将该逻辑抽离出来的原因之一。";
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
        self.style1 = [[CustomStyleConstructor alloc] init];
        self.style2 = [[CustomStyleConstructor2 alloc] init];
        WD_QTableDefaultLayoutConstructor *config =  [[WD_QTableDefaultLayoutConstructor alloc] init];
        config.inset = UIEdgeInsetsMake(200, 0, 0, 0);
        _table = [[WD_QTable alloc] initWithLayoutConfig:config StyleConstructor:self.style1];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"style转换" style:UIBarButtonItemStylePlain target:self action:@selector(changeStyle)];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    
    NSInteger rowNum = 30;
    NSInteger colNum = 10;
    
    WD_QTableModel *mainModel = [[WD_QTableModel alloc] init];
    mainModel.title = @"我是main";
    
    NSMutableArray<WD_QTableModel *> *leadings = [NSMutableArray array];
    for (NSInteger i = 0; i < rowNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"我是Leading";
        [leadings addObject:model];
    }
    
    NSMutableArray<WD_QTableModel *> *headings = [NSMutableArray array];
    for (NSInteger i = 0; i < colNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = @"我是Heading";
        [headings addObject:model];
    }
    
    
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger row = 0; row < rowNum; row++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger col = 0; col < colNum; col++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = @"我是Item";
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

-(void)changeStyle{
    static NSInteger tmp = 0;
    if (tmp == 0) {
        [self.table changeStyleConstructor:self.style2 LayoutConstructor:nil];
        tmp = 1;
    }else{
        [self.table changeStyleConstructor:self.style1 LayoutConstructor:nil];
        tmp = 0;
    }
}


@end
