require 'csv'

csv_text = <<~CSV
  id,phone
  1,0702233344
  2,012
  3,098
CSV

csv_rows = CSV.parse(csv_text, headers: true, converters: :integer)

csv_rows.each do |row|
  puts "Phone: #{row['phone']} (#{row['phone'].class})"
end
