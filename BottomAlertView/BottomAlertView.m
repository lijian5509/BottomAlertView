//
//  BottomAlertView.m
//  CarWins_Store
//
//  Created by Lone on 16/6/8.
//  Copyright © 2016年 CarWins Inc. All rights reserved.
//

#import "BottomAlertView.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ItemHeight  (ScreenWidth - 5*20)/4.0

static CGFloat const titleViewHeight = 30.0;

@interface BottomAlertView ()<UIScrollViewDelegate>

{
    NSArray         *_titlesArray;          /**<名称> */
    NSArray         *_iconsArray;           /**<图标> */
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BottomAlertView

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 10, ScreenWidth, 10)];
        _pageControl.numberOfPages = (_titlesArray.count-1)/8 + 1;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        CGFloat scrollH = _titlesArray.count <= 4? ItemHeight + 20 + titleViewHeight : (ItemHeight + titleViewHeight)*2 + 30;
        _scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - scrollH, ScreenWidth, scrollH)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(((_titlesArray.count-1)/8 + 1) * ScreenWidth, scrollH);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:240/255.0 alpha:0.9];
    }
    return _scrollView;
}

- (void)setDataArray:(NSArray *)dataArray
{
    if (dataArray.count > 0) {
        _dataArray = dataArray;
        _titlesArray = dataArray;
        _iconsArray = dataArray;
        [self layoutContentView];
    }
}

#pragma mark - 初始化方法
- (instancetype)initWithTitles:(NSArray *)titlesArray
                         icons:(NSArray *)iconsArray
                      delegate:(id<BottomAlertViewDelegate>)delegate
{
    if (self = [super init]) {
        if (titlesArray.count > 0 && titlesArray.count == iconsArray.count) {
            _titlesArray = titlesArray;
            _iconsArray  = iconsArray;
            [self layoutContentView];
        }else{
            NSAssert(false, @"titlesArray.count != iconsArray.count");
        }
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)]) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismiss];
}

#pragma mark - 添加子视图
- (void)layoutContentView
{
    [self.scrollView removeFromSuperview];
    [self.pageControl removeFromSuperview];
    self.scrollView = nil;
    self.pageControl = nil;
    for (int i = 0; i < [_titlesArray count]; i ++) {
        CGFloat baseX = i/8 * ScreenWidth + 20;
        
        CGFloat itemX = baseX + i%4 * (ItemHeight + 20);
        CGFloat itemY = 10.0 + (i%8)/4 * (ItemHeight + titleViewHeight + 10);
        UIButton *btn = [self buttonWithIcon:_iconsArray[i]
                                       frame:CGRectMake(itemX, itemY, ItemHeight, ItemHeight)
                                         tag:100 + i];
        UILabel *label = [self labelWithTitle:_titlesArray[i]
                                        frame:CGRectMake(itemX, itemY + ItemHeight, ItemHeight, titleViewHeight)];
        label.numberOfLines = 0;
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:btn];
    }
    [self addSubview:self.scrollView];
    if (self.pageControl.numberOfPages > 1) {
        [self addSubview:self.pageControl];
    }
}

#pragma mark - button 初始化
- (UIButton *)buttonWithIcon:(NSString *)icon
                       frame:(CGRect)frame
                         tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:KImage_Bottom(icon)
                      forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(btnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - 标题初始化
- (UILabel *)labelWithTitle:(NSString *)title
                      frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    return label;
}

#pragma mark - 滚动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / ScreenWidth;
}

#pragma mark - 按钮触发事件
- (void)btnClicked:(UIButton *)sender
{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomAlertViewItemDidClickedWithTitle:Index:)]) {
        [self.delegate bottomAlertViewItemDidClickedWithTitle:_titlesArray[sender.tag - 100] Index:sender.tag - 100];
    }
}

#pragma mark - 显示
- (void)show{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.layer setOpacity:1];
        [kWindow addSubview:self];
        self.center = kWindow.center;
    } completion:nil];
}

#pragma mark - 消失
- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        [self.layer setOpacity:1];
        CGRect rect = self.frame;
        rect.origin.y = ScreenHeight;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
