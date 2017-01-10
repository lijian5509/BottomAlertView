//
//  ZJCustomSheet.m
//  ZJCustomView
//
//  Created by zj on 2016/11/24.
//  Copyright © 2016年 zj. All rights reserved.
//

#import "ZJCustomSheet.h"
@interface ZJCustomSheet()

@property (nonatomic,strong) UIView * contentView;

@end
@implementation ZJCustomSheet

static NSArray * allbus = nil;

-(ZJCustomSheet*)initWithButtons:(NSArray*)allButtons
{
    allbus = allButtons;
    ZJCustomSheet * sheet = [[ZJCustomSheet alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [sheet set];
    return sheet;
}

-(void)set
{
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44*allbus.count, [UIScreen mainScreen].bounds.size.width, 44*allbus.count);
    }];

}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        back.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        [self addSubview:back];
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width,44*allbus.count)];
        [self addSubview:_contentView];
        for (int i = 0; i<allbus.count; i++)
        {
            UIButton * bu = [UIButton buttonWithType:UIButtonTypeCustom];
            bu.tag = i;
            bu.backgroundColor = [UIColor whiteColor];
            bu.frame = CGRectMake(0, 44*i, [UIScreen mainScreen].bounds.size.width, 44);
            [_contentView addSubview:bu];
            [bu setTitle:allbus[i] forState:UIControlStateNormal];
            [bu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bu addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 43, [UIScreen mainScreen].bounds.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
            [bu addSubview:line];
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
-(void)clickButton:(UIButton*)button
{
    [self.delegate  clickButton:button.tag];
    
    [self removeFromSuperview];
}


@end
