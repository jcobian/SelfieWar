//
//  UILabel+ResizeUILabel.m
//  SolsticeContactsApp
//
//  Created by Jonathan Cobian on 9/23/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "UILabel+ResizeUILabel.h"

@implementation UILabel (ResizeUILabel)
-(void)resizeIfTooBig {
    self.numberOfLines =1;
    self.minimumScaleFactor = .2;
    self.adjustsFontSizeToFitWidth = YES;

}
@end
