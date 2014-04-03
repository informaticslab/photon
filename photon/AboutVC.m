//
//  AboutVC.m
//  photon
//
//  Created by jtq6 on 12/2/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "AboutVC.h"

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
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

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

@end
