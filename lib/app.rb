require 'json'
require 'artii'
# Get path to products.json, read the file into a string,
# and transform the string into a usable hash

def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
end


#This creates the .txt file
def create_report
	print_ASCII("Sales Report")  
	print_date
	products_section
	

end





# Print headings in ascii art

def print_ASCII(text)
	a = Artii::Base.new
	puts a.asciify(text)
	$report_file.puts a.asciify(text)
end




# Print today's date
def print_date
	time = Time.now.strftime("%d/%m/%Y")
	$report_file.puts time
end


# Print "Products" in ascii art
def products_section
	print_ASCII("Products")
	products
end


# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

def products
	$products_hash["items"].each do |item|
	items_data(item)
	$report_file.puts puts "----------------------------------------------"
 end
end

def items_data(item)

	$report_file.puts "item #{item["title"]}"
	
	retail_price = retail_price_method(item)

end


# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined





def start
  setup_files # load, read, parse, and create the files
  create_report
end

start

