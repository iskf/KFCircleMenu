# KFCircleMenu

[![CI Status](https://img.shields.io/travis/innowayskaifeng/KFCircleMenu.svg?style=flat)](https://travis-ci.org/innowayskaifeng/KFCircleMenu)
[![Version](https://img.shields.io/cocoapods/v/KFCircleMenu.svg?style=flat)](https://cocoapods.org/pods/KFCircleMenu)
[![License](https://img.shields.io/cocoapods/l/KFCircleMenu.svg?style=flat)](https://cocoapods.org/pods/KFCircleMenu)
[![Platform](https://img.shields.io/cocoapods/p/KFCircleMenu.svg?style=flat)](https://cocoapods.org/pods/KFCircleMenu)

![status](https://github.com/theKF/KFCircleMenu/blob/master/KFCircleMenu_gif.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

```
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
```


## Requirements

- Xcode 8
- iOS 8.0

## Installation

KFCircleMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KFCircleMenu'
```

## Author

* [Kaifeng Wu](24272779@qq.com)

## License

KFCircleMenu is available under the MIT license. See the LICENSE file for more info.
