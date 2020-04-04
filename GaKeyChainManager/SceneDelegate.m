#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

/*
 1,在这个方法中,配置在UIWindownScene中的window属性;
 2,如果使用storyboard,会自动配置.
 */

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    NSLog(@"connect to session");
    UIWindowScene * ws = (UIWindowScene *)scene;
    HomeViewController * vc = [HomeViewController new];
    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window = [[UIWindow alloc]initWithWindowScene:ws];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = nc;
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    [self.window makeKeyAndVisible];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
