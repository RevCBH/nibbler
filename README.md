# Nibbler RM: Consume .nib files easily from RubyMotion

## Disclaimer
This is my personal exploration for consuming .nib files from RubyMotion. It's entirely experimental, undocumented, and unsuitable for any app that will see the light of day. This code is older and hasn't been looked at for some time. For example, there's a very kludgy implementation of `define_method` which I use to fake dynamisim. This has since been properly implemented in RM.

## Purpose

Interface builder can't wire components to ruby code, leaving the options tagging everything, searching for controls manually, or building interfaces programmatically. While the last option has seen a lot of work, I like working in IB and with designers that use it. Nibbler is an attempt to simplify the consumption of .xib and .nib files from RM via declarative binding of controls.

## Usage

View controller classes deriver from `Nibbler::Controller` and have class methods for binding to specific elements. For example, the `button` accepts a selector argument, which determines which button to bind against (e.g. by title, or position) and a hash specifying how to bind it with code. In the code below, the following line gives an example of this:

    button :seconds, as: 'interval_unit', action: 'select_interval_unit'

Here, a button titled 'seconds' (case insensitive) will be bound to the `interval_unit` variable and will call the `select_interval_unit` method on the controller when clicked.

Here's a larger example:

    class TimelapseController < Nibbler::Controller
      button :seconds, as: 'interval_unit', action: 'select_interval_unit'
      text_field(1, 
        as: 'interval_field', 
        on: {changed: 'interval_changed:'},
        input_accessory_view: 'numpad_toolbar'
      )
      picker(
        as: 'interval_unit_picker',
        data_source: %w{seconds minutes hours},
        on: {changed: 'interval_unit_changed'}
      )

      def select_interval_unit
        puts "Select interval unit"
        interval_unit_picker.hidden = false
      end

      def interval_changed(sender)
        puts "Interval changed to: #{interval_field.text} #{interval_unit.text}"    
      end

      def interval_unit_changed(item, index)    
        interval_unit_picker.hidden = true
        interval_unit.text = item
      end
    end

