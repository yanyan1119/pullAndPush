//
//  HKYPullUpRefreshView.h
//  Choumeimeifa
//
//  Created by hky on 15/12/5.
//  Copyright © 2015年 ChouMei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HkyPullUpRefreshViewDelegate <NSObject>

- (void)pullUpRefreshDidFinish;

@end

@interface HKYPullUpRefreshView : UIView
{
    BOOL isDragging;
    BOOL isLoading;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) UIScrollView *owner;

/**
 *  是否还有更多数据需要加载
 */
@property (nonatomic) BOOL hasMore;

- (void)setupWithOwner:(UIScrollView *)owner delegate:(id<HkyPullUpRefreshViewDelegate>)delegate;
- (void)updateOffsetY:(CGFloat)y;

- (void)startLoading;
- (void)stopLoading;

// 拖动过程中
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

