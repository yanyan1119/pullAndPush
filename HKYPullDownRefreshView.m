
//
//  HKYPullDownRefreshView.m
//  Choumeimeifa
//
//  Created by hky on 15/12/5.
//  Copyright © 2015年 ChouMei. All rights reserved.
//

#import "HKYPullDownRefreshView.h"

#define REFRESH_PULL_UP_STATUS @"下拉可以回到上面"
#define REFRESH_RELEASED_STATUS @"可以松开了"
// 加载中
#define REFRESH_LOADING_STATUS @""
#define kHeight 65

@interface HKYPullDownRefreshView ()

@property (nonatomic, strong)UIImageView *leftLineImgView;
@property (nonatomic, strong)UIImageView *rightLineImgView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *refreshImgView;

@end

@implementation HKYPullDownRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
    }
    return self;
}

-(void) addSubviews
{
    CGFloat offsetX = 15;
    CGFloat levelWidth = 130;
    CGFloat lineWidth = (SCREEN_WIDTH - levelWidth - offsetX * 2 )/2;
    
    
    UIImage *img = [UIImage imageNamed:@"dingzhuang_more_up"];
    CGFloat lineOffsetY = 15 + img.size.height + 10;
    _refreshImgView = [[UIImageView alloc] initWithImage:img];
    _refreshImgView.frame = CGRectMake(0,0,img.size.width, img.size.height);
    [_refreshImgView setCenter:CGPointMake(SCREEN_WIDTH/2, 10 + img.size.height/2)];
    [_refreshImgView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [self addSubview:_refreshImgView];
    
    _leftLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, lineOffsetY, lineWidth, 0.5)];
    [_leftLineImgView setBackgroundColor:CMLineColor];
    [self addSubview:_leftLineImgView];
    
    _rightLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX + lineWidth + levelWidth, lineOffsetY, lineWidth, 0.5)];
    [_rightLineImgView setBackgroundColor:CMLineColor];
    [self addSubview:_rightLineImgView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(offsetX + lineWidth, 15 + img.size.height,levelWidth, 20)];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_label setFont:[UIFont systemFontOfSize:12]];
    [_label setTextColor:UIColorFromRGB(0x999999)];
    [_label setText:@"松开,查看上文内容"];
    [self addSubview:_label];
}

- (void)setupWithOwner:(UIScrollView *)owner  delegate:(id)delegate
{
    self.owner = owner;
    self.delegate = delegate;
    
    [_owner addSubview:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (isLoading && scrollView.contentOffset.y > 0)
    {
        return;
    }
    
    if (isDragging && scrollView.contentOffset.y <= 0 )
    {
        
        [UIView beginAnimations:nil context:NULL];
        
        if (scrollView.contentOffset.y <= -kHeight)
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    
    // 上拉刷新
    if(scrollView.contentOffset.y <= -kHeight)
    {
        [self startLoading];
    }
}


- (void)startLoading
{
    if (isLoading) {
        return;
    }
    isLoading = YES;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView commitAnimations];
    
    // Refresh action!
    if ([self.delegate respondsToSelector:@selector(pullDownRefreshDidFinish)]) {
        [self.delegate performSelector:@selector(pullDownRefreshDidFinish) withObject:nil];
    }
}

- (void)stopLoading
{
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    
    [UIView commitAnimations];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    [self setFrame:CGRectMake(0, -kHeight, self.frame.size.width, 0)];
}

@end
