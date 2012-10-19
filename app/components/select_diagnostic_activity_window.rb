#encoding: UTF-8
class SelectDiagnosticActivityWindow < DictionaryWindow

  def configuration
    @user = Netzke::Core.current_user
    @ability = Ability.new @user
    super.tap do |t|
      cols = [:code, :name]
      cols << :price if @ability.can :see, :prices
      cols << :score
      t[:columns] = cols
      t[:model] = 'Activity'
      t[:scope] = "diagnostic = true"
    end
  end
end