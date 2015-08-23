require 'date'
require 'slop'

class Year
  include Enumerable
  attr_reader :year

  def initialize(year, endless)
    @year = year
    @endless = endless
  end

  def each
    return enum_for(:each) unless block_given?

    date = Date.new(year, 1, 1)

    while @endless || year == date.year
      Year.increment_counter

      yield date
      date += 1
    end
  end

  def self.increment_counter
    @@counter ||= 0
    @@counter += 1
  end

  def self.counter
    @@counter
  end
end

def dates(opts)
  Year.new(opts[:year], opts[:endless]).lazy
end

def by_months(year)
  year.chunk { |x| x.month }.map { |x| x.last }
end

def month_by_weeks(year)
  year.map { |month| month.chunk { |d| d.cweek }.map { |x| x.last } }
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

def layout_months(year)
  year.map { |month| layout_month(month) }
end

opts = Slop.parse do |o|
  o.integer '--months', '-m', 'number of columns', default: 3
  o.integer '--year', '-y', 'year', default: Date.today.year
  o.bool '--endless', '-e', 'endless output'
  o.bool '--help', '-h', 'prints help'
end

if opts[:help]
  puts opts
  exit
end

year = dates(opts)
year = by_months(year)
year = month_by_weeks(year)
year = layout_months(year)
year = year.each_slice(opts[:months])
year = year.map { |combined_months| combined_months.transpose }
year = year.map { |combined_months| combined_months.map { |line| line.join } }

for line in year
  puts line
end

puts

p Year.counter
