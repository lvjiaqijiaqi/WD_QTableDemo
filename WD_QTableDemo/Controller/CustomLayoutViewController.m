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
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 10, 300.f)];
    //label.text = @"WD_QTableDefaultLayoutConstructorDelegate协议为WD_QTable提供自定义布局，本demo展示了如何为WD_QTable提供自定义布局，WD_QTableAutoLayoutConstructor是一个实现WD_QTableDefaultLayoutConstructorDelegate协议的布局构造器，为WD_QTable提供布局接口，当然你可以随意的自定义自己的布局构造器。\nautoLayoutHandle是一个实现了WD_QTableAdaptorDelegate协议的WD_QTable内部的对象，当数据源变化重新刷新的时候，WD_QTableAdaptor会收到变化的数据，我们可以提供自定义策略去更具数据重新计算layout属性，然后提交到layout构造器，WD_QTableAdaptor就是这么一个提供策略的对象";
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
            model.title = [self randomProductContent];
            [rowArr addObject:model];
        }
        [data addObject:rowArr];
    }
    [self.table setMain:mainModel];
    [self.table resetItemModel:data];
    [self.table resetHeadingModel:headings];
    [self.table resetLeadingModel:leadings];
    [self.table reloadData];
    
    return;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *Headings = [WD_QTableParse parseHeadingFromJsonStr:content AtLevel:3];
    NSArray *Leadings = [WD_QTableParse parseLeadingFromJsonStr:content AtLevel:3];

    [self.table resetLeadingModels:Leadings DependLevel:3];
    [self.table resetHeadingModels:Headings DependLevel:3];
    [self.table reloadData];
}

-(NSString *)randomProductContent{
    const static NSString *str = @"随机产生数据";
    int x = arc4random() % 10 + 1;
    NSMutableString *resStr =  [[NSMutableString alloc] init];
    for (; x>0; x--) {
        [resStr appendString:[str copy]];
    }
    return resStr;
}

@end
