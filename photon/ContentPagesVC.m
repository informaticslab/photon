//
//  ContentPagesVC.m
//  photon
//
//  Created by jtq6 on 12/31/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "ContentPagesVC.h"
#import "ContentVC.h"

@interface ContentPagesVC ()

@property (weak, nonatomic) ContentVC *currVC;

@end

@implementation ContentPagesVC

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
    _pageHeaders = @[@"What is already known?", @"What is added by this report?", @"What are the implications for public health practice?"];
    _pageText = @[_article.already_known, _article.added_by_report, _article.implications];
    _navbarTitles = @[@"Summary", @"Summary", @"Summary"];
    _icons = @[@"bluebox_subheader_icon", @"added_icon", @"implications_icon"];
    
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentPVC"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

    ContentVC *startingViewController = [self viewControllerAtIndex:0];
    self.currVC = startingViewController;
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    self.navigationItem.title = _navbarTitles[0];

}

- (ContentVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageHeaders count] == 0) || (index >= [self.pageHeaders count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ContentVC *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentVC"];
    contentVC.headerText = self.pageHeaders[index];
    contentVC.contentText = self.pageText[index];
    contentVC.pageIndex = index;
    contentVC.navbarTitle = self.navbarTitles[index];
    contentVC.title = self.navbarTitles[index];
    contentVC.imageName = self.icons[index];
    //self.navigationItem.title = self.navbarTitles[index];
    
    return contentVC;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.currVC = (ContentVC *)viewController;
    NSUInteger index = ((ContentVC *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return self.currVC = [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    self.currVC = (ContentVC *)viewController;
    NSUInteger index = ((ContentVC *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageHeaders count]) {
        return nil;
    }
    return self.currVC = [self viewControllerAtIndex:index];
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

- (void)pageForward
{
    UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:(UIViewController *)self.currVC];
    if (nextViewController != nil) {
        NSArray *viewControllers = @[nextViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        UIAccessibilityPostNotification(UIAccessibilityPageScrolledNotification,
                                        @"Scrolling left to next page.");
    }
    
}


- (void)pageBackwards
{
    UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:(UIViewController *)self.currVC];
    if (previousViewController != nil) {
        NSArray *viewControllers = @[previousViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        UIAccessibilityPostNotification(UIAccessibilityPageScrolledNotification,
                                        @"Scrolling right to previous page.");
    }
}

- (BOOL)accessibilityScroll:(UIAccessibilityScrollDirection)direction
{
    if (direction == UIAccessibilityScrollDirectionRight) {
        [self pageBackwards];
         return YES;

    }
    else if (direction == UIAccessibilityScrollDirectionLeft) {
        [self pageForward];
        return YES;
    }
    else
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
