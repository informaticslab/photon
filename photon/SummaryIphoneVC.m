//
//  SummaryIphoneVC.m
//  photon
//
//  Created by Greg Ledbetter on 2/20/16.
//  Copyright © 2016 Informatics Research and Development Lab. All rights reserved.
//

#import "SummaryIphoneVC.h"

@interface SummaryIphoneVC ()

@end

@implementation SummaryIphoneVC

UIFont *font;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     font = [UIFont fontWithName:@"HelveticaNeue" size:15];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setKnownText:(NSString *)text
{
    
    self.txtvKnownText.text = text;
    self.txtvKnownText.font = font;
    self.txtvKnownText.textContainerInset = UIEdgeInsetsMake(3,3,3,3);
//    [self.txtvKnownText sizeToFit];

    CGSize sizeThatFitsTextView = [self.txtvKnownText sizeThatFits:self.txtvKnownText.frame.size];
    self.txtvKnownTextHeightConstraint.constant = sizeThatFitsTextView.height+60;
    
}

-(void)setAddedText:(NSString *)text
{
    
    self.txtvAddedText.text = text;
    self.txtvAddedText.font = font;
    self.txtvAddedText.textContainerInset = UIEdgeInsetsMake(3,3,3,3);
//    [self.txtvAddedText sizeToFit];
    
    CGSize sizeThatFitsTextView = [self.txtvAddedText sizeThatFits:self.txtvAddedText.frame.size];
    self.txtvAddedTextHeightConstraint.constant = sizeThatFitsTextView.height+60;
    
}


-(void)setImplicationsText:(NSString *)text
{
    
    self.txtvImplicationsText.text = text;
    self.txtvImplicationsText.font = font;
    self.txtvImplicationsText.textContainerInset = UIEdgeInsetsMake(3,3,3,3);
//    [self.txtvImplicationsText sizeToFit];
    
    CGSize sizeThatFitsTextView = [self.txtvImplicationsText sizeThatFits:self.txtvImplicationsText.frame.size];
    self.txtvImplicationsTextHeightConstraint.constant = sizeThatFitsTextView.height+60;
    
}



@end
