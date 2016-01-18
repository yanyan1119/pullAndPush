//
//  HKYPullDownRefreshView.h
//  Choumeimeifa
//
//  Created by hky on 15/12/5.
//  Copyright © 2015年 ChouMei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HkyPullDownRefreshViewDelegate <NSObject>

- (void)pullDownRefreshDidFinish;

@end

@interface HKYPullDownRefreshView : UIView
{
    BOOL isDragging;
    BOOL isLoading;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) UIScrollView *owner;

- (void)setupWithOwner:(UIScrollView *)owner delegate:(id<HkyPullDownRefreshViewDelegate>)delegate;

- (void)startLoading;
- (void)stopLoading;

// 拖动过程中
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end



