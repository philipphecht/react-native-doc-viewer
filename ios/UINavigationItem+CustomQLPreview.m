//
//  UINavigationItem+CustomQLPreview.m
//  RNReactNativeDocViewer
//
//  Created by GJS on 2019/4/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "UINavigationItem+CustomQLPreview.h"
#import <QuickLook/QuickLook.h>
#import <objc/runtime.h>

@implementation UINavigationItem (CustomQLPreview)

void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL);

- (void) override_setRightBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated{
    if (item && [item.target isKindOfClass:[QLPreviewController class]] && item.action == @selector(actionButtonTapped:)){
        QLPreviewController* qlpc = (QLPreviewController*)item.target;
        [self override_setRightBarButtonItem:qlpc.navigationItem.rightBarButtonItem animated: animated];
    }else{
        [self override_setRightBarButtonItem:item animated: animated];
    }
}

+ (void)load {
    MethodSwizzle(self, @selector(setRightBarButtonItem:animated:), @selector(override_setRightBarButtonItem:animated:));
}

void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL) {
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
    
    if (class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

@end
