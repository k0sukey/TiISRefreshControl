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
        [[self tableView] addSubview:refreshControl];
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

-(void)refreshStart
{
    [refreshControl beginRefreshing];
    
    if ([self.proxy _hasListeners:@"refreshstart"])
    {
        [self.proxy fireEvent:@"refreshstart"];
    }
}

-(void)refreshFinish:(id)args
{
    [refreshControl endRefreshing];
}

@end
