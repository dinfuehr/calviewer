require 'date'

def dates_in_year(year)
    (Date.new(year, 1, 1) ... Date.new(year+1, 1, 1)).each
end

def by_months(array)
  array.group_by(&:month).values
end

def months_by_week(months)
  months.map { |m| m.group_by(&:cweek).values }
end

def format_day(d)
  "%3d" % d.day
end

def format_week(w)
  wday = w.first.cwday - 1
  padding = " " * (wday * 3)
  days = w.map { |d| format_day(d) }.join

  text = "%s%s" % [padding, days]
  "%-22s" % text
end

def month_title(d)
  name = d.strftime("%B")
  length = name.length + (22 - name.length)/2

  text = "%#{length}s" % name
  "%-22s" % text
end

def layout_month(m)
  wcount = m.count
  padding_line = " " * 22
  padding = Array.new(6 - wcount, padding_line)

  [month_title(m.first.first)] + m.map { |w| format_week(w) } + padding
end

year = months_by_week(by_months(dates_in_year(2015))).map { |m| layout_month(m) }

for three_months in year.each_slice(3)
  for line in three_months.transpose
    puts line.join
  end
end
