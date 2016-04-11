require 'json'
require 'artii'
# Get path to products.json, read the file into a string,
# and transform the string into a usable hash

def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    
end



#This creates the .txt file

def create_report
	print_ASCII("Sales Report")  
	print_date
	products_section
	make_brand	

end





# Print headings in ascii art

def print_ASCII(text)
	a = Artii::Base.new
	puts a.asciify(text)
	report_file_puts a.asciify(text)
end




# Print today's date
def print_date
	time = Time.now.strftime("%d/%m/%Y")
	report_file_puts time
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
	report_file_puts "----------------------------------------------"
 end
end

def items_data(item)

		
	

	report_file_puts "item #{item["title"]}"
	
	retail_price = retail_price_method(item)

	total_sales = total_sales_method(item)

	total_revenue = total_revenue_method(item)

	avg_purch_price = avg_purch_price_method(total_revenue, total_sales)

	avg_discount_method(retail_price, avg_purch_price)



end

def retail_price_method(item)

	retail_price = item["full-price"]

	report_file_puts "Retails price: $#{retail_price}"

	return retail_price
end

def total_sales_method(item)

	total_sales = item["purchases"].length 

	report_file_puts  "Total number of sales: #{total_sales}"

	return total_sales
end

def total_revenue_method(item)

	total_revenue = 0

	item["purchases"].each do |purchase|
		
		total_revenue += purchase["price"].to_f
	end

	report_file_puts "Total amount of revenue from sales: $#{total_revenue.to_s}" 

	return total_revenue
end

def avg_purch_price_method(total_revenue, total_sales)

	avg_purch_price = (total_revenue.to_f / total_sales.to_f)

	report_file_puts  "Average sale price: $#{avg_purch_price}"

	return avg_purch_price
end

def avg_discount_method(retail_price, avg_purch_price)

	avg_discount = (retail_price.to_f - avg_purch_price.to_f)

	report_file_puts  "Average discount is $#{avg_discount.round(2)}"

end


# Print "Brands" in ascii art

def make_brand
	print_ASCII("Brands")
	brands
end

def brands

	unique_brands = $products_hash["items"].map { |item| item["brand"] }.uniq 

	unique_brands.each_with_index do | brand, index |  
        brand_data(brand)
        report_file_puts "-----------------------------------------------------"
  end
end




# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

def brand_data(brand)
	
	report_file_puts "Brand: #{brand}"
	brands_items_iterated = brands_items_iterated_method(brand)
	items_from_this_brand = items_from_this_brand_method(brands_items_iterated)
	items_in_stock_from_brand_method(brands_items_iterated)
	avg_price_items_brand_method(brands_items_iterated, items_from_this_brand)
	brand_revenue_amount_method(brands_items_iterated)
end

def brands_items_iterated_method(brand)
	brands_items_iterated = $products_hash["items"].select { |item| item["brand"] == brand }

	return brands_items_iterated
end

def items_from_this_brand_method(brands_items_iterated) 
  #calculates number of items per brand (not stock amount of those items)
  items_from_this_brand = brands_items_iterated.length 
  #prints number of items sold by this brand 
  report_file_puts "Number of items we sell from this brand: #{items_from_this_brand}" 
  #returns items per brand variable 
  return items_from_this_brand 
end
	
def items_in_stock_from_brand_method(brands_items_iterated) 
  #initializes items in stock variable 
  items_in_stock_from_brand = 0 
  #calculates number of items in stock 
  brands_items_iterated.each {|item| items_in_stock_from_brand += item["stock"].to_f} 
  #prints number of items in stock for this brand 
  report_file_puts "Total number of items in stock from this brand: #{items_in_stock_from_brand.to_i}"
  #returns items in stock variable
  return items_in_stock_from_brand 
end

def avg_price_items_brand_method(brands_items_iterated, items_from_this_brand)
#initializes total price of brand's items  
  brand_total_revenue_amount = 0 
  #iterates the price of each item 
  brands_items_iterated.each {|item| brand_total_revenue_amount += item["full-price"].to_f} 
  #calculates average price of brand's items 
  avg_price_items_brand = brand_total_revenue_amount / items_from_this_brand 
  #prints average price of brand's items
  report_file_puts "Average price of items we sell by this brand: $#{avg_price_items_brand.round(2)}" 
  #returns avg price of items per brand variable
  return avg_price_items_brand  
end

def brand_revenue_amount_method(brands_items_iterated)  
  #initializes brand's item sales amount
  brand_revenue_amount = 0  
  #iterates each item
  brands_items_iterated.each do |item|  
    #iterates each sale
    item["purchases"].each do |el|  
      #counts total price of sales 
      brand_revenue_amount += el["price"].to_f 
    end
  end
  #prints total revenue
  report_file_puts "Total revenue of all sales for this brand: $#{brand_revenue_amount.round(2)}" 
  #returns revenue amount for each brand variable 
  return brand_revenue_amount 
end


def start
  setup_files # load, read, parse, and create the files
  create_report
end

def report_file_puts(line)

	File.open("../report.txt", "a") do |file|
		file.puts line
	end
end


start

