//
//  QCGridView.h
//  NewTestViews
//
//  Created by Arvid on 2014-04-04.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCQuestion.h"

@protocol PopupViewDelegate

-(NSArray *) questionStrings:(QCQuestion *) question; //:(id) qObject;
-(void) answerButtonHandler:(NSNumber *) index;
-(void) dismissPopup;
-(void) questionAnimationCompleted;
-(UIImage *) provideCategoryImage;
-(NSSet *) answerButtonsToDisableFiftyFifty;
-(void) decreaseFiftyFifty;

@end

@interface QCPopupView : UIView

-(void) rightAnswerChosenWithIndex:(NSNumber *) index points:(NSNumber *)points;
-(void) wrongAnswerIndex:(NSNumber *) chosenIndex correctWasIndex:(NSNumber *) index;
@property (weak) id <PopupViewDelegate> delegate;

-(void) resetAndLoadQuestionStrings:(QCQuestion *)question withFiftyFifty:(NSNumber *) numberOfFiftyFifty;

@end
