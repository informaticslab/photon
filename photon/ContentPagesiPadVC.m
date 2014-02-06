//
//  ContentPagesiPadVC.m
//  photon
//
//  Created by Greg on 2/6/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import "ContentPagesiPadVC.h"
#import "ContentIpadVC.h"

@interface ContentPagesiPadVC ()

@end

@implementation ContentPagesiPadVC

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // check for diffs between ios 6 & 7
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)])
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0];
    else {
        [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:88.0/255.0 blue:167.0/255.0 alpha:1.0]];
    }

    
	// Do any additional setup after loading the view.
    _pageHeaders = @[@"What is already known?", @"What is added by this report?", @"What are the implications for public health practice?"];
    if (_article != nil) {
        _pageText = @[_article.already_know, _article.added_by_report, _article.implications];
    } else {
        _pageText = @[@"", @"", @""];
    }
    
    _navbarTitles = @[@"Summary", @"Summary", @"Summary"];
    _icons = @[@"bluebox_subheader_icon", @"added_icon", @"implications_icon"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentPVC"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    ContentIpadVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.navigationItem.title = _navbarTitles[0];

}


- (ContentIpadVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageHeaders count] == 0) || (index >= [self.pageHeaders count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ContentIpadVC *contentIpadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentIpadVC"];
    contentIpadVC.headerText = self.pageHeaders[index];
    contentIpadVC.contentText = self.pageText[index];
    contentIpadVC.pageIndex = index;
    contentIpadVC.navbarTitle = self.navbarTitles[index];
    contentIpadVC.title = self.navbarTitles[index];
    contentIpadVC.imageName = self.icons[index];
    //self.navigationItem.title = self.navbarTitles[index];
    
    return contentIpadVC;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentIpadVC *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentIpadVC *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageHeaders count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageHeaders count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    for (UIViewController *vc in pendingViewControllers) {
        // NSLog(@"Transition to view controller = %@", vc.title);
        self.navigationItem.title = vc.title;
    }
    
    
}
- (IBAction)startWalkthrough:(id)sender {
    ContentIpadVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
