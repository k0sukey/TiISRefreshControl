/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUITableView+ISRefreshControl.h"
#import <objc/runtime.h>

@implementation TiUITableView (TiUITableView_ISRefreshControl)

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
    [super dealloc];
}

-(void)setRefreshControlTintColor_:(id)args
{
    TiColor *val = [TiUtils colorValue:args];
    
    if (val != nil)
    {
        self.refreshControl.tintColor = [[val _color] retain];
    }
}

-(void)setRefreshControlEnabled_:(id)args
{
    BOOL val = [TiUtils boolValue:args def:YES];
    
    if (val == YES)
    {
        if ([self.refreshControl isDescendantOfView:[self tableView]] == NO)
        {
            [[self tableView] addSubview:self.refreshControl];
        }
    }
    else
    {
        if ([self.refreshControl isDescendantOfView:[self tableView]] == YES)
        {
            [self.refreshControl removeFromSuperview];
        }
    }
}

-(void)refreshStart
{
    if ([self.refreshControl isDescendantOfView:[self tableView]] == NO)
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
    if ([self.refreshControl isDescendantOfView:[self tableView]] == NO)
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
    if ([self.refreshControl isDescendantOfView:[self tableView]] == NO)
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
