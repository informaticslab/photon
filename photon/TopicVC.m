//
//  TopicKnownVC.m
//  photon
//
//  Created by jtq6 on 11/8/13.
//  Copyright (c) 2013 Informatics Research and Development Lab. All rights reserved.
//

#import "TopicVC.h"
#import "FullArticleVC.h"
#import "ShareActionSheet.h"

@implementation TopicVC

ShareActionSheet *shareAS;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(_mode == TOPIC_KNOWN) {
        _txtView.text = _article.already_know;
        _lblHeader.text = @"What is already known?";
    } else if (_mode == TOPIC_ADDED ) {
        _txtView.text = _article.added_by_report;
        _lblHeader.text = @"What is added by this report?";
        
    } else if (_mode == TOPIC_IMPLICATIONS) {
        _txtView.text = _article.implications;
        _lblHeader.text = @"What are the implications for public health practice?";
        
    }
    _txtView.font = APP_MGR.textFont;

    [self.lblHeader setNumberOfLines:0];
    
 //   _txtView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self.txtView sizeToFit];

    
    [_topicScrollView setScrollEnabled:YES];
    [_topicScrollView setContentSize:(CGSizeMake(320, 800))];

    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareButton.width = -1.0;
    
    self.navigationItem.rightBarButtonItem = shareButton;


    self.txtvSourceArticle.text = _article.title;
    self.txtvSourceArticle.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.txtfSourceArticleHeading.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    self.txtView.editable = NO;
    self.txtvSourceArticle = NO;
    self.txtfSourceArticleHeading.enabled = NO;
    CALayer *btnLayer = [_btnViewFullArticle layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];


}

- (void)viewDidLayoutSubviews
{
//    _txtView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self.txtView sizeToFit];
    //[_txtView setTextContainerInset:UIEdgeInsetsMake(10, 20, 10, 20)];

}

- (void)share:(id)sender
{
    // display the options for sharing
    shareAS = [[ShareActionSheet alloc] initToShareArticleUrl:self.article.url fromVC:self];
    [shareAS showView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)btFullArticleTouchUp:(id)sender {
    [self performSegueWithIdentifier:@"pushViewFullArticleFromTopic" sender:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushViewFullArticleFromTopic"])
    {
        FullArticleVC *fullArticleVC = segue.destinationViewController;
        fullArticleVC.url = _article.url;
        
    }
}
@end
