/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIWebView+ISRefreshControl.h"
#import <objc/runtime.h>

@implementation TiUIWebView (TiUIWebView_ISRefreshControl)

-(void)setRefreshControl:(ISRefreshControl *)refreshControl
{
    objc_setAssociatedObject(self, @selector(refreshControl), refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(ISRefreshControl *)refreshControl
{
    return objc_getAssociatedObject(self, @selector(refreshControl));
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

-(void)dealloc
{
    RELEASE_TO_NIL(self.refreshControl);
    
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

-(void)setRefreshControlEnabled_:(id)args
{
    BOOL enabled = [TiUtils boolValue:args def:NO];
    
    if (enabled == YES)
    {
        if ([self.refreshControl isDescendantOfView:[self scrollview]] == NO)
        {
            [[self scrollview] addSubview:self.refreshControl];
        }
    }
    else
    {
        if ([self.refreshControl isDescendantOfView:[self scrollview]] == YES)
        {
            [self.refreshControl removeFromSuperview];
        }
    }
}

-(void)refreshStart
{
    if ([self.refreshControl isDescendantOfView:[self scrollview]] == NO)
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
    if ([self.refreshControl isDescendantOfView:[self scrollview]] == NO)
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
    if ([self.refreshControl isDescendantOfView:[self scrollview]] == NO)
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
