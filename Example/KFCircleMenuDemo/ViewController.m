//
//  ViewController.m
//  KFCircleMenuDemo
//
//  Created by Innoer_kf on 2018/7/17.
//  Copyright © 2018年 innowayskaifeng. All rights reserved.
//

#import <KFCircleMenu/KFCircleMenu.h>

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     menu 1
     */
    
    self.circleMenu1.centerButtonSize = CGSizeMake(44, 44);
    self.circleMenu1.centerIconType = KFIconTypePlus;
    self.circleMenu1.tintColor = [UIColor whiteColor];
    
    [self.circleMenu1 setDrawCenterButtonIconBlock:^(CGRect rect, UIControlState state) {
        
        if (state == UIControlStateNormal)
        {
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2 - 5, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectanglePath fill];
            
            UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectangle2Path fill];
            
            UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake((rect.size.width - 15)/2, rect.size.height/2 + 5, 15, 1)];
            [UIColor.whiteColor setFill];
            [rectangle3Path fill];
        }
    }];
    
    [self.circleMenu1 loadButtonWithIcons:@[
                                            [UIImage imageNamed:@"icon_can"],
                                            [UIImage imageNamed:@"icon_pos"],
                                            [UIImage imageNamed:@"icon_img"],
                                            [UIImage imageNamed:@"icon_can"],
                                            [UIImage imageNamed:@"icon_pos"],
                                            [UIImage imageNamed:@"icon_img"],
                                            [UIImage imageNamed:@"icon_pos"],
                                            ] innerCircleRadius:30];
    
    [self.circleMenu1 setButtonClickBlock:^(NSInteger idx) {
        
        NSLog(@"button %@ clicked !",@(idx));
    }];
    
    
    /*
     menu 2
     */
    self.circleMenu2.centerButtonSize = CGSizeMake(44, 44);
    [self.circleMenu2 loadButtonWithIcons:@[
                                            [UIImage imageNamed:@"icon_can"],
                                            [UIImage imageNamed:@"icon_pos"],
                                            [UIImage imageNamed:@"icon_img"],
                                            [UIImage imageNamed:@"icon_can"],
                                            [UIImage imageNamed:@"icon_pos"],
                                            [UIImage imageNamed:@"icon_img"],
                                            [UIImage imageNamed:@"icon_pos"]
                                            ]
                        innerCircleRadius:30];
    [self.circleMenu2 setButtonClickBlock:^(NSInteger idx) {
        
        NSLog(@"button %@ clicked !",@(idx));
    }];
    
    [self.circleMenu2 setCenterIcon:[UIImage imageNamed:@"icon_pos"]];
    [self.circleMenu2 setCenterIconType:KFIconTypeCustomImage];
    
    self.circleMenu2.tintColor = [UIColor whiteColor];
    self.circleMenu2.mainColor = [UIColor colorWithRed:0.13 green:0.58 blue:0.95 alpha:1];
    
    //self.circleMenu2.offsetAfterOpened = CGSizeMake(-80, -80);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
