//
//  QCQuestionProvider.m
//  QuizCrush
//
//  Created by Arvid on 2014-04-03.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCQuestionProvider.h"

@interface QCQuestionProvider ()

@property NSArray *questionsArray;

@end

@implementation QCQuestionProvider

-(id) init {
    if(!(self = [super init])) {
        return self;
    }

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"svenskaQuestions" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingMappedIfSafe
                                                error:nil];

    _questionsArray = [NSJSONSerialization JSONObjectWithData:JSONData
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];

    return self;
}

-(QCQuestion *) provideQuestionOfCategory:(NSNumber *) category{

//    QCQuestion *q = [[QCQuestion alloc] initWithCategory:@5
//                                                    topic:@"Golf"
//                                           questionString:@"Vilket folkslag uppfann en stamform till golf?"
//                                                  answers:@[@"Romarna", @"Grekerna", @"Mayafolket", @"Aztekerna"]
//                                       correctAnswerIndex:@0];
//

    NSDictionary *d = @{@"cat": @99};

    while (!([d[@"cat"] isEqualToNumber:category])) {
        int index = arc4random_uniform((u_int32_t)[_questionsArray count]);
        d = _questionsArray[index];
    }

    NSString *correctAnswer = d[@"ac"];

    NSArray *answers = [self shuffleArray:@[d[@"ac"], d[@"a1"], d[@"a2"], d[@"a3"]]];


    NSNumber *correctIndex = @([answers indexOfObject:correctAnswer]);

    QCQuestion *q = [[QCQuestion alloc] initWithCategory:d[@"cat"]
                                                   topic:d[@"tp"]
                                          questionString:d[@"t"]
                                                 answers:answers
                                      correctAnswerIndex:correctIndex];

    return q;
//    return nil;
}

-(NSArray *) shuffleArray:(NSArray *) array {
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:array];
    int n = (int) [array count];
    int j;
    for (int i = n - 1; i > 0; i--) {
        j = arc4random_uniform(i + 1);
        [returnArray exchangeObjectAtIndex:j withObjectAtIndex:i];
    }
    return returnArray;
}




















@end
