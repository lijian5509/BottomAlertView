//
//  ZJCustomSheet.h
//  ZJCustomView
//
//  Created by zj on 2016/11/24.
//  Copyright © 2016年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJCustomSheetDelegate <NSObject>

-(void)clickButton:(NSUInteger)buttonTag;

@end

@interface ZJCustomSheet : UIView

@property (nonatomic,weak) id<ZJCustomSheetDelegate>delegate;


-(ZJCustomSheet*)initWithButtons:(NSArray*)allButtons;



@end
