/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2013年 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "TiUIListView.h"
#import "TiUIListViewProxy+ISRefreshControl.h"

#import "ISRefreshControl.h"

@interface TiUIListView (TiUIListView_ISRefreshControl)

@property (nonatomic, retain) ISRefreshControl *refreshControl;
@property (nonatomic, retain) UIView *refreshControlBackgroundView;

-(void)setRefreshControlTintColor_:(id)args;
-(void)setRefreshControlBackgroundColor_:(id)args;
-(void)setRefreshControlEnabled_:(id)args;

-(void)refreshBegin:(id)args;
-(void)refreshFinish:(id)args;
-(id)isRefreshing:(id)args;

@end
