class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer     :number
      t.integer     :ticket
      t.text        :diag_result      #Результат диагностики
      t.text        :diag_ground      #Основание для проведения диагностики
      t.text        :actual_defect    #Фактическая неисправность
      t.integer     :diag_manager_id
      t.decimal     :diag_price, :precision => 8, :scale => 2
      t.references  :customer
      t.integer     :manager_id
      t.date        :applied_at         #Дата обращения
      t.date        :plan_deliver_at    #Дата выдачи (план)
      t.date        :actual_deliver_at  #Дата выдачи (факт)
      t.date        :diagnosed_at       #Дата проведения диагностики
      t.date        :work_performed_at  #Дата выполнения работ
      t.decimal     :prior_cost, :precision => 8, :scale => 2   #Предварительная стоимость
      t.decimal     :maximum_cost, :precision => 8, :scale => 2 #Максимальная стоимость
      t.string      :guarantee_case
      t.integer     :deliver_manager_id #Кто выдал
      t.decimal     :discount
      t.string      :discount_type
      t.text        :discount_ground
      t.text        :service_info
      t.text        :service_state
      t.text        :service_note
      t.text        :service_phone_agreement
      t.references  :complect
      t.references  :repair_type
      t.references  :external_state
      t.references  :internal_state
      t.references  :reason             #Заявленная неисправность
      t.references  :goal
      t.references  :status
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
