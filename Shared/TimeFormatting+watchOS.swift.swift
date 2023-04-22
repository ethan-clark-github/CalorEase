import Foundation

func calcTimeSince(date: Date) -> String {
    let now = Date()
    let components = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
    
    if let day = components.day, day > 0 {
        return day == 1 ? "\(day) day ago" : "\(day) days ago"
    } else if let hour = components.hour, hour > 0 {
        return hour == 1 ? "\(hour) hour ago" : "\(hour) hours ago"
    } else if let minute = components.minute, minute > 0 {
        return minute == 1 ? "\(minute) min ago" : "\(minute) mins ago"
    } else if let second = components.second, second > 0 {
        return second == 1 ? "\(second) sec ago" : "\(second) secs ago"
    } else {
        return "Just now"
    }
}
