//
//  ViewController.m
//  QQButton-Demo
//
//  Created by 张建 on 2017/4/24.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import "ViewController.h"
#import "QQButton.h"

@interface ViewController ()

@property (nonatomic,strong)UIButton * addBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(100, 100, 100, 30);
    _addBtn.backgroundColor = [UIColor redColor];
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.cornerRadius = 30/2.0;
    [_addBtn setTitle:@"creat" forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(creatBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    
    
}

- (void)creatBtn{
    
    //爆炸图片
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 1; i <= 8; i ++) {
        
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [arr addObject:image];
    }
    
    QQButton * btn = [[QQButton alloc] initWithFrame:CGRectMake(200, 200, 30, 30)];
    btn.backgroundColor = [UIColor greenColor];
    //图片数组
    btn.images = arr;
    //角标
    btn.corner = @"10";
    [self.view addSubview:btn];
    //刷新按钮
    [btn refreshButton];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
