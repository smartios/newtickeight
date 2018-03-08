//
//  AppDelegate.swift
//  SSASideMenuExample
//
//
import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SSASideMenuDelegate {
    
    var window: UIWindow?
    let device = UIDevice.current.model
    private var reachability:Reachability!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        Thread.sleep(forTimeInterval: 4)
        //MARK : Setup SSASideMenu
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let v = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
        con.restorationIdentifier = "HomeViewController"
        
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        // Then push that view controller onto the navigation stack
        nav.viewControllers = [con]
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        Fabric.with([Crashlytics.self])
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.checkForReachability(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil);
        self.reachability = Reachability.forInternetConnection();
        self.reachability.startNotifier();
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let df1 = DateFormatter()
        df1.dateFormat = "yyyy-MM-dd"
        
        if((UserDefaults.standard.object(forKey: "token_generated_date") == nil) || (df1.string(from: (UserDefaults.standard.object(forKey: "token_generated_date") as! Date))) != df1.string(from: Date()))
        {
            getIpWebservice()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Hit if access token is nil and network connectivity is changed
    func checkForReachability(notification:NSNotification)
    {
        let networkReachability = notification.object as! Reachability;
        let remoteHostStatus = networkReachability.currentReachabilityStatus()
        
        if (remoteHostStatus != NetworkStatus.NotReachable && UserDefaults.standard.value(forKey: "EndUserIp") == nil)
        {
            getIpWebservice()
        }
    }
    
    
    //MARK:- side menu
    func sideMenuWillShowMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //print("Will Show \(menuViewController)")
    }
    
    func sideMenuDidShowMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //print("Did Show \(menuViewController)")
    }
    
    func sideMenuDidHideMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //print("Did Hide \(menuViewController)")
    }
    
    func sideMenuWillHideMenuViewController(_ sideMenu: SSASideMenu, menuViewController: UIViewController) {
        //print("Will Hide \(menuViewController)")
    }
    func sideMenuDidRecognizePanGesture(_ sideMenu: SSASideMenu, recongnizer: UIPanGestureRecognizer) {
        //print("Did Recognize PanGesture \(recongnizer)")
    }
    
    
    //MARK: webservices
    func getIpWebservice()
    {
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()

                requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")

                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120

                manager.get((BASE_URL + "api/getip"), parameters: nil, progress: nil, success:
                    {
                        requestOperation, response  in

                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()

                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                UserDefaults.standard.setValue(dataFromServer.value(forKey: "clientIp") as! String, forKey: "EndUserIp")
                                UserDefaults.standard.setValue(dataFromServer.value(forKey: "token") as! String, forKey: "token")
                                UserDefaults.standard.setValue(Date(), forKey: "token_generated_date")
                                NotificationCenter.default.post(name: Notification.Name("ipGenerated"), object: nil)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    //       print(error)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
}
