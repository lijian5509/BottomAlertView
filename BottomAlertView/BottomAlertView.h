//
//  BottomAlertView.h
//  CarWins_Store
//
//  Created by Lone on 16/6/8.
//  Copyright © 2016年 CarWins Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomAlertViewDelegate <NSObject>

/**
 *  子项被选中
 *
 *  @param itemTitle 选中项对应的title
 *  @param itemIndex 选中项对应的位置
 */
- (void)bottomAlertViewItemDidClickedWithTitle:(NSString *)itemTitle
                                         Index:(NSInteger)itemIndex;

@end

@interface BottomAlertView : UIView

/**
 *  初始化方法
 *
 *  @param titlesArray 标题
 *  @param IconsArray  图标
 *
 *  @return return value description
 */
- (instancetype)initWithTitles:(NSArray *)titlesArray
                         icons:(NSArray *)iconsArray
                      delegate:(id<BottomAlertViewDelegate>)delegate;


@property (nonatomic, strong) NSArray *dataArray;                   /**<数据源数组>*/
@property (nonatomic, weak) id<BottomAlertViewDelegate>delegate;    /**< 代理>*/

/**
 *  显示
 */
- (void)show;

/**
 *  消失
 */
- (void)dismiss;

@end
