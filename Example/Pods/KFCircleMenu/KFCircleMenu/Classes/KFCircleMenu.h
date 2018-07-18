//
//  KFCircleMenu.h
//  KFCircleMenuDemo
//
//  Created by Innoer_kf on 2018/7/17.
//  Copyright © 2018年 kaifeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, KFIconType) {
    
    KFIconTypePlus = 0, // +
    KFIconTypeUserDraw,  // 用户自定义
    KFIconTypeCustomImage, // 图
};

@interface KFCircleMenu : UIControl

/**
 *  中间按钮大小 ; 默认(50,50)
 */
@property (nonatomic, assign) CGSize centerButtonSize;

/**
 *  类型
 */
@property (nonatomic, assign) KFIconType centerIconType;

/**
 *  默认为 nil,  KFIconTypeCustomImage 才有效
 */
@property (nonatomic, strong) UIImage* centerIcon;

/**
 *  主色
 */
@property (nonatomic, strong) UIColor* mainColor;

/**
 *  config function
 *
 *  @param icons        icon 数组
 *  @param innerCircleRadius  内径半径
 */
- (void)loadButtonWithIcons:(NSArray<UIImage*>*)icons innerCircleRadius:(CGFloat)innerCircleRadius;

/**
 *
 */
@property (nonatomic, strong) void (^buttonClickBlock) (NSInteger idx);

/**
 *  KFIconTypeUserDraw, 可在这里自定义
 */
@property (nonatomic, strong) void (^drawCenterButtonIconBlock)(CGRect rect , UIControlState state);


@property (nonatomic, assign) BOOL isOpened;


/**
 * 打开菜单后的偏移量
 */
@property (nonatomic, assign) CGSize offsetAfterOpened;



@end

