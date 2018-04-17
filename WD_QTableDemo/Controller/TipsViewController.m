//
//  TipsViewController.m
//  WD_QTableDemo
//
//  Created by jqlv on 2018/2/28.
//  Copyright © 2018年 jqlv. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController

-(UITextView *)tipsLabel{
    UITextView *label =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    label.text = @"WD_QTable作为一个标准的表格控件，一个简单的流程是:\n提供布局构造器和样式构造器->提供数据->刷新控件\n\n1.另外还有一些细节方面需要注意，我们的表格数据是一个二维数组，needTranspostionForModel默认为NO,表示二维数组中存放的是列数据，反之为YES的时候存放的是行数据\n\n2.将WD_QTable设计成UIViewController的子类的目的主要是当UIViewController自带的view变化的时候WD_QTable可以收到通知，以便做出动作，比如横竖屏切换时的重新布局计算\n\n3.使用自定义布局和自定义样式的时候一定要完整的实现WD_QTableDefaultLayoutConstructorDelegate和WD_QTableDefaultStyleConstructorDelegate协议的接口，以免表格出现错误。\n\n4.需要自定义cell样式的时候cell一定要分别的继承WD_QTableBaseReusableView和WD_QTableBaseViewCell，并且一定要使用自定义style构造器，这样才能将自定义的cell的class提供给表格复用。";
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.editable = NO;
    label.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    return label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:[self tipsLabel]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
