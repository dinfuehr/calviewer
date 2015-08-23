extern crate chrono;
extern crate itertools;

use chrono::*;
use iter::*;
use itertools::*;

mod iter;

fn main() {
    let year = dates_in_year(2015);
    let months = year.group_by_lazy(|d| d.month());
    let months_by_weeks = months.into_iter().map(|(_, days)| {
        days.group_by_lazy(|d| d.isoweekdate().1)
    });

    for month in months_by_weeks {
        for (week, days) in month.into_iter() {
            println!("wday = {}, # days = {}", week, days.into_iter().count());
        }
    }
}

fn dates_in_year(year: i32) -> DateIterator<Local> {
    let start = Local.ymd(year, 1, 1);
    let end = Local.ymd(year+1, 1, 1);

    date_iter(start, end)
}
