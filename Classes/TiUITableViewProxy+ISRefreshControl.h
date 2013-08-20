/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "TiUITableViewProxy.h"
#import "TiUITableView+ISRefreshControl.h"

@interface TiUITableViewProxy (TiUITableViewProxy_ISRefreshControl)

-(void)refreshBegin:(id)args;
-(void)refreshFinish:(id)args;
-(id)isRefreshing:(id)args;

@end
