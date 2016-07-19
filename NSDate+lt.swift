import Foundation

func <(lhs: NSDate, rhs: NSDate) -> Bool
{
    let earlier = lhs.earlierDate(rhs)
    return earlier == lhs
}