#encoding: UTF-8
Symbol.class_eval do
  def icon()
    Netzke::Core.with_icons ? [Netzke::Core.icons_uri, '/', self.to_s, ".png"].join : nil
  end
end