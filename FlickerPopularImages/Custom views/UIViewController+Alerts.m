//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "UIViewController+Alerts.h"

#import <objc/runtime.h>

/*! @var kPleaseWaitAssociatedObjectKey
 @brief Key used to identify the "please wait" spinner associated object.
 */
static NSString *const kPleaseWaitAssociatedObjectKey =
    @"_UIViewControllerAlertCategory_PleaseWaitScreenAssociatedObject";

/*! @var kOK
 @brief Text for an 'OK' button.
 */
static NSString *const kOK = @"OK";

/*! @var kCancel
 @brief Text for an 'Cancel' button.
 */
static NSString *const kCancel = @"Cancel";

/*! @class SimpleTextPromptDelegate
 @brief A @c UIAlertViewDelegate which allows @c UIAlertView to be used with blocks more easily.
 */
@interface SimpleTextPromptDelegate : NSObject<UIAlertViewDelegate>

/*! @fn init
 @brief Please use initWithCompletionHandler.
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/*! @fn initWithCompletionHandler:
 @brief Designated initializer.
 @param completionHandler The block to call when the alert view is dismissed.
 */
- (nullable instancetype)initWithCompletionHandler:(AlertPromptCompletionBlock)completionHandler
    NS_DESIGNATED_INITIALIZER;

@end

@implementation UIViewController (Alerts)

/*! @fn supportsAlertController
 @brief Determines if the current platform supports @c UIAlertController.
 @return YES if the current platform supports @c UIAlertController.
 */
- (BOOL)supportsAlertController {
  return NSClassFromString(@"UIAlertController") != nil;
}





- (void)showSpinner:(nullable void (^)(void))completion {
  if ([self supportsAlertController]) {
    [self showModernSpinner:completion];
  } else {
    [self showIOS7Spinner:completion];
  }
}

- (void)showModernSpinner:(nullable void (^)(void))completion {
  UIAlertController *pleaseWaitAlert =
      objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));
  if (pleaseWaitAlert) {
    if (completion) {
      completion();
    }
    return;
  }
  pleaseWaitAlert = [UIAlertController alertControllerWithTitle:nil
                                                        message:@"Please Wait...\n\n\n\n"
                                                 preferredStyle:UIAlertControllerStyleAlert];

  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  spinner.color = [UIColor blackColor];
  spinner.center = CGPointMake(pleaseWaitAlert.view.bounds.size.width / 2,
                               pleaseWaitAlert.view.bounds.size.height / 2);
  spinner.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
      UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  [spinner startAnimating];
  [pleaseWaitAlert.view addSubview:spinner];

  objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey),
                           pleaseWaitAlert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self presentViewController:pleaseWaitAlert animated:YES completion:completion];
}

- (void)showIOS7Spinner:(nullable void (^)(void))completion {
  UIWindow *pleaseWaitWindow =
      objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));

  if (pleaseWaitWindow) {
    if (completion) {
      completion();
    }
    return;
  }

  pleaseWaitWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  pleaseWaitWindow.backgroundColor = [UIColor clearColor];
  pleaseWaitWindow.windowLevel = UIWindowLevelStatusBar - 1;

  UIView *pleaseWaitView = [[UIView alloc] initWithFrame:pleaseWaitWindow.bounds];
  pleaseWaitView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  pleaseWaitView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  spinner.center = pleaseWaitView.center;
  [pleaseWaitView addSubview:spinner];
  [spinner startAnimating];

  pleaseWaitView.layer.opacity = 0.0;
  [self.view addSubview:pleaseWaitView];

  [pleaseWaitWindow addSubview:pleaseWaitView];

  [pleaseWaitWindow makeKeyAndVisible];

  objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey),
                           pleaseWaitWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

  [UIView animateWithDuration:0.5f
      animations:^{
        pleaseWaitView.layer.opacity = 1.0f;
      }
      completion:^(BOOL finished) {
        if (completion) {
          completion();
        }
      }];
}

- (void)hideSpinner:(nullable void (^)(void))completion {
  if ([self supportsAlertController]) {
    [self hideModernSpinner:completion];
  } else {
    [self hideIOS7Spinner:completion];
  }
}

- (void)hideModernSpinner:(nullable void (^)(void))completion {
  UIAlertController *pleaseWaitAlert =
      objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));

  [pleaseWaitAlert dismissViewControllerAnimated:YES completion:completion];

  objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey), nil,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideIOS7Spinner:(nullable void (^)(void))completion {
  UIWindow *pleaseWaitWindow =
      objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));

  UIView *pleaseWaitView;
  pleaseWaitView = pleaseWaitWindow.subviews.firstObject;

  [UIView animateWithDuration:0.5f
      animations:^{
        pleaseWaitView.layer.opacity = 0.0f;
      }
      completion:^(BOOL finished) {
        [pleaseWaitWindow resignKeyWindow];
        objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey), nil,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (completion) {
          completion();
        }
      }];
}

@end

@implementation SimpleTextPromptDelegate {
  AlertPromptCompletionBlock _completionHandler;
  SimpleTextPromptDelegate *_retainedSelf;
}

- (instancetype)initWithCompletionHandler:(AlertPromptCompletionBlock)completionHandler {
  self = [super init];
  if (self) {
    _completionHandler = completionHandler;
    _retainedSelf = self;
  }
  return self;
}



@end
