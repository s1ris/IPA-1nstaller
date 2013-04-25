@interface RootViewController: UIViewController < UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate > {
    
    NSMutableArray *files;
    NSString *theOne;
    NSString *metaData;
    NSString *deleteIpa;
    UIActionSheet *sheet;
    UINavigationBar *navBar;
    UINavigationBar *myBarA;
    UISwitch *mySwitch;
    UISwitch *mySwitchA;
    UITableView *myTable;
    UIView *view;
    UIView *viewA;
    
}
@end
