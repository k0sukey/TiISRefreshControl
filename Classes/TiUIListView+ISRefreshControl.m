/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIListView+ISRefreshControl.h"

@implementation TiUIListView (TiUIListView_ISRefreshControl)

ISRefreshControl *refreshControl;

-(void)initializeState
{
    [super initializeState];
    
    if (self)
    {
        refreshControl = (id)[[ISRefreshControl alloc] init];
        [refreshControl addTarget:self
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
        refreshControl.tintColor = [[val _color] retain];
    }
}

-(void)setRefreshControlEnabled_:(id)args
{
    BOOL val = [TiUtils boolValue:args def:YES];
    
    if (val == YES)
    {
        if ([refreshControl isDescendantOfView:[self tableView]] == NO)
        {
            [[self tableView] addSubview:refreshControl];
        }
    }
    else
    {
        if ([refreshControl isDescendantOfView:[self tableView]] == YES)
        {
            [refreshControl removeFromSuperview];
        }
    }
}

-(void)refreshStart
{
    if ([refreshControl isDescendantOfView:[self tableView]] == NO)
    {
        return;
    }
    
    [refreshControl beginRefreshing];
    
    if ([self.proxy _hasListeners:@"refreshstart"])
    {
        [self.proxy fireEvent:@"refreshstart"];
    }
}

-(void)refreshBegin:(id)args
{
    if ([refreshControl isDescendantOfView:[self tableView]] == NO)
    {
        return;
    }
    
    if (refreshControl.isRefreshing == NO)
    {
        [self refreshStart];        
    }
}

-(void)refreshFinish:(id)args
{
    if ([refreshControl isDescendantOfView:[self tableView]] == NO)
    {
        return;
    }
    
    if (refreshControl.isRefreshing == YES)
    {
        [refreshControl endRefreshing];
        
        if ([self.proxy _hasListeners:@"refreshend"])
        {
            [self.proxy fireEvent:@"refreshend"];
        }
    }
}

-(id)isRefreshing:(id)args
{
    return NUMBOOL(refreshControl.isRefreshing);
}

@end
