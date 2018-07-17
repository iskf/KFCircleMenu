//
//  KFCircleMenu.m
//  KFCircleMenuDemo
//
//  Created by Innoer_kf on 2018/7/17.
//  Copyright © 2018年 kaifeng. All rights reserved.
//


#import "KFCircleMenu.h"

//弧度转角度
#define RADIANS_TO_ANGLE(radians) ((radians)*(180.0/M_PI))
//角度转弧度
#define ANGLE_TO_RADIANS(angle) ((angle)/180.0*M_PI)

@interface KF_centerButton : UIButton

@property (nonatomic, strong) UIColor* normalColor;
@property (nonatomic, strong) UIColor* selectedColor;
@property (nonatomic, strong) UIImage* centerIcon;
@property (nonatomic, strong) UIImageView* centerIconView;

@property (nonatomic, assign) KFIconType type;
- (instancetype)initWithFrame:(CGRect)frame type:(KFIconType)type;

@end

@interface KF_roundCircle : UIView <UIGestureRecognizerDelegate>

/// 触摸点
@property (nonatomic, assign) CGPoint touchPoint;
/// 记录每个按钮的旋转弧度
@property (nonatomic, strong) NSMutableDictionary *radiansMap;
/// 记录当前滑动手势偏移弧度
@property (nonatomic, assign) float offsetRadians;
/// 内圆半径,中间留白区域圆形的半径,默认`10.0`
@property (nonatomic, assign) CGFloat innerCircleRadius;
/// 当滑动手势结束时是否自动调整按钮位置,默认`YES`
@property (nonatomic, assign, getter=isAutoAdjustPosition) BOOL autoAdjustPosition;


@property (nonatomic, strong) UIColor* circleColor;
@property (nonatomic, strong) NSArray<UIImage *> *icons;

- (void)clean;
- (void)animatedLoadIcons:(NSArray<UIImage*>*)icons innerCircleRadius:(CGFloat)innerCircleRadius;
@end

@interface KFCircleMenu ()
{
    
}

@property (nonatomic, strong) KF_centerButton * centerButton;
@property (nonatomic, strong) KF_roundCircle * roundCircle;

- (void)drawCentenIconInRect:(CGRect)rect state:(UIControlState)state;

@property (nonatomic, assign) CGFloat innerCircleRadius;
@property (nonatomic, strong) NSMutableArray* icons;


@end

@implementation KFCircleMenu

- (UIColor*)add_darkerColorWithValue:(CGFloat)value origin:(UIColor*)origin
{
    size_t totalComponents = CGColorGetNumberOfComponents(origin.CGColor);
    BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
    
    CGFloat const * oldComponents = (CGFloat *)CGColorGetComponents(origin.CGColor);
    CGFloat newComponents[4];
    
    CGFloat (^actionBlock)(CGFloat component) = ^CGFloat(CGFloat component) {
        
        CGFloat newComponent = component * (1.0 - value);
        
        // CGFloat newComponent = component - value < 0.0 ? 0.0 : component - value;
        
        return newComponent;
    };
    
    if (isGreyscale)
    {
        newComponents[0] = actionBlock(oldComponents[0]);
        newComponents[1] = actionBlock(oldComponents[0]);
        newComponents[2] = actionBlock(oldComponents[0]);
        newComponents[3] = oldComponents[1];
    }
    else
    {
        newComponents[0] = actionBlock(oldComponents[0]);
        newComponents[1] = actionBlock(oldComponents[1]);
        newComponents[2] = actionBlock(oldComponents[2]);
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *retColor = [UIColor colorWithCGColor:newColor];
    CGColorRelease(newColor);
    
    return retColor;
}


- (NSMutableArray *)icons
{
    if (!_icons) {
        _icons = [NSMutableArray array];
    }
    return _icons;
}

- (void)loadButtonWithIcons:(NSArray<UIImage *> *)icons innerCircleRadius:(CGFloat)innerCircleRadius
{
    [self.icons removeAllObjects];
    [self.icons addObjectsFromArray:icons];
    
    self.innerCircleRadius = innerCircleRadius;
    
}

- (void)drawCentenIconInRect:(CGRect)rect state:(UIControlState)state
{
    if (self.drawCenterButtonIconBlock) {
        self.drawCenterButtonIconBlock(rect,state);
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self setup];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

- (void)setup{
    self.offsetAfterOpened = CGSizeZero;
    self.mainColor = [UIColor colorWithRed: 0.95 green: 0.2 blue: 0.39 alpha: 1];
    
    self.centerIconType = KFIconTypePlus;
    self.centerButtonSize = CGSizeMake(50, 50);
    [self addSubview:self.roundCircle];
    [self addSubview:self.centerButton];
}


- (void)setMainColor:(UIColor *)mainColor
{
    _mainColor = mainColor;
    self.centerButton.normalColor = mainColor;
    self.centerButton.selectedColor = [self add_darkerColorWithValue:0.2 origin:mainColor];
    self.roundCircle.circleColor = mainColor;
}

- (KF_centerButton *)centerButton
{
    if (!_centerButton) {
        _centerButton = [[KF_centerButton alloc] initWithFrame:CGRectMake(0, 0, self.centerButtonSize.width, self.centerButtonSize.height) type:self.centerIconType];
        [_centerButton addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}


- (KF_roundCircle *)roundCircle
{
    if (!_roundCircle) {
        _roundCircle = [[KF_roundCircle alloc] initWithFrame:CGRectZero];
        _roundCircle.tintColor = self.tintColor;
    }
    return _roundCircle;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    
    [self.roundCircle setTintColor:tintColor];
}

- (void)centerButtonClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (void)setCenterButtonSize:(CGSize)centerButtonSize
{
    _centerButtonSize = centerButtonSize;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.centerButton.bounds = CGRectMake(0, 0, self.centerButtonSize.width, self.centerButtonSize.height);
    
    self.centerButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    if (self.selected) {
        
        self.roundCircle.frame = self.bounds;
    }
    else
    {
        self.roundCircle.frame = self.centerButton.frame;
    }
    
    [self.roundCircle setNeedsDisplay];
    
}

- (void)setCenterIcon:(UIImage *)centerIcon
{
    [self.centerButton setCenterIcon:centerIcon];
    [self.centerButton setNeedsDisplay];
}

- (UIImage *)centerIcon
{
    return [self.centerButton centerIcon];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (!selected) {
        [self.roundCircle clean];
    }
    
    self.isOpened = selected;
    [UIView animateWithDuration:0.24
                          delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         if (selected) {
                             self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(self.offsetAfterOpened.width, self.offsetAfterOpened.height));
                             self.roundCircle.frame = self.bounds;
                         }
                         else
                         {
                             self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-self.offsetAfterOpened.width, -self.offsetAfterOpened.height));
                             self.roundCircle.frame = self.centerButton.frame;
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         
                         [self.roundCircle setNeedsDisplay];
                         
                         if (selected) {
                             [self.roundCircle animatedLoadIcons:self.icons innerCircleRadius:self.innerCircleRadius];
                         }
                         
                     }];
}

- (void)setCenterIconType:(KFIconType)centerIconType
{
    _centerIconType = centerIconType;
    
    [self.centerButton setType:centerIconType];
}

- (void)buttonClick:(id)sender
{
    self.centerButton.selected = NO;
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock([sender tag] - 9998);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view = [super hitTest:point withEvent:event];
    
    if (self.isOpened) {
        
        return view;
    }
    
    if (CGRectContainsPoint(self.centerButton.frame, point)) {
        return self.centerButton;
    }
    return nil;
}

@end



@implementation KF_centerButton

- (UIImageView *)centerIconView
{
    if (!_centerIconView) {
        _centerIconView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_centerIconView];
        _centerIconView.alpha = 0;
        _centerIconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _centerIconView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(KFIconType)type
{
    self = [self initWithFrame:frame];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)setType:(KFIconType)type
{
    _type = type;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    
    UIColor* color = self.normalColor;
    if (self.highlighted || self.selected) {
        color = self.selectedColor;
    }
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [color setFill];
    [ovalPath fill];
    self.centerIconView.alpha = 0;
    
    if (self.type == KFIconTypePlus || self.state == UIControlStateSelected) {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(15, rect.size.height/2 - 0.5, rect.size.width - 30, 1)];
        [UIColor.whiteColor setFill];
        [rectanglePath fill];
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(rect.size.width/2 - 0.5, 15, 1, rect.size.height - 30)];
        [UIColor.whiteColor setFill];
        [rectangle2Path fill];
    }
    else if (self.type == KFIconTypeUserDraw)
    {
        if ([self.superview respondsToSelector:@selector(drawCentenIconInRect:state:)]) {
            [(id)self.superview drawCentenIconInRect:rect state:self.state];
        }
    }
    else if (self.type == KFIconTypeCustomImage){
        
        if (self.centerIcon) {
            [self.centerIconView setImage:self.centerIcon];
            self.centerIconView.alpha = 1;
        }
        
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self setNeedsDisplay];
    
    [UIView animateWithDuration:0.24
                          delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformMakeRotation(selected?M_PI_2/2:0);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    if ([self.superview respondsToSelector:@selector(setSelected:)]) {
        [(id)self.superview setSelected:selected];
    }
}

@end

@implementation KF_roundCircle

- (void)clean
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)buttonClick:(id)sender
{
    if ([self.superview respondsToSelector:@selector(buttonClick:)]) {
        [(id)self.superview buttonClick:sender];
    }
}

- (void)animatedLoadIcons:(NSArray<UIImage*>*)icons innerCircleRadius:(CGFloat)innerCircleRadius
{
    
    [self clean];
    
    self.icons = icons;
    self.innerCircleRadius = innerCircleRadius;
    
    [_radiansMap removeAllObjects];
    [icons enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setImage:obj forState:UIControlStateNormal];
        button.tintColor = self.tintColor;
        button.alpha = 1;
        button.tag = idx + 9998;
        button.center = self.center;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        NSString *key = [NSString stringWithFormat:@"radians%ld",idx];
        double radians = (M_PI*2/icons.count)*idx-M_PI_2;
        [self->_radiansMap setObject:@(radians) forKey:key];
    }];
    
    [self adjustMenuButtonPositionWithOffsetRadians:0.0 isAnimation:YES];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _radiansMap = [NSMutableDictionary dictionary];
        _autoAdjustPosition = YES;
        
        SEL sel = @selector(panGestureRecognizerAction:);
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:sel];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _touchPoint = [sender locationInView:self];
            _offsetRadians = 0.0;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [sender locationInView:self];
            double angleBegin = [self angleWithPoint:_touchPoint];
            double angleAfter = [self angleWithPoint:point];
            NSInteger index = [self quadrantWithPoint:point];
            double radians;
            if (1==index || 4==index) {
                radians = ANGLE_TO_RADIANS(angleAfter-angleBegin);
            } else {
                radians = ANGLE_TO_RADIANS(angleBegin-angleAfter);
            }
            [self adjustMenuButtonPositionWithOffsetRadians:radians isAnimation:YES];
            _touchPoint = point;
            _offsetRadians += radians;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (_autoAdjustPosition) { // 需要自动调整按钮位置
                double perRadians = M_PI*2/_icons.count;
                double radians = 0.0;
                double offsetRadians = fmod(_offsetRadians, perRadians);
                if (offsetRadians < 0.0) { // 逆时针方向旋转
                    if (offsetRadians >= -perRadians*0.5) {
                        radians = -offsetRadians;
                    } else {
                        radians = (perRadians+offsetRadians)*-1;
                    }
                } else { // 顺时针方向旋转
                    if (offsetRadians >= perRadians*0.5) {
                        radians = perRadians - offsetRadians;
                    } else {
                        radians = -offsetRadians;
                    }
                }
                [self adjustMenuButtonPositionWithOffsetRadians:radians isAnimation:YES];
            }
            _offsetRadians = 0.0;
        }
            break;
        default:
            break;
    }
}

/// 根据坐标点获取旋转角度值
- (double)angleWithPoint:(CGPoint)point {
    CGFloat radius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))*0.5;
    CGFloat x = point.x - radius;
    CGFloat y = point.y - radius;
    return asin(y/hypot(x, y))*180/M_PI;
}

/// 检测坐标点处于第几象限
- (NSInteger)quadrantWithPoint:(CGPoint)point {
    CGFloat radius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))*0.5;
    CGFloat tmpX = point.x - radius;
    CGFloat tmpY = point.y - radius;
    if (tmpX >= 0) {
        return tmpY>=0 ? 4: 1;
    }
    return tmpY>=0 ? 3 : 2;
}

/// 根据偏移弧度值调整按钮位置
- (void)adjustMenuButtonPositionWithOffsetRadians:(double)radians isAnimation:(BOOL)isAnimation {
    CGFloat containerRaduis = CGRectGetWidth(self.frame)/2;
    NSInteger count = self.subviews.count;
    double tmp = _innerCircleRadius+(containerRaduis-_innerCircleRadius)/2;
    CGFloat buttonWidth = (containerRaduis-_innerCircleRadius)/sqrt(2);
    for (NSInteger i=0; i<count; i++) {
        NSString *key = [NSString stringWithFormat:@"radians%ld",i];
        double startRadians = [_radiansMap[key] doubleValue]+radians;
        [_radiansMap setObject:@(startRadians) forKey:key];
        CGFloat centerX = containerRaduis+tmp*cos(startRadians);
        CGFloat centerY = containerRaduis+tmp*sin(startRadians);
        UIView *view = self.subviews[i];
        view.bounds = CGRectMake(0.0, 0.0, buttonWidth, buttonWidth);
        if (isAnimation) {
            [UIView animateWithDuration:0.25 animations:^{
                view.center = CGPointMake(centerX, centerY);
            }];
        } else {
            view.center = CGPointMake(centerX, centerY);
        }
        
        NSLog(@"i:%ld,x:%.2f,y:%.2f",i,centerX,centerY);
        
    }
}


- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* color = self.circleColor;
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: rect];
    [color setFill];
    [ovalPath fill];
}



@end
