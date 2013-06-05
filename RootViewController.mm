#import "RootViewController.h"
#include <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#include <Foundation/Foundation.h>

@implementation RootViewController
- (void)loadView {
        self.view =[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
        self.view.backgroundColor =[UIColor grayColor];
        navBar = [[UINavigationBar alloc] init];
        navBar.frame = CGRectMake (0, 0, self.view.frame.size.width, 44);
        UINavigationItem *navItem =[[[UINavigationItem alloc] initWithTitle:@"IPA 1nstaller"] autorelease];
        navBar.barStyle = UIBarStyleDefault;
        navBar.items =[NSArray arrayWithObject:navItem];
        [self.view addSubview:navBar];
        myTable =[[UITableView alloc] initWithFrame: CGRectMake (0, 44, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        [myTable setDataSource:self];
        [myTable setDelegate:self];
        [self.view addSubview:myTable];
        NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
        files = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
        [myTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [navBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        overlay = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
        overlay.hidden = YES;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = .6;
        [overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:overlay];
        view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 500 , 500)] autorelease];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        view.layer.cornerRadius = 5;
        [view setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        view.hidden = YES;
        [self.view addSubview:view];
        activityindicator1 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(250, 250, 0, 0)];
        [activityindicator1 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [view addSubview:activityindicator1];
        [activityindicator1 startAnimating];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
        return YES;  
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
        return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 60;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
        return 1;
}

-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
        switch (section) 
        {
                case 0:
                return[files count];
                break;
                default:
                break;
        }
        return -1;
}

-(UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat:@"Cell %i", indexPath.section]];
        if (cell == nil)
        {
                cell =[[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: [NSString stringWithFormat:@"Cell %i", indexPath.section]] autorelease];
        }
        switch (indexPath.section)
                {
                case 0:
                        {
                        cell.textLabel.text =[files objectAtIndex:indexPath.row];
                        }
                break;
                default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
}

-(void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
        theOne =[files objectAtIndex:indexPath.row];
        sheet =[[UIActionSheet alloc] initWithTitle: [files objectAtIndex: indexPath.row] delegate: self cancelButtonTitle: nil destructiveButtonTitle: @"Cancel" otherButtonTitles:@"Install", nil];
        [sheet showInView:self.view];
        [sheet release];
        [tableView deselectRowAtIndexPath: indexPath animated:YES];
}

-(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
    [myTable beginUpdates];
    NSString *userFile =[files objectAtIndex:indexPath.row];
    NSString *docPath = @"/var/mobile/Documents/";
    NSString *delPath =[NSString stringWithFormat:@"%@%@", docPath, userFile];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    [fileManager removeItemAtPath: delPath error:nil];
    [files removeObjectAtIndex:indexPath.row];
    [myTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
    files = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
    [myTable reloadData];
    [myTable endUpdates];
                }  
}

-(void) installIPA {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.s1ris.ipa1nstallersettings.plist"];
        if([[dict objectForKey:@"delete"] boolValue]) {
                deleteipa = @" -d";
        }
        else {
                deleteipa = @"";
        }
        if([[dict objectForKey:@"metadata"] boolValue]) {
                metadata = @" -r";
        }
        else {
                metadata = @"";
        }
        if([[dict objectForKey:@"cleaninstall"] boolValue]) {
               cleaninstall = @" -c";
        }
        else {
                cleaninstall = @"";
        }
        navBar.userInteractionEnabled = NO;
        myTable.userInteractionEnabled = NO;
        view.hidden = NO;
        NSString *baseDirectory = @" \"/var/mobile/Documents/";
        NSString *quoteString = @"\"";
        NSString *ipaPath =[NSString stringWithFormat:@"%@%@%@", baseDirectory, theOne, quoteString];
        NSString *installScript = @"ipainstaller -f";
        NSString *scriptParameters =[NSString stringWithFormat:@"%@%@%@%@", installScript, deleteipa, metadata, cleaninstall];
        NSString *finalInstall =[NSString stringWithFormat:@"%@%@", scriptParameters, ipaPath];
        system ([finalInstall UTF8String]);
}

-(void) beginInstall {
        navBar.userInteractionEnabled = NO;
        myTable.userInteractionEnabled = NO;
        view.hidden = NO;
        NSOperationQueue *q = [[NSOperationQueue alloc] init];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(installIPA) object:nil];
        NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(dismissView) object:nil];
        [operation1 addDependency:operation];
        [q addOperation:operation1];
        [operation release];
        [q addOperation:operation];
        [operation1 release];
        [q release];
}

-(void) dismissView {
                
                overlay.hidden = YES;
                view.hidden = YES;
                view.alpha = 0.5;
                CGRect frame = view.frame;
                frame.size.height += 400.0;
                frame.origin.y = 0;
                frame.size.width += 400.0;
                frame.origin.x = 0;
                view.frame = frame;
                navBar.userInteractionEnabled = YES;
                myTable.userInteractionEnabled = YES;
                NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents" error:nil];
                files = [[NSMutableArray arrayWithArray:[dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", @".ipa", nil]]] retain];
                [myTable reloadData];
}

-(void) actionSheet:(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex {
        if (buttonIndex ==[actionSheet cancelButtonIndex]) {
                }
        else if (buttonIndex == 0){
                }
        else if (buttonIndex == 1) {
                UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
                navBar.userInteractionEnabled = NO;
                myTable.userInteractionEnabled = NO;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.5];
                [UIView setAnimationBeginsFromCurrentState:YES];

                overlay.hidden = NO;
                view.alpha = 1;
                CGRect frame = view.frame;
                frame.size.height -= 400;
                frame.size.width -= 400;

                if(orientation == UIInterfaceOrientationPortrait ||  orientation == UIInterfaceOrientationPortraitUpsideDown) {
                frame.origin.y = self.view.frame.size.height/2 - 50;
                frame.origin.x = self.view.frame.size.width/2 - 50;
}
                if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
                frame.origin.y = self.view.frame.size.width/2 - 50;
                frame.origin.x = self.view.frame.size.height/2 - 50;


}
                view.frame = frame;

                CGRect frame1 = activityindicator1.frame;
                frame1.origin.y = view.frame.size.width/2;
                frame1.origin.x = view.frame.size.height/2;
                activityindicator1.frame = frame1;
                
                view.hidden = NO;
                [UIView commitAnimations];
                [self beginInstall];
                }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

UITouch *touch = [touches anyObject];

if ([touch view] == view) {
    CGPoint location = [touch locationInView:self.view];
    view.center = location;
    return;
   }
}

-(void) dealloc {
        [myTable release];
        [files release];
        [sheet release];
        [view release];
        [super dealloc];
}

@end
