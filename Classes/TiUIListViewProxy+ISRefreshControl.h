/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "TiUIListViewProxy.h"

@interface TiUIListViewProxy (TiUIListViewProxy_ISRefreshControl)

-(void)refreshBegin:(id)args;
-(void)refreshFinish:(id)args;

@end
