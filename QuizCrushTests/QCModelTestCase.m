//
//  QCModelTestCase.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-18.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "QCPlayingFieldModel.h"

@interface QCModelTestCase : XCTestCase

@end

@implementation QCModelTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

-(void) testIDofTileAtXY {
    QCPlayingFieldModel *model = [[QCPlayingFieldModel alloc] initWithNumberOfRowsAndColumns:@9];
    NSNumber *testID1 = [model iDOfTileAtX:@0 Y:@0];
    XCTAssertEqual(testID1, @0, @"Testar om (0,0) har id 0");
    
    NSNumber *testID2 = [model iDOfTileAtX:@-1 Y:@0];
    XCTAssertNil(testID2, @"Testar om (-1, 0) är nil");
    
    NSNumber *testID3 = [model iDOfTileAtX:@8 Y:@8];
    XCTAssertEqual(testID3, @80, @"Testar om (0,0) har id 0");

    
}

-(void) testOfRemoveAndReturnVerticalTranslations {
    QCPlayingFieldModel *model = [[QCPlayingFieldModel alloc] initWithNumberOfRowsAndColumns:@9];
//    NSSet *set = [[NSSet alloc] initWithObjects:@3, @5, nil];
    XCTAssertNil([model removeAndReturnVerticalTranslations:nil], @"Assert returns nil when passed nil");
}
//
////-(void) testOfFindTilesAboveID {
////    QCPlayingFieldModel *model = [[QCPlayingFieldModel alloc] initWithNumberOfRowsAndColumns:@9];
////    NSNumber *ID = @18;
////    ////}

-(void) testOfTilesAreAdjacentID1ID2 {
    QCPlayingFieldModel *model = [[QCPlayingFieldModel alloc] initWithNumberOfRowsAndColumns:@5];
    XCTAssertTrue([model tilesAreAdjacentID1:@0 ID2:@1], @"Tiles 0 and 1 are adjacent");
    XCTAssertTrue([model tilesAreAdjacentID1:@3 ID2:@8], @"Tiles 3 and 8 are adjacent");
    XCTAssertTrue([model tilesAreAdjacentID1:@12 ID2:@11], @"Tiles 12 and 11 are adjacent");
    XCTAssertTrue([model tilesAreAdjacentID1:@14 ID2:@9], @"Tiles 14 and 9 are adjacent");
    XCTAssertFalse([model tilesAreAdjacentID1:@0 ID2:@6], @"Tiles 0 and 6 are not adjacent");
    XCTAssertFalse([model tilesAreAdjacentID1:@4 ID2:@5], @"Tiles 4 and 5 are not adjacent");
}


@end



