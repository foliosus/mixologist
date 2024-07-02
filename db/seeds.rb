keys = ["units", "ingredient_categories", "ingredients", "garnishes", "cocktails"]

raw_records_path = Rails.root / "db" / "cocktails.json"
puts "** Loading cocktails and supporting data from #{raw_records_path}"
raw_records = JSON.load_file(raw_records_path.to_s)
puts "   parsed the file"
keys.each do |key|
  puts "   found #{raw_records[key].length} #{key}"
end

Cocktail.transaction do
  saved_records = {}
  unsaved_records = {}

  keys.each do |key|
    puts "** Creating #{key}"
    klass = key.classify.constantize # "ingredient_categories" => IngredientCategory
    saved_records[key] = []
    unsaved_records[key] = []
    raw_records[key].each do |datum|
      datum.symbolize_keys!
      record = klass.import_from_hash(datum)
      if record.persisted? && !record.changed?
        saved_records[key] << record
      else
        unsaved_records[key] << record
      end
    end
  end

  if unsaved_records.all?{|k,v| v.blank? }
    keys.each do |key|
      puts "   saved #{saved_records[key].length} #{key}"
    end
  else
    puts "** Couldn't save all of the records! The #{unsaved_records.length} problems:"
    puts unsaved_records.inspect
    keys.each do |key|
      unsaved_records[key].each do |record|
        puts record.inspect
        puts record.errors.inspect
        puts
      end
    end
    raise ActiveRecord::Rollback, "Not all of the records were valid!"
  end
end
