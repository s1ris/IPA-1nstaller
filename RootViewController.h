@interface RootViewController: UIViewController < UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate > {    
    NSMutableArray *files;
    NSString *theOne;
    NSString *deleteipa;
    NSString *metadata;
    NSString *cleaninstall;
    UIActionSheet *sheet;
    UIActivityIndicatorView *activityindicator1;
    UINavigationBar *navBar;
    UITableView *myTable;
    UIView *view;
    UIView *overlay;
}
@end
