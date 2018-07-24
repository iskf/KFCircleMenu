//
//  KFTestViewController.m
//  KFCircleMenuDemo
//
//  Created by Innoer_kf on 2018/7/24.
//  Copyright © 2018年 innowayskaifeng. All rights reserved.
//

#import "KFTestViewController.h"
#import "XLBubbleTransition.h"

@interface KFTestViewController ()

@end

@implementation KFTestViewController
- (void)dismissAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IMG_1225"]];

    self.view.backgroundColor = color;
    
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    back.backgroundColor = [UIColor clearColor];
    [back addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    //转场动画
    self.xl_presentTranstion = [XLBubbleTransition transitionWithAnchorRect:CGRectMake(360, 10, 44, 44)];
    self.xl_dismissTranstion = [XLBubbleTransition transitionWithAnchorRect:CGRectMake(360, 10, 44, 44)];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
