/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIWebView+ISRefreshControl.h"
#import <objc/runtime.h>

@interface TiUIWebView()
-(UIWebView *)webview;
@end

@implementation TiUIWebView (TiUIWebView_ISRefreshControl)

-(void)setRefreshControl:(ISRefreshControl *)refreshControl
{
    objc_setAssociatedObject(self, @selector(refreshControl), refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ISRefreshControl *)refreshControl
{
    return objc_getAssociatedObject(self, @selector(refreshControl));
}

-(void)setRefreshControlBackgroundView:(UIView *)refreshControlBackgroundView
{
    objc_setAssociatedObject(self, @selector(refreshControlBackgroundView), refreshControlBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)refreshControlBackgroundView
{
    return objc_getAssociatedObject(self, @selector(refreshControlBackgroundView));
}

-(void)initializeState
{
    [super initializeState];
    
    if (self)
    {
        self.refreshControl = (id)[[ISRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                                action:@selector(refreshStart)
                      forControlEvents:UIControlEventValueChanged];
    }
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    if (self.refreshControlBackgroundView != nil)
    {
        self.refreshControlBackgroundView.frame = CGRectMake(0.0f,
                                                             0.0f - bounds.size.height,
                                                             bounds.size.width,
                                                             bounds.size.height);
    }
}

-(void)dealloc
{
    RELEASE_TO_NIL(self.refreshControl);
    RELEASE_TO_NIL(self.refreshControlBackgroundView);
    
    [super dealloc];
}

-(void)setRefreshControlTintColor_:(id)args
{
    TiColor *tintColor = [TiUtils colorValue:args];
    
    if (tintColor == nil)
    {
        self.refreshControl.tintColor = nil;
    }
    else
    {
        self.refreshControl.tintColor = [[tintColor _color] retain];
    }
}

-(void)setRefreshControlBackgroundColor_:(id)args
{
    TiColor *backgroundColor = [TiUtils colorValue:args];
    
    if (backgroundColor == nil)
    {
        if (self.refreshControlBackgroundView != nil)
        {
            [self.refreshControlBackgroundView removeFromSuperview];
            RELEASE_TO_NIL(self.refreshControlBackgroundView);
        }
    }
    else
    {
        CGRect frame = self.frame;
        NSLog(@"frame size width: %f, height: %f", frame.size.width, frame.size.height);
        if (frame.size.width == 0)
        {
            [self performSelector:@selector(setRefreshControlBackgroundColor_:)
                       withObject:args
                       afterDelay:0.1];
            return;
        }
        
        CGRect bounds = self.bounds;
        NSLog(@"bounds size width: %f, height: %f", bounds.size.width, bounds.size.height);
        self.refreshControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                     0.0f - bounds.size.height,
                                                                                     bounds.size.width,
                                                                                     bounds.size.height)];
        self.refreshControlBackgroundView.backgroundColor = [[backgroundColor _color] retain];
        [[self webview].scrollView insertSubview:self.refreshControlBackgroundView
                                    belowSubview:self.refreshControl];
    }
}

-(void)setRefreshControlEnabled_:(id)args
{
    BOOL enabled = [TiUtils boolValue:args def:NO];
    
    if (enabled == YES)
    {
        if ([self.refreshControl isDescendantOfView:[self webview].scrollView] == NO)
        {
            [[self webview].scrollView addSubview:self.refreshControl];
        }
    }
    else
    {
        if ([self.refreshControl isDescendantOfView:[self webview].scrollView] == YES)
        {
            [self.refreshControl removeFromSuperview];
        }
    }
}

-(void)refreshStart
{
    if ([self.refreshControl isDescendantOfView:[self webview].scrollView] == NO)
    {
        return;
    }
    
    [self.refreshControl beginRefreshing];
    
    if ([self.proxy _hasListeners:@"refreshstart"])
    {
        [self.proxy fireEvent:@"refreshstart"];
    }
}

-(void)refreshBegin:(id)args
{
    if ([self.refreshControl isDescendantOfView:[self webview].scrollView] == NO)
    {
        return;
    }
    
    if (self.refreshControl.isRefreshing == NO)
    {
        [self refreshStart];
    }
}

-(void)refreshFinish:(id)args
{
    if ([self.refreshControl isDescendantOfView:[self webview].scrollView] == NO)
    {
        return;
    }
    
    if (self.refreshControl.isRefreshing == YES)
    {
        [self.refreshControl endRefreshing];
        
        if ([self.proxy _hasListeners:@"refreshend"])
        {
            [self.proxy fireEvent:@"refreshend"];
        }
    }
}

-(id)isRefreshing:(id)args
{
    return NUMBOOL(self.refreshControl.isRefreshing);
}

@end
