//
//  AboutVC.m
//  photon
//
//  Created by jtq6 on 12/2/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "AboutVC.h"
#import "SiteCatalystController.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.lblVersionInfo.text = [NSString stringWithFormat:@"%@ %@", [self getVersionString], [self getBuildString]];
    _txtvAbout.editable = NO;
    _txtvAbout.selectable = YES;
    _txtvAbout.dataDetectorTypes = UIDataDetectorTypeAll;
    _txtvAbout.delegate = self;

}


-(void)viewDidAppear:(BOOL)animated
{
    [APP_MGR.usageTracker trackNavigationEvent:SC_PAGE_TITLE_ABOUT inSection:SC_SECTION_ABOUT];
    
}


-(NSString *)getVersionString
{
    
    return [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

-(NSString *)getBuildString
{
    return [NSString stringWithFormat:@"Build %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSString *recipent = nil;
    
    if ([[URL absoluteString] isEqualToString:@"mailto:mmwrq@cdc.gov"])
        recipent = @"mmwrq@cdc.gov";
    else if ([[URL absoluteString] isEqualToString:@"mailto:informaticslab@cdc.gov"])
        recipent = @"informaticslab@cdc.gov";
    else
        return NO;
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    [mailVC setToRecipients:@[recipent]];
        
    [mailVC setSubject:@"MMWR Express"];
    mailVC.mailComposeDelegate = self;
        
    // Re-set the styling
    mailVC.navigationBar.barTintColor = [UIColor blueColor];
    
    [self presentViewController:mailVC animated:YES completion:nil];
    
    return NO;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    DebugLog(@"Email from About screen result: ");
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DebugLog(@"canceled");
            break;
        case MFMailComposeResultSaved:
            DebugLog(@"saved");
            break;
        case MFMailComposeResultSent:
            DebugLog(@"sent");
            break;
        case MFMailComposeResultFailed:
            DebugLog(@"failed");
            break;
        default:
            DebugLog(@"not sent");
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
