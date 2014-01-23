//
//  KeywordsTVC.h
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeywordsTVC : UITableViewController<UISearchDisplayDelegate>

- (IBAction)refresh:(id)sender;
@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;
//@property(strong, nonatomic) UISearchDisplayController *searchDisplayController;
@end
