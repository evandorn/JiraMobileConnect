/**
   Copyright 2015 Atlassian Software

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/

#import "UIApplication+JMC.h"

@implementation UIApplication (JMC)

+ (UIViewController *)jmc_rootViewController {
//    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController *topMostViewControllerObj = [UIApplication topViewController];
    NSAssert(topMostViewControllerObj != nil, @"JIRA Mobile Connect Assert: "
             @"Key window must have a root view controller in order to present JIRA Mobile Connect alert controllers.");
    return topMostViewControllerObj;
}

+ (UIViewController*)topViewController {
  return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)viewController {
  if ([viewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController* tabBarController = (UITabBarController*)viewController;
    return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
  } else if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navContObj = (UINavigationController*)viewController;
    return [self topViewControllerWithRootViewController:navContObj.visibleViewController];
  } else if (viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed) {
    UIViewController* presentedViewController = viewController.presentedViewController;
    return [self topViewControllerWithRootViewController:presentedViewController];
  }
  else {
    for (UIView *view in [viewController.view subviews])
    {
      id subViewController = [view nextResponder];
      if ( subViewController && [subViewController isKindOfClass:[UIViewController class]])
      {
        if ([(UIViewController *)subViewController presentedViewController]  && ![subViewController presentedViewController].isBeingDismissed) {
          return [self topViewControllerWithRootViewController:[(UIViewController *)subViewController presentedViewController]];
        }
      }
    }
    return viewController;
  }
}

@end
