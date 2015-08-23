use chrono::*;
use std::iter::Iterator;

pub fn date_iter<T>(start: Date<T>, end: Date<T>) -> DateIterator<T> where T: TimeZone {
    DateIterator {
        start: start,
        end: end
    }
}

pub struct DateIterator<T> where T: TimeZone {
    start: Date<T>,
    end: Date<T>
}

impl<T> Iterator for DateIterator<T> where T: TimeZone {
    type Item = Date<T>;

    fn next(&mut self) -> Option<Date<T>> {
        let next = self.start.succ();

        if next >= self.end {
            None
        } else {
            self.start = next;

            Some(self.start.clone())
        }
    }
}
