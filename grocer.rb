require 'pry'
def consolidate_cart(cart)
  cart_hash = {}
  count = 0 
  cart.map do |element|
  element.each do |fruit,hash|
  cart_hash[fruit] ||= hash
  cart_hash[fruit][:count] ||= 0
  cart_hash[fruit][:count] += 1
  end
 end
 cart_hash
end

def apply_coupons(cart, coupons)
 coupons.each do |coupon|
   item = coupon[:item]
   if cart[item]
    if cart[item] && cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
      cart["#{item} W/COUPON"] = {price: coupon[:cost]/coupon[:num], clearance: cart[item][:clearance], count:coupon[:num]} 
       cart[item][:count] -= coupon[:num] 
    elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
      cart["#{item} W/COUPON"][:count] += coupon[:num]
      cart[item][:count] -= coupon[:num]
    end 
  end
  end
  cart
end  

def apply_clearance(cart)
  cart.map do |product_name, stats|
    stats[:price] -= stats[:price] * 0.2 if stats[:clearance]
  end
  cart
end

def checkout(cart,coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart,coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) {|acc, (key,value)| acc += value[:price]*value[:count]}
    total > 100 ? total * 0.9 : total
end
