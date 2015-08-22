extern crate chrono;

use chrono::*;
use iter::date_iter;

mod iter;

fn main() {
    let start = Local.ymd(2015, 1, 1);
    let end = Local.ymd(2016, 1, 1);

    for date in date_iter(start, end) {
        println!("date = {}", date);
    }
}
