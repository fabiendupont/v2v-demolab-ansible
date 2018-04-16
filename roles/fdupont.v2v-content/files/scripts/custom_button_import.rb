class ImportArInstances
  DEBUG_MODE = true

  def self.import(obj_hash)
    new.import(obj_hash)
  end

  def import(obj_hash)
    ActiveRecord::Base.transaction { obj_hash.each { |obj_def| create_object(*obj_def) } }
  end

  def create_object(class_name, obj_array)
    klass = class_name.camelize.constantize

    obj_array.collect do |obj|
      create_unique_values(obj) if DEBUG_MODE

      begin
        klass.create!(obj['attributes'].except('guid')).tap do |new_obj|
          if obj['has_many'].present?
            obj['has_many'].each do |hmo|
              new_obj.add_members(create_object(*hmo))
            end
          end

          if obj['has_one'].present?
            obj['has_one'].each do |hoo|
              new_obj.send("#{hoo.first}=", create_object(*hoo).first)
            end
          end

          try("#{class_name}_post", new_obj)
        end
      rescue StandardError
        puts "Failed to create new instance [#{class_name}] with attributes #{obj['attributes'].inspect}"
        raise
      end
    end
  end

  def custom_button_set_post(new_obj)
    new_obj.set_data[:button_order] = new_obj.custom_buttons.collect(&:id)
    new_obj.save!
  end

  def create_unique_values(obj)
    %w(name description).each do |attr_name|
      attr_value = obj.dig('attributes', attr_name)
      obj.store_path('attributes', attr_name, "#{attr_value} #{Time.zone.now}") if attr_value.present?
    end
  end
end

ImportArInstances.import(YAML.load_file(ARGV[0]))
