
//
//  HKYPullUpRefreshView.m
//  Choumeimeifa
//
//  Created by hky on 15/12/5.
//  Copyright © 2015年 ChouMei. All rights reserved.
//

#define kHeight              75.0f

#import "HKYPullUpRefreshView.h"

@interface HKYPullUpRefreshView ()

@property (nonatomic, strong)UIImageView *leftLineImgView;
@property (nonatomic, strong)UIImageView *rightLineImgView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *refreshImgView;

@end

@implementation HKYPullUpRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
        self.hasMore = YES;
    }
    return self;
}

-(void) addSubviews
{
    CGFloat offsetX = 15;
    CGFloat levelWidth = 150;
    CGFloat lineWidth = (SCREEN_WIDTH - levelWidth - offsetX * 2 )/2;
    CGFloat lineOffsetY = 30;
    
    _leftLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, lineOffsetY, lineWidth, 0.5)];
    [_leftLineImgView setBackgroundColor:CMLineColor];
    [self addSubview:_leftLineImgView];
    
    _rightLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX + lineWidth + levelWidth, lineOffsetY, lineWidth, 0.5)];
    [_rightLineImgView setBackgroundColor:CMLineColor];
    [self addSubview:_rightLineImgView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX + lineWidth, 20,levelWidth, 20)];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont systemFontOfSize:12]];
    [_label setTextColor:UIColorFromRGB(0x999999)];
    [_label setText:@"继续拖动,查看服务详情"];
    [self addSubview:_label];
    
    UIImage *img = [UIImage imageNamed:@"dingzhuang_more_down"];
    _refreshImgView = [[UIImageView alloc] initWithImage:img];
    _refreshImgView.frame = CGRectMake(0,50,img.size.width, img.size.height);
    [_refreshImgView setCenter:CGPointMake(SCREEN_WIDTH/2, 50 + img.size.height/2)];
    [_refreshImgView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [self addSubview:_refreshImgView];
}

- (void)setupWithOwner:(UIScrollView *)owner  delegate:(id)delegate
{
    self.owner = owner;
    self.delegate = delegate;
    
    [_owner addSubview:self];
}

- (void)updateOffsetY:(CGFloat)y
{
    CGRect originFrame = self.frame;
    self.frame = CGRectMake(originFrame.origin.x, y, originFrame.size.width, originFrame.size.height);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!isLoading && scrollView.contentOffset.y < 0) {
        return;
    }
    else if (isDragging && [self contentOffsetBottom:scrollView] <= 0 )
    {
        [UIView beginAnimations:nil context:NULL];
        if ([self contentOffsetBottom:scrollView] <= -kHeight)
        {
            [_refreshImgView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        else
        {
            [_refreshImgView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading || !self.hasMore)
    {
        return;
    }
    isDragging = NO;
    [_refreshImgView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    
    // 上拉刷新
    if(scrollView.contentOffset.y > 0 && [self contentOffsetBottom:scrollView] <= -kHeight)
    {
        [self startLoading];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isLoading || !self.hasMore) return;
    
    if(scrollView.contentOffset.y > 0 && [self contentOffsetBottom:scrollView] <= -kHeight)
    {
        [self startLoading];
    }
}

- (void)startLoading
{
    if (isLoading)
    {
        return;
    }
    isLoading = YES;
    
    // Show the footer
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
    // Refresh action!
    if ([self.delegate respondsToSelector:@selector(pullUpRefreshDidFinish)])
    {
        [self.delegate performSelector:@selector(pullUpRefreshDidFinish) withObject:nil];
    }
}

- (void)stopLoading
{
    isLoading = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    
    [_refreshImgView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // Reset the footer
    NSLog(@"%f",self.owner.contentSize.height);
    [self setFrame:CGRectMake(0, self.owner.contentSize.height, self.frame.size.width, 0)];
}

- (float)contentOffsetBottom:(UIScrollView *)scrollView
{
    return scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom);
}

@end
