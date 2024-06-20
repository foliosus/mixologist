# Service class responsible for dumping the entire database to CSV files,
# to enable backup-style operations.

require 'csv'

class DataDumper
  DIR_BASE = "#{Rails.root}/backups"

  attr_reader :directory_path

  def initialize
    @timestamp = Time.now.to_i
  end

  def to_csv!
    create_directory!

    # Ensure the app is fully loaded, so it works with config.cache_classes = true
    Rails.application.eager_load!

    ActiveRecord::Base.descendants.each do |model_class|
      CSV.open("#{directory_path}/#{model_class.table_name}.csv", "wb") do |csv|
        attribute_names = model_class.attribute_names
        csv << attribute_names

        datetime_columns = Hash.new(false) # default to returning false for all keys
        model_class.attribute_names.select do |attribute_name|
          if model_class.columns_hash[attribute_name].type == :datetime
            datetime_columns[attribute_name] = true
          end
        end

        scope = model_class
        scope = scope.order('id ASC') if model_class.column_names.include?('id')

        scope.in_groups_of(100, false).each do |group|
          group.each do |model_instance|
            row_data = []
            attribute_names.each do |attribute_name|
              if datetime_columns[attribute_name]
                row_data << model_instance.send(attribute_name).to_i
              else
                row_data << model_instance.send(attribute_name)
              end
            end
            csv << row_data
          end
        end
      end
    end
    return true
  rescue => e
    puts e.message
    puts e.backtrace
    return false
  end

  private def create_directory!
    FileUtils.mkdir(directory_path)
  end

  private def directory_path
    @directory_path ||= "#{DIR_BASE}/#{@timestamp}"
  end
end