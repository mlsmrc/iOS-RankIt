#import <UIKit/UIKit.h>
#import "ConnectionToServer.h"

@interface ViewController : UIViewController
{
    __weak IBOutlet UITabBarItem *Home;
    __weak IBOutlet UITabBarItem *MieiSondaggi;
    __weak IBOutlet UITabBarItem *Votati;
    __weak IBOutlet UITabBarItem *Impostazioni;
    __weak IBOutlet UITableView *TableView;
    __weak IBOutlet UIBarButtonItem *AddPoll;
    __weak IBOutlet UITabBar *TabBar;
}

@property (weak, nonatomic) IBOutlet UITabBar *TabBar;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UITabBarItem *Home;
@property (weak, nonatomic) IBOutlet UITabBarItem *MieiSondaggi;
@property (weak, nonatomic) IBOutlet UITabBarItem *Votati;
@property (weak, nonatomic) IBOutlet UITabBarItem *Impostazioni;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddPoll;

@end