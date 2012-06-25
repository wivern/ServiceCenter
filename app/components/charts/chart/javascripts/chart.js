{
 /*   axes: [{
        type: 'Numeric',
        position: 'bottom',
        fields: ['order_count'],
        title: 'Кол-во',
        minimum: 0
    },{
        type: 'Category',
        position: 'left',
        fields: ['repair_type'],
        title: 'Тип ремонта'
    }],  */
    animate: true,
    series: [
    {
            type: 'bar',
            axis: 'bottom',
            yField: 'order_count',
            xField: 'repair_type',
            highlight: true,
            label: {
                display: 'insideEnd',
                field: 'order_count',
                renderer: Ext.util.Format.numberRenderer('0'),
                orientation: 'horizontal',
                color: '#333',
               'text-anchor': 'middle'
            }
      }
    ],
    initComponent: function(){
        console.debug('chart data url', this.chartDataUrl);
        var fields = this.fields || [
                        {name: 'repair_type', type: 'string'},
                        {name: 'order_count', type: 'int'}
                    ];
        Ext.define('OrdersStat',{
            extend: 'Ext.data.Model',
            fields: fields,
            proxy: {
                type: 'ajax',
                reader: {
                    type: 'json'
                }
            }
        });
        this.store = Ext.create('Ext.data.Store',{
            model: 'OrdersStat',
            autoLoad: false /*,
            data:[
                {repair_type: 'Гарантийный', count: 30},
                {repair_type: 'Платный', count: 45},
                {repair_type: 'Смета', count: 32},
                {repair_type: 'Акт', count: 12}
            ]                 */
        });
        this.store.load({url: this.chartDataUrl, callback: function(store, op, success){
            console.debug(store, op);
        }});
        console.debug("series", this.series);
        if (typeof(this.series.tips) !== 'undefined'){
            console.debug(this.series.tips, typeof(this.series.tips));
            if (this.series.tips.renderer && typeof(this.series.tips.renderer) === 'string'){
                console.debug(this.series.tips.renderer, typeof(this.series.tips.renderer));
                this.series.tips.renderer = eval(this.series.tips.renderer);
            }
        }
        this.callParent();
    }
}