//
//  LoadingView.h
//  BIYI_HomeKit
//
//  Created by hexiaolin on 2020/7/21.
//  Copyright © 2020 BIYIOranization. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingView : UIView

+ (instancetype)sharedSingleton;
-(void)showInView:(UIView *)fView;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
