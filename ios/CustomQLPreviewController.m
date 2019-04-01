//
//  CustomQLPreviewController.m
//  RNReactNativeDocViewer
//
//  Created by GJS on 2019/4/1.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "CustomQLPreviewController.h"
#import "UINavigationItem+CustomQLPreview.h"

@interface CustomQLPreviewController () <UINavigationBarDelegate>

@property (nonatomic, strong) UINavigationBar *qlNavigationBar;
@property (nonatomic, strong) UINavigationBar *overlayNavigationBar;
@property (nonatomic, assign) BOOL isIOS6;

@end

@implementation CustomQLPreviewController

- (void)dealloc {
    @try {
        [self.qlNavigationBar removeObserver:self forKeyPath:@"hidden"];
    }
    @catch (NSException * __unused exception) {}
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isIOS6 = [[[UIDevice currentDevice] systemVersion] floatValue] < 7.f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

// First of all we need to subclass QLPreviewContoller and overwrite the viewDidAppear method and viewWillLayoutSubviews like this:
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.qlNavigationBar = [self getNavigationBarFromView:self.view];
    
    self.overlayNavigationBar = [[UINavigationBar alloc] initWithFrame:[self navigationBarFrameForOrientation:[[UIApplication sharedApplication] statusBarOrientation]]];
    self.overlayNavigationBar.delegate = self;
    self.overlayNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.overlayNavigationBar];
    
    //NSAssert(self.qlNavigationBar, @"could not find navigation bar");
    NSLog(@"could not find navigation bar");
    
    if (self.qlNavigationBar) {
        [self.qlNavigationBar addObserver:self forKeyPath:@"hidden" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        [self.qlNavigationBar removeFromSuperview];
    }
    
    // Now initialize your custom navigation bar with whatever items you like...
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Your title goes here"];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.navigationItem.title];
    UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    item.leftBarButtonItem = doneButton;
    item.hidesBackButton = YES;
    
    [self.overlayNavigationBar pushNavigationItem:item animated:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.overlayNavigationBar.frame = [self navigationBarFrameForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

static inline UIEdgeInsets sgm_safeAreaInset(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

//The next thing we should do is listen for visibility changes of the quicklook navigationbar:
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Toggle visiblity of our custom navigation bar according to the ql navigationbar
    self.overlayNavigationBar.hidden = self.qlNavigationBar.isHidden;
    [self.qlNavigationBar removeFromSuperview];
}

//So now we need to implement methods we need to get the QL navigationbar and one that always gives us the current frame for our custom navigation bar:
- (UINavigationBar*)getNavigationBarFromView:(UIView *)view {
    // Find the QL Navigationbar
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UINavigationBar class]]) {
            return (UINavigationBar *)v;
        } else {
            UINavigationBar *navigationBar = [self getNavigationBarFromView:v];
            if (navigationBar) {
                return navigationBar;
            }
        }
    }
    return nil;
}

- (CGRect)navigationBarFrameForOrientation:(UIInterfaceOrientation)orientation {
    // We cannot use the frame of qlNavigationBar as it changes position when hidden, also there seems to be a bug in iOS7 concerning qlNavigationBar height in landscape
    UIEdgeInsets safeAreaInsets = sgm_safeAreaInset(self.view);
    CGFloat height = 44.0; // 导航栏原本的高度，通常是44.0
    height += safeAreaInsets.top > 0 ? safeAreaInsets.top : 20.0; // 20.0是statusbar的高度
    return CGRectMake(0.0f, self.isIOS6 ? 20.0f : safeAreaInsets.top, self.view.bounds.size.width, [self navigationBarHeight:orientation]);
}

- (CGFloat)navigationBarHeight:(UIInterfaceOrientation)orientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(UIInterfaceOrientationIsLandscape(orientation)) {
            return self.isIOS6 ? 32.0f : 52.0f;
        } else {
            return self.isIOS6 ? 44.0f : 64.0f;
        }
    } else {
        return self.isIOS6 ? 44.0f : 64.0f;
    }
}

- (void)doneButtonTapped:(UIButton *)sender {
    [self.overlayNavigationBar removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
