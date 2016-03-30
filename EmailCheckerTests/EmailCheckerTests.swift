import XCTest
import EmailChecker

class EmailCheckerTests: XCTestCase {
    func testSuggestions() {
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@mop.com"), "hello@mop.com")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@gmail.com"), "hello@gmail.com")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello"), "hello")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@"), "hello@")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("@"), "@")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection(""), "")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("@hello"), "@hello")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("@hello.com"), "@hello.com")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("kikoo@gmail.com"), "kikoo@gmail.com")
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("kikoo@azdoij.cm"), "kikoo@azdoij.cm")

        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@gmial.com"), "hello@gmail.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@gmai.com"), "hello@gmail.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@yohoo.com"), "hello@yahoo.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@yhoo.com"), "hello@yahoo.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@ayhoo.com"), "hello@yahoo.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@yhoo.com"), "hello@yahoo.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@outloo.com"), "hello@outlook.com");
        XCTAssertEqual(EmailChecker.suggestDomainCorrection("hello@comcats.com"), "hello@comcast.com");
    }
}
