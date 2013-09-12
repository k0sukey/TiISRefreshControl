/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIScrollViewProxy+ISRefreshControl.h"

@implementation TiUIScrollViewProxy (TiUIScrollViewProxy_ISRefreshControl)

#ifndef USE_VIEW_FOR_UI_METHOD
#define USE_VIEW_FOR_UI_METHOD(methodname)\
-(void)methodname:(id)args\
{\
[self makeViewPerformSelector:@selector(methodname:) withObject:args createIfNeeded:YES waitUntilDone:NO];\
}
#endif

USE_VIEW_FOR_UI_METHOD(refreshBegin);
USE_VIEW_FOR_UI_METHOD(refreshFinish);

-(id)isRefreshing:(id)args
{
    return [(TiUIScrollView *)[self view] isRefreshing:args];
}

@end
