package Linksharing

import groovy.time.TimeCategory

class TimeCategoryTagLib {
    static namespace = "time"
    def getRelativeTime={attrs, body ->
        Date uploadDate = attrs.date
        use(TimeCategory){
            def now = new Date()
            def diff = now - uploadDate


            if(diff.days > 0) out << "${diff.days} days(s) ago"
            else if(diff.hours > 0) out << "${diff.hours} hour(s) ago"
            else if(diff.minutes > 0) out << "${diff.minutes} min ago"
            else out<< "Just now"
        }
    }
}