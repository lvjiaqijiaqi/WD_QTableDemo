//
//  RefreashTableCrossViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "RefreashTableCrossViewController.h"
#import "WD_QTableHeader.h"
#import "Masonry.h"

@interface RefreashTableCrossViewController ()

@property(nonatomic,strong) WD_QRefreshTable *table;

@end

@implementation RefreashTableCrossViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200.f)];
    label.text = @"WD_QRefreshTable是WD_QTable的扩展，WD_QRefreshTable提供了表格滑到边缘的时候触发block接口，通过block可以进行更多操作，比如加载更多，refreshDirection属性则提供了触发方向（横向or纵向）";
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    label.editable = NO;
    return label;
}

-(WD_QRefreshTable *)table{
    if (!_table) {
        WD_QTableDefaultLayoutConstructor *config =  [[WD_QTableDefaultLayoutConstructor alloc] init];
        config.inset = UIEdgeInsetsMake(200, 0, 0, 0);
        WD_QTableDefaultStyleConstructor *style = [[WD_QTableDefaultStyleConstructor alloc] init];
        _table = [[WD_QRefreshTable alloc] initWithLayoutConfig:config StyleConstructor:style];
        _table.refreshDirection = WD_QRefreshTableDirectionVertical;
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
    __weak typeof(self) weakSelf = self;
    self.table.loadMoreHandle = ^{
        [weakSelf loadMore];
    };
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadMore{
    static NSInteger index = 2;
    NSInteger rowNum = 10;
    NSInteger colNum = 10;
    NSMutableArray<WD_QTableModel *> *leadings = [NSMutableArray array];
    for (NSInteger i = 0; i < rowNum; i++) {
        WD_QTableModel *model = [[WD_QTableModel alloc] init];
        model.title = [NSString stringWithFormat:@"Leading%ld",(long)index];
        [leadings addObject:model];
    }
    NSMutableArray<NSMutableArray<WD_QTableModel *> *> *data = [NSMutableArray array];
    for (NSInteger row = 0; row < rowNum; row++) {
        NSMutableArray *rowArr = [NSMutableArray array];
        for (NSInteger col = 0; col < colNum; col++) {
            WD_QTableModel *model = [[WD_QTableModel alloc] init];
            model.title = [NSString stringWithFormat:@"Item%ld",(long)index];
            [rowArr addObject:model];
        }
        [data addObject:rowArr];
    }
    [self.table insertLeadingModel:leadings];
    [self.table insertItemModel:data];
    [self.table loadMoreData];
    index++;
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
