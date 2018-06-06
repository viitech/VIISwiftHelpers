//
//  Date.swift
//  Springring
//
//  Created by Abdulla Allaith on 31/07/2017.
//  Copyright © 2017 Springring. All rights reserved.
//


var newCalendar: Calendar {
    return Calendar(identifier: Calendar.Identifier.gregorian)
}

extension Date {
    
    enum DateFormLength: Int {
        case full = 0
        case short
        case veryShort
    }
    
    static func getWeekdayNames(_ length: DateFormLength, inEnglish: Bool = false) -> [String] {
        var calendar = newCalendar
        if (inEnglish) {
            calendar.locale = Locale(identifier: "en_US_POSIX")
        }
        
        switch length {
        case .full:
            return calendar.weekdaySymbols
        case .short:
            return calendar.shortWeekdaySymbols
        case .veryShort:
            return calendar.veryShortWeekdaySymbols
        }
    }
    
    static func getMonthNames(_ length: DateFormLength, inEnglish: Bool = false) -> [String] {
        var calendar = newCalendar
        if (inEnglish) {
            calendar.locale = Locale(identifier: "en_US_POSIX")
        }
        
        switch length {
        case .full:
            return calendar.monthSymbols
        case .short:
            return calendar.shortMonthSymbols
        case .veryShort:
            return calendar.veryShortMonthSymbols
        }
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarOptions: Calendar.MatchingPolicy {
            switch self {
            case .Next:
                return .nextTime
            case .Previous:
                return .previousTimePreservingSmallerComponents
            }
        }
    }
    
    static func getThisWeekDate(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> Date {
        let weekdaysName = getWeekdayNames(.full, inEnglish: true)
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let nextWeekDayIndex = weekdaysName.index(of: dayName)! + 2 // weekday is in form 1 ... 7 where as index is 0 ... 6
        
        var today = Date()
        
        switch direction {
        case .Next:
            today = today.endOfDay
        case .Previous:
            today = today.startOfDay
        }
        
        let calendar = newCalendar
        
        if consider && calendar.component(.weekday, from: today) == nextWeekDayIndex {
            return today
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        
        
        let date = calendar.nextDate(after: today, matching: nextDateComponent, matchingPolicy: direction.calendarOptions)
        return date!
    }
    
    var firstDayOfCurrentMonth: Date {
        let calendar = newCalendar
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    var lastDayOfCurrentMonth: Date {
        let calendar = newCalendar
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        return calendar.date(byAdding: comps2, to: self.firstDayOfCurrentMonth)!
    }
    
    func monthName() -> String {
        //Get Month Name
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM"
        let monthName = dayTimePeriodFormatter.string(from: self)
        
        //Return Month Name
        return monthName
    }
    
    func shortMonthName() -> String {
        // Return Short Month Name
        return self.withFormat("MMM")
    }
    
    func weekday() -> String {
        // Return Short Month Name
        return self.withFormat("EEEE")
    }
    
    func shortWeekday() -> String {
        // Return Short Month Name
        return self.withFormat("EEE")
    }
    
    
    func yearsFrom(_ date: Date) -> Int {
        return newCalendar.dateComponents([.year], from: date, to: self).year!
    }
    func monthsFrom(_ date: Date) -> Int {
        return newCalendar.dateComponents([.month], from: date, to: self).month!
    }
    func weeksFrom(_ date: Date) -> Int {
        return newCalendar.dateComponents([.weekOfYear], from: date, to: self).weekOfYear!
    }
    func daysFrom(_ date: Date) -> Int {
        return newCalendar.dateComponents([.day], from: date, to: self).day!
    }
    func hoursFrom(_ date: Date) -> Int {
        return newCalendar.dateComponents([.hour], from: date, to: self).hour!
    }
    func minutesFrom(_ date: Date) -> Int{
        return newCalendar.dateComponents([.minute], from: date, to: self).minute!
    }
    func secondsFrom(_ date: Date) -> Int{
        return newCalendar.dateComponents([.second], from: date, to: self).second!
    }
    func offsetFrom(date: Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    var startOfDay: Date {
        let calendar = newCalendar
        return calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let calendar = newCalendar
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfDay)!
    }
    
    func predicateFromDay(with: String) -> NSPredicate {
        let startDate = self.startOfDay
        let endDate = self.endOfDay
        
        return NSPredicate(format: "\(with) >= %@ AND \(with) =< %@", argumentArray: [startDate, endDate])
    }
    
    func withFormat(_ format: String) -> String {
        //Get Month Name
        let dayTimePeriodFormatter = Date.defaultFormatter()
        dayTimePeriodFormatter.dateFormat = format
        let returnDate = dayTimePeriodFormatter.string(from: self)
        
        //Return Month Name
        return returnDate
    }
    
    static func defaultFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    static func dateTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    var defaultDate: String {
        return withFormat("dd/MM/yyyy")
    }
    
    var boardHeaderDate: String {
        return withFormat("MMM. dd, yyyy")
    }
    
    var eventsHeaderDate: String {
        return withFormat("EEEE MMMM dd, yyyy")
    }
    
    var calendarViewTitleDate: String {
        return withFormat("MMMM yyyy")
    }
    
    var fileStoreDate: String {
        return withFormat("ssddMMyy")
    }
    
    var superShortDate: String {
        return withFormat("dd/MM")
    }
    
    var dayOnly: String {
        return withFormat("dd")
    }
    
    var defaultTime: String {
        return withFormat("hh:mm a")
    }
}

let DefaultFormat = "EEE MMM dd HH:mm:ss Z yyyy"

public enum TimeZones {
    case Local, UTC
}

public extension Date {
    
    // MARK: Intervals In Seconds
    private static func minuteInSeconds() -> Double { return 60 }
    private static func hourInSeconds() -> Double { return 3600 }
    private static func dayInSeconds() -> Double { return 86400 }
    private static func weekInSeconds() -> Double { return 604800 }
    private static func yearInSeconds() -> Double { return 31556926 }
    
    // MARK: Components
    
    private static func componentFlags() -> Set<Calendar.Component> { return [.year, .month, .day, .weekOfYear, .hour, .minute, .second, .weekday, .weekdayOrdinal, .weekOfYear] }
    
    private static func components(fromDate: Date) -> DateComponents! {
        return newCalendar.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    private func components() -> DateComponents {
        return Date.components(fromDate: self)!
    }
    
    // MARK: Date From String
    
    /**
     Creates a date based on a string and a formatter type. You can ise .ISO8601(nil) to for deducting an ISO8601Format automatically.
     
     - Parameter fromString Date string i.e. "16 July 1972 6:12:00".
     - Parameter format The Date Format string
     - Parameter timeZone: The time zone to interpret fromString can be .Local, .UTC applies to Custom format only
     
     - Returns A new date
     */
    
    init(fromString string: String, format:String)
    {
        if string.isEmpty {
            self.init()
            return
        }
        
        let formatter = Date.formatter(format: format)
        if let date = formatter.date(from: string as String) {
            self.init(timeInterval:0, since:date)
        } else {
            self.init()
        }
    }
    
//    func with(timeZone: TimeZones = .UTC) -> Date {
//        if (timeZone != TimeZones.UTC) {
//            let formatter = Date.formatter(timeZone: TimeZone.current)
//            let string = formatter.string(from: self)
//            if let date = formatter.date(from: string as String) {
//                print(date)
//                return date
//            } else {
//                return self
//            }
//        }
//        return self
//    }
    
    // MARK: Comparing Dates
    
    /**
     Returns true if dates are equal while ignoring time.
     
     - Parameter date: The Date to compare.
     */
    func isEqualToDateIgnoringTime(_ date: Date) -> Bool
    {
        
        let comp1 = Date.components(fromDate: self)!
        let comp2 = Date.components(fromDate: date)!
        return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
    }
    
    /**
     Returns Returns true if date is today.
     */
    func isToday() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Date())
    }
    
    /**
     Returns true if date is tomorrow.
     */
    func isTomorrow() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Date().dateByAddingDays(1))
    }
    
    /**
     Returns true if date is yesterday.
     */
    func isYesterday() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Date().dateBySubtractingDays(1))
    }
    
    /**
     Returns true if date are in the same week.
     
     - Parameter date: The date to compare.
     */
    func isSameWeekAsDate(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)!
        let comp2 = Date.components(fromDate: date)!
        // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
        if comp1.weekOfYear != comp2.weekOfYear {
            return false
        }
        // Must have a time interval under 1 week
        return abs(self.timeIntervalSince(date)) < Date.weekInSeconds()
    }
    
    /**
     Returns true if date is this week.
     */
    func isThisWeek() -> Bool
    {
        return self.isSameWeekAsDate(Date())
    }
    
    /**
     Returns true if date is next week.
     */
    func isNextWeek() -> Bool
    {
        let interval: TimeInterval = Date().timeIntervalSinceReferenceDate + Date.weekInSeconds()
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }
    
    /**
     Returns true if date is last week.
     */
    func isLastWeek() -> Bool
    {
        let interval: TimeInterval = Date().timeIntervalSinceReferenceDate - Date.weekInSeconds()
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }
    
    /**
     Returns true if dates are in the same year.
     
     - Parameter date: The date to compare.
     */
    func isSameYearAsDate(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)!
        let comp2 = Date.components(fromDate: date)!
        return comp1.year == comp2.year
    }
    
    /**
     Returns true if dates are in the same month
     
     - Parameter date: The date to compare
     */
    func isSameMonthAsDate(date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)!
        let comp2 = Date.components(fromDate: date)!
        
        return comp1.year == comp2.year && comp1.month == comp2.month
    }
    
    /**
     Returns true if date is this year.
     */
    func isThisYear() -> Bool
    {
        return self.isSameYearAsDate(Date())
    }
    
    /**
     Returns true if date is next year.
     */
    func isNextYear() -> Bool
    {
        let comp1 = Date.components(fromDate: self)!
        let comp2 = Date.components(fromDate: Date())!
        return (comp1.year == comp2.year! + 1)
    }
    
    /**
     Returns true if date is last year.
     */
    func isLastYear() -> Bool
    {
        let comp1 = Date.components(fromDate: self)!
        let comp2 = Date.components(fromDate: Date())!
        return (comp1.year == comp2.year! - 1)
    }
    
    /**
     Returns true if date is earlier than date.
     
     - Parameter date: The date to compare.
     */
    func isEarlierThanDate(_ date: Date) -> Bool
    {
        return self < date
    }
    
    /**
     Returns true if date is later than date.
     
     - Parameter date: The date to compare.
     */
    func isLaterThanDate(_ date: Date) -> Bool
    {
        return self > date
    }
    
    /**
     Returns true if date is in future.
     */
    func isInFuture() -> Bool
    {
        return self.isLaterThanDate(Date())
    }
    
    /**
     Returns true if date is in past.
     */
    func isInPast() -> Bool
    {
        return self.isEarlierThanDate(Date())
    }
    
    
    // MARK: Adjusting Dates
    
    /**
     Creates a new date by a adding months.
     
     - Parameter days: The number of months to add.
     - Returns A new date object.
     */
    func dateByAddingMonths(_ months: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.month = months
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by a substracting months.
     
     - Parameter days: The number of months to substract.
     - Returns A new date object.
     */
    func dateBySubtractingMonths(_ months: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.month = (months * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by a adding weeks.
     
     - Parameter days: The number of weeks to add.
     - Returns A new date object.
     */
    func dateByAddingWeeks(_ weeks: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = 7 * weeks
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by a substracting weeks.
     
     - Parameter days: The number of weeks to substract.
     - Returns A new date object.
     */
    func dateBySubtractingWeeks(_ weeks: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = ((7 * weeks) * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by a adding days.
     
     - Parameter days: The number of days to add.
     - Returns A new date object.
     */
    func dateByAddingDays(_ days: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = days
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by a substracting days.
     
     - Parameter days: The number of days to substract.
     - Returns A new date object.
     */
    func dateBySubtractingDays(_ days: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = (days * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by a adding hours.
     
     - Parameter days: The number of hours to add.
     - Returns A new date object.
     */
    func dateByAddingHours(_ hours: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.hour = hours
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by substracting hours.
     
     - Parameter days: The number of hours to substract.
     - Returns A new date object.
     */
    func dateBySubtractingHours(_ hours: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.hour = (hours * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by adding minutes.
     
     - Parameter days: The number of minutes to add.
     - Returns A new date object.
     */
    func dateByAddingMinutes(_ minutes: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.minute = minutes
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by substracting minutes.
     
     - Parameter days: The number of minutes to add.
     - Returns A new date object.
     */
    func dateBySubtractingMinutes(_ minutes: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.minute = (minutes * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by adding seconds.
     
     - Parameter seconds: The number of seconds to add.
     - Returns A new date object.
     */
    func dateByAddingSeconds(_ seconds: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.second = seconds
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by substracting seconds.
     
     - Parameter seconds: The number of seconds to substract.
     - Returns A new date object.
     */
    func dateBySubtractingSeconds(_ seconds: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.second = (seconds * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by adding years.
     
     - Parameter years: The number of years to add.
     - Returns A new date object.
     */
    func dateByAddingYears(_ years: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.year = years
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date by substracting years.
     
     - Parameter years: The number of years to substract.
     - Returns A new date object.
     */
    func dateBySubtractingYears(_ years: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.year = (years * -1)
        return newCalendar.date(byAdding: dateComp, to: self)!
    }
    
    /**
     Creates a new date from the start of the day.
     
     - Returns A new date object.
     */
    func dateAtStartOfDay() -> Date
    {
        return self.startOfDay
    }
    
    /**
     Creates a new date from the end of the day.
     
     - Returns A new date object.
     */
    func dateAtEndOfDay() -> Date
    {
        return self.endOfDay
    }
    
    /**
     Creates a new date from the start of the week.
     
     - Returns A new date object.
     */
    func dateAtStartOfWeek() -> Date
    {
        var components = self.components()
        components.weekday = newCalendar.firstWeekday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return newCalendar.date(from: components)!
    }
    
    /**
     Creates a new date from the end of the week.
     
     - Returns A new date object.
     */
    func dateAtEndOfWeek() -> Date
    {
        var components = self.components()
        components.weekday = newCalendar.firstWeekday + 6
        components.hour = 0
        components.minute = 0
        components.second = 0
        return newCalendar.date(from: components)!
    }
    
    /**
     Creates a new date from the first day of the month
     
     - Returns A new date object.
     */
    func dateAtTheStartOfMonth() -> Date
    {
        //Create the date components
        var components = self.components()
        components.day = 1
        //Builds the first day of the month
        let firstDayOfMonthDate: Date = newCalendar.date(from: components)!
        
        return firstDayOfMonthDate
        
    }
    
    /**
     Creates a new date from the last day of the month
     
     - Returns A new date object.
     */
    func dateAtTheEndOfMonth() -> Date {
        
        //Create the date components
        var components = self.components()
        //Set the last day of this month
        components.month = components.month! + 1
        components.day = 0
        
        //Builds the first day of the month
        let lastDayOfMonth :Date = newCalendar.date(from: components)!
        
        return lastDayOfMonth
        
    }
    
    /**
     Creates a new date based on tomorrow.
     
     - Returns A new date object.
     */
    static func tomorrow() -> Date
    {
        return Date().dateByAddingDays(1).dateAtStartOfDay()
    }
    
    static func tomorrowStart() -> Date
    {
        return Date().dateByAddingDays(1).dateAtStartOfDay()
    }
    
    static func tomorrowEnd() -> Date
    {
        return Date().dateByAddingDays(1).dateAtEndOfDay()
    }
    
    /**
     Creates a new date based on yesterdat.
     
     - Returns A new date object.
     */
    static func yesterday() -> Date
    {
        return Date().dateBySubtractingDays(1).dateAtStartOfDay()
    }
    
    /**
     Return a new Date object with the new hour, minute and seconds values
     
     :returns: Date
     */
    func setTimeOfDate(hour: Int, minute: Int, second: Int) -> Date {
        var components = self.components()
        components.hour = hour
        components.minute = minute
        components.second = second
        return newCalendar.date(from: components)!
    }
    
    
    // MARK: Retrieving Intervals
    
    /**
     Gets the number of seconds after a date.
     
     - Parameter date: the date to compare.
     - Returns The number of seconds
     */
    func secondsAfterDate(date: Date) -> Int
    {
        return Int(self.timeIntervalSince(date))
    }
    
    /**
     Gets the number of seconds before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of seconds
     */
    func secondsBeforeDate(date: Date) -> Int
    {
        return Int(date.timeIntervalSince(self))
    }
    
    /**
     Gets the number of minutes after a date.
     
     - Parameter date: the date to compare.
     - Returns The number of minutes
     */
    func minutesAfterDate(date: Date) -> Int
    {
        let interval = self.timeIntervalSince(date)
        return Int(interval / Date.minuteInSeconds())
    }
    
    /**
     Gets the number of minutes before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of minutes
     */
    func minutesBeforeDate(date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.minuteInSeconds())
    }
    
    /**
     Gets the number of hours after a date.
     
     - Parameter date: The date to compare.
     - Returns The number of hours
     */
    func hoursAfterDate(date: Date) -> Int
    {
        let interval = self.timeIntervalSince(date)
        return Int(interval / Date.hourInSeconds())
    }
    
    /**
     Gets the number of hours before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of hours
     */
    func hoursBeforeDate(date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.hourInSeconds())
    }
    
    /**
     Gets the number of days after a date.
     
     - Parameter date: The date to compare.
     - Returns The number of days
     */
    func daysAfterDate(date: Date) -> Int
    {
        let interval = self.timeIntervalSince(date)
        return Int(interval / Date.dayInSeconds())
    }
    
    /**
     Gets the number of days before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of days
     */
    func daysBeforeDate(date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.dayInSeconds())
    }
    
    
    // MARK: Decomposing Dates
    
    /**
     Returns the nearest hour.
     */
    func nearestHour () -> Int {
        let halfHour = Date.minuteInSeconds() * 30
        var interval = self.timeIntervalSinceReferenceDate
        if  self.seconds() < 30 {
            interval -= halfHour
        } else {
            interval += halfHour
        }
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return date.hour()
    }
    /**
     Returns the year component.
     */
    func year () -> Int { return self.components().year!  }
    /**
     Returns the month component.
     */
    func month () -> Int { return self.components().month! }
    /**
     Returns the week of year component.
     */
    func week () -> Int { return self.components().weekOfYear! }
    /**
     Returns the day component.
     */
    func day () -> Int { return self.components().day! }
    /**
     Returns the hour component.
     */
    func hour () -> Int { return self.components().hour! }
    /**
     Returns the minute component.
     */
    func minute () -> Int { return self.components().minute! }
    /**
     Returns the seconds component.
     */
    func seconds () -> Int { return self.components().second! }
    /**
     Returns the weekday component.
     */
    func weekday () -> Int { return self.components().weekday! }
    /**
     Returns the nth days component. e.g. 2nd Tuesday of the month is 2.
     */
    func nthWeekday () -> Int { return self.components().weekdayOrdinal! }
    /**
     Returns the days of the month.
     */
    func monthDays () -> Int { return newCalendar.range(of: .day, in: .month, for: self)!.count }
    /**
     Returns the first day of the week.
     */
    func firstDayOfWeek () -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds() * Double(self.components().weekday! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).day()
    }
    /**
     Returns the last day of the week.
     */
    func lastDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds() * Double(self.components().weekday! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds() * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).day()
    }
    /**
     Returns true if a weekday.
     */
    func isWeekday() -> Bool {
        return !self.isWeekend()
    }
    /**
     Returns true if weekend.
     */
    func isWeekend() -> Bool {
        let range = newCalendar.maximumRange(of: .weekday)!
        return (self.weekday() == range.count-1 || self.weekday() == range.count)
    }
    
    
    // MARK: To String
    
    /**
     A string representation using short date and time style.
     */
    func toString() -> String {
        return self.toString(dateStyle: .short, timeStyle: .short, doesRelativeDateFormatting: false)
    }
    
    /**
     A string representation based on a format.
     
     - Parameter format: The format of date string.
     - Parameter timeZone: The time zone to interpret the date can be .Local, .UTC applies to Custom format only
     - Returns The date string representation
     */
    func toString(format: String, timeZone: TimeZones = .Local) -> String
    {
        var zone = TimeZone.current
        
        if (timeZone == .UTC) {
            zone = TimeZone(secondsFromGMT: 0)!
        }
        
        let formatter = Date.formatter(format: format, timeZone: zone)
        return formatter.string(from:self)
    }
    
    /**
     A string representation based on custom style.
     
     - Parameter dateStyle: The date style to use.
     - Parameter timeStyle: The time style to use.
     - Parameter doesRelativeDateFormatting: Enables relative date formatting.
     - Parameter timeZone: The time zone to use.
     - Parameter locale: The locale to use.
     - Returns A string representation of the date.
     */
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> String
    {
        let formatter = Date.formatter(dateStyle: dateStyle, timeStyle: timeStyle, doesRelativeDateFormatting: doesRelativeDateFormatting, timeZone: timeZone, locale: locale)
        return formatter.string(from:self)
    }
    
    /**
     A string representation based on a relative time language. i.e. just now, 1 minute ago etc..
     */
    func relativeTimeToString() -> String
    {
        let time = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        
        let timeIsInPast = now - time > 0
        
        let seconds = abs(now - time)
        let minutes = round(seconds/60)
        let hours = round(minutes/60)
        let days = round(hours/24)
        
        func describe(_ time: String) -> String {
            if timeIsInPast { return "\(time) ago" }
            else { return "in \(time)" }
        }
        
        if seconds < 10 {
            return NSLocalizedString("just now", comment: "Show the relative time from a date")
        } else if seconds < 60 {
            let relativeTime = NSLocalizedString(describe("%.f seconds"), comment: "Show the relative time from a date")
            return String(format: relativeTime, seconds)
        }
        
        if minutes < 60 {
            if minutes == 1 {
                return NSLocalizedString(describe("1 minute"), comment: "Show the relative time from a date")
            } else {
                let relativeTime = NSLocalizedString(describe("%.f minutes"), comment: "Show the relative time from a date")
                return String(format: relativeTime, minutes)
            }
        }
        
        if hours < 24 {
            if hours == 1 {
                return NSLocalizedString(describe("1 hour"), comment: "Show the relative time from a date")
            } else {
                let relativeTime = NSLocalizedString(describe("%.f hours"), comment: "Show the relative time from a date")
                return String(format: relativeTime, hours)
            }
        }
        
        if days < 7 {
            if days == 1 {
                return NSLocalizedString(describe("1 day"), comment: "Show the relative time from a date")
            } else {
                let relativeTime = NSLocalizedString(describe("%.f days"), comment: "Show the relative time from a date")
                return String(format: relativeTime, days)
            }
        }
        
        return self.toString()
    }
    
    /**
     A string representation of the weekday.
     */
    func weekdayToString() -> String {
        let formatter = Date.formatter()
        return formatter.weekdaySymbols[self.weekday()-1] as String
    }
    
    /**
     A short string representation of the weekday.
     */
    func shortWeekdayToString() -> String {
        let formatter = Date.formatter()
        return formatter.shortWeekdaySymbols[self.weekday()-1] as String
    }
    
    /**
     A very short string representation of the weekday.
     
     - Returns String
     */
    func veryShortWeekdayToString() -> String {
        let formatter = Date.formatter()
        return formatter.veryShortWeekdaySymbols[self.weekday()-1] as String
    }
    
    /**
     A string representation of the month.
     
     - Returns String
     */
    func monthToString() -> String {
        let formatter = Date.formatter()
        return formatter.monthSymbols[self.month()-1] as String
    }
    
    /**
     A short string representation of the month.
     
     - Returns String
     */
    func shortMonthToString() -> String {
        let formatter = Date.formatter()
        return formatter.shortMonthSymbols[self.month()-1] as String
    }
    
    /**
     A very short string representation of the month.
     
     - Returns String
     */
    func veryShortMonthToString() -> String {
        let formatter = Date.formatter()
        return formatter.veryShortMonthSymbols[self.month()-1] as String
    }
    
    
    // MARK: Static Cached Formatters
    
    /**
     Returns a cached static array of DateFormatters so that thy are only created once.
     */
    private static let sharedDateFormatters = [String: DateFormatter]()
    
    /**
     Returns a cached formatter based on the format, timeZone and locale. Formatters are cached in a singleton array using hashkeys generated by format, timeZone and locale.
     
     - Parameter format: The format to use.
     - Parameter timeZone: The time zone to use, defaults to the local time zone.
     - Parameter locale: The locale to use, defaults to the current locale
     - Returns The date formatter.
     */
    private static func formatter(format:String = DefaultFormat, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        var formatters = Date.sharedDateFormatters
        if let cachedDateFormatter = formatters[hashKey] {
            return cachedDateFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatters[hashKey] = formatter
            return formatter
        }
    }
    
    /**
     Returns a cached formatter based on date style, time style and relative date. Formatters are cached in a singleton array using hashkeys generated by date style, time style, relative date, timeZone and locale.
     
     - Parameter dateStyle: The date style to use.
     - Parameter timeStyle: The time style to use.
     - Parameter doesRelativeDateFormatting: Enables relative date formatting.
     - Parameter timeZone: The time zone to use.
     - Parameter locale: The locale to use.
     - Returns The date formatter.
     */
    private static func formatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: TimeZone = TimeZone.current, locale: Locale = Locale.current) -> DateFormatter {
        var formatters = Date.sharedDateFormatters
        let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if let cachedDateFormatter = formatters[hashKey] {
            return cachedDateFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatters[hashKey] = formatter
            return formatter
        }
    }
    
    
    
}
