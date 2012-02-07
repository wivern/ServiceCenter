#encoding: UTF-8
class AnalyserGrid < Netzke::Basepack::GridPanel
  def default_bbar
    res = []
    res << :search.action if config[:enable_extended_search]
  end
end