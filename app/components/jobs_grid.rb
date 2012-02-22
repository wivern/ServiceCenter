#encoding: UTF-8
class JobsGrid < DictionaryGridPanel

  action :add_import do
    {:icon => :arrow_merge}
  end
  action :add_export do
    {:icon => :arrow_branch}
  end
  action :run do
    {:icon => :clock_play}
  end

  endpoint :create_job do |params|
    @job = nil
    case params[:job_type]
      when 'import' then @job = Exchange::ImportJob.new(params[:job])
      when 'export' then @job = Exchange::ExportJob.new(params[:job])
    end
    @job.save if @job
  end

  endpoint :execute_job do |params|
    job = ExchangeJob.find(params[:job_id])
    jobs = Rails.configuration.scheduler.find_by_tag(job.id)
    unless jobs.empty?
      jobs.each{|j| j.trigger unless j.running}
      {:set_result => true, :netzke_feedback => "Задание #{job.name} выполняется"}
    else
      {:set_result => false, :netzke_feedback => 'Задание не найдено.'}
    end
  end

  def default_bbar
    res = [{:text => I18n.t('jobs_grid.actions.create'),
            :icon => :add.icon,
            :menu => %w(add_import add_export).map(&:to_sym).map(&:action)}]
    res.concat %w(edit apply del).map(&:to_sym).map(&:action)
    res << "-" << :run.action
    res
  end

  js_method :handle_add, <<-JS
    function(jobType){
      this.createJob({
        job_type: jobType,
        job:{
          name: 'test',
          value: '0 22 * * 1-5',
          target_path: '/home/ftp'
        }
      }, function(){
        this.store.load();
      }, this);
    }
  JS

  js_method :on_run, <<-JS
    function(){
      var selection = this.getView().getSelectionModel().getSelection();
      var me = this;
      if (selection.length > 0){
        var job = selection[0];
        Ext.MessageBox.show({
          title: 'Подтверждение',
          msg: 'Вы хотите запустить задание "' + job.get('name') + '"?',
          buttons: Ext.MessageBox.YESNO,
          icon: Ext.MessageBox.QUESTION,
          fn: function(btn){
            if (btn === 'yes'){
              me.executeJob({job_id: job.get('id')}, function(){ me.store.load; });
            }
          }
        });
      }
    }
  JS

  js_method :on_add_import, <<-JS
    function(){
      this.handleAdd('import');
    }
  JS

  js_method :on_add_export, <<-JS
    function(){
      this.handleAdd('export');
    }
  JS

  js_method :render_type_icon, <<-JS
    function(value){
      var icon = '';
      switch(value){
        case 'Exchange::ExportJob':
          icon = '/images/icons/arrow_branch.png';
          break;
        case 'Exchange::ImportJob':
          icon = '/images/icons/arrow_merge.png';
          break;
        default:
          icon = '/images/icons/application_xp.png';
          break;
      }
      return '<img src="' + icon + '">';
    }
  JS
end