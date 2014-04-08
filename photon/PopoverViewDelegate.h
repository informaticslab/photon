//
//  PopoverViewDelegate.h
//  photon
//
//  Created by greg on 2/21/14.
//  Copyright (c) 2014 Informatics Research and Development Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PopoverViewDelegate <NSObject>

-(void)didClickDoneButton;
-(void)didClickFullArticleButton;
-(void)didTouchReadUserAgreementButton;


@end
