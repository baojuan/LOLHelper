//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LoadMoreTableFooterView.h"

#define MARGIN 5

#define DEFAULT_ARROW_IMAGE         [UIImage imageNamed:@"blueArrow.png"]


#define DEFAULT_BACKGROUND_COLOR    \
[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
#define DEFAULT_TEXT_COLOR          \
[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define DEFAULT_ACTIVITY_INDICATOR_STYLE    UIActivityIndicatorViewStyleGray

#define FLIP_ANIMATION_DURATION 0.18f


#define PULL_AREA_HEIGTH 60.0f

#define PULL_TRIGGER_HEIGHT (PULL_AREA_HEIGTH + 5.0f)

@interface LoadMoreTableFooterView (Private)
- (void)setState:(EGOPullRefreshState)aState;
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *)scrollView;
- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView;
@end

@implementation LoadMoreTableFooterView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    isLoading = NO;

    CGFloat midY = PULL_AREA_HEIGTH/2;

    /* Config Status Updated Label */
    _statusLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(0.0f, midY - 10, self.frame.size.width, 20.0f)];
    _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _statusLabel.font = [UIFont systemFontOfSize:13];
    _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];

      /* Config Arrow Image */
      _arrowImage = [CALayer layer];
      _arrowImage.frame = CGRectMake(25.0f, midY - 20, 30.0f, 55.0f);
      _arrowImage.contentsGravity = kCAGravityResizeAspect;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
      if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
          _arrowImage.contentsScale = [[UIScreen mainScreen] scale];
      }
#endif
      [[self layer] addSublayer:_arrowImage];
      

      
      
      
    /* Config activity indicator */
    _activityView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
    _activityView.frame = CGRectMake(25.0f,midY - 8, 20.0f, 20.0f);
    [self addSubview:_activityView];

    [self setState:EGOOPullRefreshNormal]; // Also transform the image

    /* Configure the default colors and arrow image */
    [self setBackgroundColor:nil textColor:nil arrowImage:nil];
  }
  return self;
}

#pragma mark - Util
- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *)scrollView {
  CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
  CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
  // If scrolled all the way down this should add upp to the content heigh.
  CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight;
  CGFloat normalizedOffset = scrollAreaContenHeight -scrolledDistance;
  return normalizedOffset;
}

- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *)scrollView {
  return (scrollView.bounds.size.height - MIN(scrollView.bounds.size.height,
                                              scrollView.contentSize.height));
}


#pragma mark -
#pragma mark Setters
- (void)setState:(EGOPullRefreshState)aState {
  switch (aState) {
    case EGOOPullRefreshPulling:
      _statusLabel.text = @"放手即可刷新";
      [CATransaction begin];
      [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
      _arrowImage.transform = CATransform3DIdentity;
          _activityView.hidden = YES;
      [CATransaction commit];

      break;
    case EGOOPullRefreshNormal:
      if (_state == EGOOPullRefreshPulling) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
        _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
      }

      _statusLabel.text = @"上拉加载更多";
      [_activityView stopAnimating];
        _activityView.hidden = YES;
      [CATransaction begin];
      [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
      _arrowImage.hidden = NO;
      _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
      [CATransaction commit];
      break;
    case EGOOPullRefreshLoading:
      _statusLabel.text = @"加载中";
      [_activityView startAnimating];
      [CATransaction begin];
      [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
      _arrowImage.hidden = YES;
          _activityView.hidden = NO;
      [CATransaction commit];
      break;
    default:
      break;
  }
  [self updateActivityViewFrame];
  _state = aState;
}

- (void)updateActivityViewFrame {
  NSDictionary *attribute = @{NSFontAttributeName:_statusLabel.font};
  CGFloat textWidth = [_statusLabel.text sizeWithAttributes:attribute].width;
  CGRect labelFrame = _statusLabel.frame;
  labelFrame.size.width = textWidth;
  labelFrame.origin.x = (self.frame.size.width - labelFrame.size.width)/2;
  _statusLabel.frame = labelFrame;
  CGRect activityFrame = _activityView.frame;
  activityFrame.origin.x = _statusLabel.frame.origin.x - activityFrame.size.width - MARGIN;
  _activityView.frame = activityFrame;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
                 textColor:(UIColor *)textColor
                arrowImage:(UIImage *)arrowImage {
  self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
  _statusLabel.textColor = textColor? textColor: DEFAULT_TEXT_COLOR;
  _statusLabel.shadowColor = [_statusLabel.textColor colorWithAlphaComponent:0.1f];
  _arrowImage.contents = (id)(arrowImage? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);
}

#pragma mark -
#pragma mark ScrollView Methods
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
  if (_state == EGOOPullRefreshLoading) {
    CGFloat offset = MAX(bottomOffset * -1, 0);
    offset = MIN(offset, PULL_AREA_HEIGTH);
    UIEdgeInsets currentInsets = scrollView.contentInset;
    currentInsets.bottom = offset? offset + [self visibleTableHeightDiffWithBoundsHeight:scrollView]:0;
    scrollView.contentInset = currentInsets;
  } else if (scrollView.isDragging) {
    if (_state == EGOOPullRefreshPulling
        && bottomOffset > -PULL_TRIGGER_HEIGHT
        && bottomOffset < 0.0f && !isLoading) {
      [self setState:EGOOPullRefreshNormal];
    } else if (_state == EGOOPullRefreshNormal
               && bottomOffset < -PULL_TRIGGER_HEIGHT
               && !isLoading) {
      [self setState:EGOOPullRefreshPulling];
    }

    if (scrollView.contentInset.bottom != 0) {
      UIEdgeInsets currentInsets = scrollView.contentInset;
      currentInsets.bottom = 0;
      scrollView.contentInset = currentInsets;
    }
  }
}

- (void)startAnimatingWithScrollView:(UIScrollView *)scrollView {
  isLoading = YES;
  [self setState:EGOOPullRefreshLoading];
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.2];
  UIEdgeInsets currentInsets = scrollView.contentInset;
  currentInsets.bottom = PULL_AREA_HEIGTH + [self visibleTableHeightDiffWithBoundsHeight:scrollView];
  scrollView.contentInset = currentInsets;
  [UIView commitAnimations];
  if ([self scrollViewOffsetFromBottom:scrollView] <= 0) {
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,
                                             scrollView.contentOffset.y + PULL_TRIGGER_HEIGHT)
                        animated:YES];
  }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
  if ([self scrollViewOffsetFromBottom:scrollView] <= - PULL_TRIGGER_HEIGHT && !isLoading) {
    if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoadMore:)]) {
      [_delegate loadMoreTableFooterDidTriggerLoadMore:self];
    }
    [self startAnimatingWithScrollView:scrollView];
  }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
  isLoading = NO;
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:.3];
  UIEdgeInsets currentInsets = scrollView.contentInset;
  currentInsets.bottom = 0;
  scrollView.contentInset = currentInsets;
  [UIView commitAnimations];

  [self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
  self.delegate = nil;
}


@end
