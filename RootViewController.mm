#import "RootViewController.h"
#import "UIKit/UIKit.h"
#import "QuartzCore/QuartzCore.h"

@implementation RootViewController
- (void)loadView {
    
    self.view =[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.view.backgroundColor =[UIColor clearColor];
    navBar =[[UINavigationBar alloc] init];
    navBar.frame = CGRectMake (0, 0, self.view.frame.size.width, 44);
    navBar.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    UINavigationItem *navItem =[[[UINavigationItem alloc] initWithTitle:@"IPA Installer"] autorelease];
    UIBarButtonItem *rightButton =[[[UIBarButtonItem alloc] initWithTitle: @"Reload" style: UIBarButtonItemStylePlain target: self action:@selector (rightButtonPressed)] autorelease];
    navItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *leftButton =[[[UIBarButtonItem alloc] initWithTitle: @"Settings" style: UIBarButtonItemStylePlain target: self action:@selector (leftButtonPressed)] autorelease];
    navItem.leftBarButtonItem = leftButton;
    navBar.barStyle = UIBarStyleDefault;
    navBar.items =[NSArray arrayWithObject:navItem];
    [self.view addSubview:navBar];
    myTable =[[UITableView alloc] initWithFrame: CGRectMake (0, 44, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [myTable setDataSource:self];
    [myTable setDelegate:self];
    [self.view addSubview:myTable];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
    array = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
    view = [[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, self.view.frame.size.height/2 - 60, 120, 120)] autorelease];
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = 5;
    [view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:view];
    view.hidden = YES;
    [myTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    //VIEWA

    viewA =[[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 160, self.view.frame.size.height/2 - 145, 320, 290)] autorelease];
    viewA.backgroundColor =[UIColor grayColor];
    viewA.layer.cornerRadius = 10;
    [viewA setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    myBarA =[[UINavigationBar alloc] init];
    myBarA.frame = CGRectMake (0, 0, viewA.frame.size.width, 44);
    myBarA.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    UINavigationItem *navItemA =[[[UINavigationItem alloc] initWithTitle:@"Settings"] autorelease];
    myBarA.barStyle = UIBarStyleDefault;
    UIBarButtonItem *leftButtonA =[[[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self action:@selector (leftButtonAPressed)] autorelease];
    navItemA.leftBarButtonItem = leftButtonA;
    myBarA.items =[NSArray arrayWithObject:navItemA];
    myBarA.layer.cornerRadius = 10;
    [viewA addSubview:myBarA];
    [myBarA setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(110, 120, 0, 0)];
    [mySwitch addTarget:self action:@selector(switchMethod) forControlEvents:UIControlEventValueChanged];
    mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchStatus"];
    [viewA addSubview:mySwitch];
    [mySwitch release];
    mySwitchA = [[UISwitch alloc] initWithFrame:CGRectMake(110, 220, 0, 0)];
    [mySwitchA addTarget:self action:@selector(switchMethodA) forControlEvents:UIControlEventValueChanged];
    mySwitchA.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchStatusA"];
    [viewA addSubview:mySwitchA];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewA.frame.size.width/2 - 150, viewA.frame.size.height/2 - 80, 300, 44)];
    myLabel.text = @"Remove MetaData";
    myLabel.backgroundColor = [UIColor whiteColor];
    myLabel.textColor = [UIColor blackColor];
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.layer.cornerRadius = 6;
    [myLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [viewA addSubview:myLabel];
    UILabel *myLabelA = [[UILabel alloc] initWithFrame:CGRectMake(viewA.frame.size.width/2 - 150, viewA.frame.size.height/2 + 20, 300, 44)];
    myLabelA.text = @"Delete After Install";
    myLabelA.backgroundColor = [UIColor whiteColor];
    myLabel.textColor = [UIColor blackColor];
    myLabelA.textAlignment = UITextAlignmentCenter;
    myLabelA.layer.cornerRadius = 6;
    [myLabelA setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [viewA addSubview:myLabelA];
    viewA.hidden = YES;
    [myLabel release];
    [myLabelA release];
    UIActivityIndicatorView *activityIndicatior = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(37, 37, 45, 45)];
    [activityIndicatior setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:activityIndicatior];      
    [activityIndicatior startAnimating];
    [self.view addSubview:viewA];
    
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
        
    return YES;
    
}

-(BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    
    return YES;
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
    
    return 1;
    
}

-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    
    switch (section) {
    
        case 0:
          return[array count];
          break;
        default:
          break;
    
    }
    
    return -1;
    
}

-(UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"Cell %i", indexPath.section]];

    if (cell == nil) {
    
    cell =[[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: [NSString stringWithFormat:@"Cell %i", indexPath.section]] autorelease];
    
    }
    
    switch (indexPath.section)
    
    {
    
    case 0:
    
          {
    
          cell.textLabel.text =[array objectAtIndex:indexPath.row];
          
      }
      
      break;
    default:
      break;
      
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    imageView =[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"clone.png"]];
    cell.accessoryView = imageView;
    return cell;
    
}

-(void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    
    theOne =[array objectAtIndex:indexPath.row];
    sheet =[[UIActionSheet alloc] initWithTitle: [array objectAtIndex: indexPath.row] delegate: self cancelButtonTitle: nil destructiveButtonTitle: @"Cancel" otherButtonTitles:@"Install", nil];
    [sheet showInView:self.view];
    [sheet release];
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
}

-(void) switchMethod {

    if(mySwitch.on){
        
        NSUserDefaults *switchSettings = [NSUserDefaults standardUserDefaults];
        [switchSettings setBool:YES forKey:@"SwitchStatus"];
        [switchSettings synchronize];
        
}
    else{
        
        NSUserDefaults *switchSettings = [NSUserDefaults standardUserDefaults];
        [switchSettings setBool:NO forKey:@"SwitchStatus"];
        [switchSettings synchronize];
        
}

}

-(void) switchMethodA {

    if(mySwitchA.on){
        
        NSUserDefaults *switchSettings = [NSUserDefaults standardUserDefaults];
        [switchSettings setBool:YES forKey:@"SwitchStatusA"];
        [switchSettings synchronize];
        
}
    else{
        
        NSUserDefaults *switchSettings = [NSUserDefaults standardUserDefaults];
        [switchSettings setBool:NO forKey:@"SwitchStatusA"];
        [switchSettings synchronize];
        
}
}

-(void) leftButtonPressed {
    
    viewA.hidden = NO;
    
}

-(void) leftButtonAPressed {
    
    viewA.hidden = YES;
    
}

-(void) rightButtonPressed {
    
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
    array = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
    [myTable reloadData];
    
}

-(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    
  if (editingStyle == UITableViewCellEditingStyleDelete)
    
    {
    
    NSString *userFile =[array objectAtIndex:indexPath.row];
    NSString *docPath = @"/var/mobile/Documents/";
    NSString *delPath =[NSString stringWithFormat:@"%@%@", docPath, userFile];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    [fileManager removeItemAtPath: delPath error:nil];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
    array = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
    [myTable reloadData];
    
    }
    
}

-(void) ipaDirectory {
    
    if(mySwitch.on){
    metaD = @" -r";
}
    else{
    metaD = @"";
}

    if(mySwitchA.on){
    deleteIpa = @" -d";
}
    else{
    deleteIpa = @"";
}

    NSString *stringTwo = @" \"/var/mobile/Documents/";
    NSString *quoteString = @"\"";
    NSString *ipaPath =[NSString stringWithFormat:@"%@%@%@", stringTwo, theOne, quoteString];
    NSString *installFunct = @"ipainstaller -f";
    NSString *blahString =[NSString stringWithFormat:@"%@%@%@", installFunct, metaD, deleteIpa];
    NSString *finalFunction =[NSString stringWithFormat:@"%@%@", blahString, ipaPath];
    system ([finalFunction UTF8String]);

}

-(void) waitFunct {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(ipaDirectory) object:nil];
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(closeAlert) object:nil];
    [operation1 addDependency:operation];
    [q addOperation:operation];
    [operation release];
    [q addOperation:operation1];
    [operation1 release];
    
}

-(void) closeAlert {
    
    view.hidden = YES;
    self.view.userInteractionEnabled = YES;
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
    array = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
    [myTable reloadData];
    
}

-(void) actionSheet:(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
  if (buttonIndex ==[actionSheet cancelButtonIndex])
   
    {
    
    //
   
    }
    
  else if (buttonIndex == 0)
    
    {
    
    // 
    
    }
    
  else if (buttonIndex == 1)
     
     {
     
     view.hidden = NO;
     self.view.userInteractionEnabled = NO;
     [self waitFunct];
    
    }
    
}

-(void) dealloc {
    
    [myTable release];
    [array release];
    [sheet release];
    [imageView release];
    [view release];
    [viewA release];
    [super dealloc];
    
}

@end
