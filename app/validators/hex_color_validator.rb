class HexColorValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A#([[:xdigit:]]{3}){1,2}\z/i
      record.errors[attribute] << (options[:message] ||
        'Формат цвета должен быть указан в HEX формате(#rrggbb)')
    end
  end
end
