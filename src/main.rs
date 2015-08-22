extern crate chrono;
extern crate itertools;

use chrono::*;
use iter::*;
use itertools::Itertools;

mod iter;

fn main() {
    let year = dates_in_year(2015);
    let months = year.group_by_lazy(|d| d.month());

    for (month, dates) in months.into_iter() {
        println!("group {} with {} dates", month, dates.into_iter().count());
    }
}

fn dates_in_year(year: i32) -> DateIterator<Local> {
    let start = Local.ymd(year, 1, 1);
    let end = Local.ymd(year+1, 1, 1);

    date_iter(start, end)
}
