@interface RootViewController: UIViewController < UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate > {
    
    NSMutableArray *array;
    NSString *theOne;
    NSString *metaD;
    NSString *deleteIpa;
    UIActionSheet *sheet;
    UIAlertView *alert;
    UINavigationBar *navBar;
    UINavigationBar *myBarA;
    UISwitch *mySwitch;
    UISwitch *mySwitchA;
    UITableView *myTable;
    UIView *view;
    UIView *viewA;
    
}
@end
