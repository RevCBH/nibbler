module Nibbler; module Views
  class Picker < ViewBase
    view_type UIPickerView

    def initialize(controller, spec)
      puts "Picker#initialize(#{controller}, #{spec})"
      @data_source = (spec[:data_source] || []).dup
      @columns = spec[:columns]
      @rows = spec[:rows]
      if spec[:on]
        @on_changed = spec[:on][:changed].to_sym
      end
      super(controller, spec)

      view_instance.delegate = self
      view_instance.dataSource = self
    end

    def numberOfComponentsInPickerView(pickerView)
      return @columns unless @columns.nil?
      return @data_source.first.count if @data_source.first.respond_to?(:count) && !@data_source[0].is_a?(String)
      return 1
    end

    def pickerView(view, numberOfRowsInComponent:component)
      return @rows unless @rows.nil?
      return @data_source.count if @data_source.respond_to?(:count)
      return 0
    end

    def pickerView(view, didSelectRow:row, inComponent:component)
      @controller.send(@on_changed, @data_source[row], component) unless @on_changed.nil?
    end 

    def pickerView(view, titleForRow:row, forComponent:component)
      row = @data_source[row]
      return row[component] if row.respond_to?(:[]) && !@data_source[0].is_a?(String)
      return row
    end
  end
end; end