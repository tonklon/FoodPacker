# encoding: UTF-8
class Box < ActiveRecord::Base

  has_and_belongs_to_many :meals
  has_many :group_boxes

  def build_calculated_box_for_group(group)
    group_box = group_boxes.build(group: group)
    GroupMeal.find_each(conditions:{group_id: group.id, meal_id: meal_ids}, :include => [{:receipt => {:ingredients => :product}}, :meal]) do |group_meal|
      
      group_box_meal = group_box.group_box_meals.build(meal:group_meal.meal)
      receipt = group_meal.receipt
      
      group_box_meal.participants_count = group_meal.meal_participants_count
      group_box_meal.receipt_name = receipt.name
      
      hunger_factor = group_meal.meal_hunger_factor
      
      group_box_meal.build_contents_from_ingredients_hunger_factor receipt.ingredients, hunger_factor
    end
    
    special_meal = nil
    Special.find_each(conditions:{group_id:group.id, box_id:self.id}) do |special|
      if special_meal == nil
        special_meal = group_box.group_box_meals.build(meal_id:999999,receipt_name:"Sonderwünsche",participants_count:group.participants_count)
      end
      special_meal.contents.build(product_id: special.product_id,quantity: special.quantity)
    end
    
    group_box
  end
  
  def build_calculated_boxes
    GroupMeal.find_each(conditions:{meal_id: meal_ids}, :include => [{:receipt => {:ingredients => :product}}, :meal]) do |group_meal|
      
      group_box = group_boxes.each do |group_box|
        break group_box if group_box.group == group_meal.group
      end
      group_box = nil if group_box.kind_of?(Array)

      group_box = group_boxes.build(group: group_meal.group) if group_box.nil?
      group_box_meal = group_box.group_box_meals.build(meal:group_meal.meal)
      receipt = group_meal.receipt
    
      group_box_meal.participants_count = group_meal.meal_participants_count
      group_box_meal.receipt_name = receipt.name
    
      hunger_factor = group_meal.meal_hunger_factor
    
      group_box_meal.build_contents_from_ingredients_hunger_factor receipt.ingredients, hunger_factor
    end
    group_boxes.each do |group_box|
      special_meal = nil
      Special.find_each(conditions:{group_id:group_box.group.id, box_id:self.id}) do |special|
        if special_meal == nil
          special_meal = group_box.group_box_meals.build(meal_id:999999,receipt_name:"Sonderwünsche",participants_count:group_box.group.participants_count)
        end
        special_meal.contents.build(product_id: special.product_id,quantity: special.quantity)
      end
    end
  end
  
  def create_calculated_boxes
    transaction do
      group_boxes = build_calculated_boxes
      group_boxes.each do |group_box|
        group_box.save!
      end
    end
  end
  
  def name_with_date
    name + " (" + I18n.l(start_time) + ")"
  end

end
