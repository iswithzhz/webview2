*--这是WebView2项目的Echarts与要与webview_echarts简单交互版.scx交互配合使用演示
*--这是一个收费功能函数,不需要可以不关注   
*--月销售分类汇总统计
Function Echarts_demo1()
		 
	 If Used( 'cur_demo1' ) Then 
		 Select cur_demo1
		 
         *--添加一个VFP.oEcharts对象，以方便JS读取该对象的属性
         Local m.loEcharts 
         m.loEcharts = Newobject( "empty" )
         
         Addproperty( m.loEcharts  , "title" )
         m.loEcharts.title = 'Ecahrts_Demo1_' + alltrim( Transform(cur_demo1.月份) ) + '月份销售分类汇总统计' &&第1，5实例DEMO
         
         *--legend
         Local lolegend
         Addproperty( m.loEcharts  , "legend" )
         m.lolegend = Newobject( "empty" )
		 m.loEcharts.legend=m.lolegend
		 
		 
         *--xAxis
         Local loxAxis
         Addproperty( m.loEcharts  , "xAxis" )
         m.loxAxis = Newobject( "empty" )
         m.loEcharts.xAxis= m.loxAxis 
         Addproperty( m.loxAxis	, 'data' 	)
         
         Local lnCount ;
             , lcFidno ;
             , lcValuestr 
             
         For m.lnCount = 2 To Fcount( 'cur_demo1' )
             m.lcFidno = Fields( m.lnCount )
             m.lcValuestr = Iif( Empty( m.lcValuestr ) , '' ;
             										   , m.lcValuestr + [,] ) + ["] + m.lcFidno + ["]
		 Endfor 
    	 m.loxAxis.data = '[' + m.lcValuestr + ']'
		 *m.loxAxis.data = '[' + ["衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"] + ']' 
		 *--实际可以固定死：
		 *--因我们设计的列是固定下来的

		 
         *--yAxis
*!*	         Local loyAxis 
*!*	         Addproperty( m.loEcharts  , "yAxis" )
*!*	         m.loyAxis = Newobject( "empty" )
*!*	         m.loEcharts.yAxis = m.loyAxis 
         
         
         *--series
         Local loseries
         Addproperty( m.loEcharts  , "series" )
         m.loseries = Newobject( "empty" )
         m.loEcharts.series = m.loseries 
         Addproperty( m.loseries   , 'name' 	)
         m.loseries.name = '销量'
         Addproperty( m.loseries   , 'data' 	)
         
         *_vfp.SetVar('oEcharts' , m.loEcharts )


	    Local lcData
	    Text To m.lcData Textmerge Pretext  1 + 2 + 8 + 4  Noshow 
	         <<cur_demo1.衬衫>>
	        ,<<cur_demo1.羊毛衫>>
	        ,<<cur_demo1.雪纺衫>>
	        ,<<cur_demo1.裤子>>
	        ,<<cur_demo1.高跟鞋>>
	        ,<<cur_demo1.袜子>>
	    Endtext 
	    *Return '[' +  m.lcData  + ']'
	    m.loseries.data = '[' +  m.lcData  + ']'
	    
	    Return m.loEcharts
	 Else 
		Return null 
	 Endif 
 
Endfunc 

*--产品分类占比汇总
*--这个Echarts_demo2没有动态设置oEcharts的属性，如果需要可以参考“Echarts_demo1”的设置
Function Echarts_demo2()
	 
     Select cur_demo2
     If Used( 'cur_demo2' ) Then 
        Local lcValuestr ;
        	, lnValue 	 ;
        	, lnFidno    ;
        	, lcName  
        	
        
        For m.lnCount =1 To Fcount( 'cur_demo2' ) - 1
            *--分类名称
            m.lnFidno = Fields( m.lnCount ) 
            *--值
            m.lnValue = cur_demo2.&lnFidno.
            *--衬衫(45%)
            m.lcName  = Getwordnum( m.lnFidno ,  2 , '_' ) +;
            			"(" + Transform(  Round( m.lnValue / sum_all * 100 , 2 )  ;
            						   ) +  ;
            		     "%)"
            *--option(Data) 这里实际只是一个string
            m.lcValuestr = Iif( Empty( m.lcValuestr ) , '' ;
            										  , m.lcValuestr + "," ) + "{value:"+ Transform( m.lnValue  ) + ",name:'" + m.lcName + "'}"
        Endfor  
        Return '[' + m.lcValuestr  + ']'
     Else 
        Return ""
     Endif 
     
Endfunc

*--各销售人员对比分析
Function Echarts_demo3()
     *--注意数据没有求取，按VFP自行求取表的：“Echarts_data”值,这里我是直接写死的
     *--格式不要乱就可以了[ [第一个组数],[第二个数组],[第三个数组]...]
     
     If Used( 'Echarts_data' ) Then 
        Text To  m.lcData Textmerge Pretext  1 + 2 + 8 + 4  Noshow 
        	[
        	 ['月份', '1月', '2月', '3月'],
        	 ['小李', 43.3, 85.8, 93.7],
        	 ['小黄', 83.1, 73.4, 55.1],
        	 ['小明', 86.4, 65.2, 82.5],
        	 ['小徐', 72.4, 53.9, 39.1]
        	]
        Endtext 
        Return  m.lcData
     Else 
        Return ""
     Endif 
Endfunc


*--月销售分类汇总统计(含 自动刷新,特别要注意管理自己的私有工作期 )
Function Echarts_demo5( )

		
		    
		    Text To m.lcSqlCmd noShow
				Select month(日期) As 月份  
				     , Sum(衬衫)   As 衬衫   
				     , Sum(羊毛衫) As 羊毛衫
				     , Sum(雪纺衫) As 雪纺衫
				     , Sum(裤子)   As 裤子  
				     , Sum(高跟鞋) As 高跟鞋  
				     , Sum(袜子)   As 袜子	
				From Echarts_data Group By month(日期)
		    Endtext 
		    
		    
		    If Sqlexec( gnConnHandle,m.lcSqlCmd, 'cur_demo5' ) < 0 Then 
		       Aerror( AErrorMsg )
       		   Messagebox( [获取表“Echarts_data”月销售分类汇总数据，失败(] + AErrorMsg[2] +[)......]  , 16  , '过程：' + Program() )
		       Return null 
		    Endif 
		    
		
		 If Used( 'cur_demo5' ) Then 
			 Select cur_demo5
			 
	         *--添加一个VFP.oEcharts对象，以方便JS读取该对象的属性
	         Local m.loEcharts 
	         m.loEcharts = Newobject( "empty" )
	         
	         Addproperty( m.loEcharts  , "title" )
	         m.loEcharts.title = 'Ecahrts_Demo5_' + alltrim( Transform(cur_demo5.月份) ) + '月份销售分类汇总统计' &&第1，5实例DEMO
	         
	         *--legend
	         Local lolegend
	         Addproperty( m.loEcharts  , "legend" )
	         m.lolegend = Newobject( "empty" )
			 m.loEcharts.legend=m.lolegend
			 
			 
	         *--xAxis
	         Local loxAxis
	         Addproperty( m.loEcharts  , "xAxis" )
	         m.loxAxis = Newobject( "empty" )
	         m.loEcharts.xAxis= m.loxAxis 
	         Addproperty( m.loxAxis	, 'data' 	)
	         
	         Local lnCount ;
	             , lcFidno ;
	             , lcValuestr 
	             
	         For m.lnCount = 2 To Fcount( 'cur_demo5' )
	             m.lcFidno = Fields( m.lnCount )
	             m.lcValuestr = Iif( Empty( m.lcValuestr ) , '' ;
	             										   , m.lcValuestr + [,] ) + ["] + m.lcFidno + ["]
			 Endfor 
	    	 m.loxAxis.data = '[' + m.lcValuestr + ']'
			 *m.loxAxis.data = '[' + ["衬衫","羊毛衫","雪纺衫","裤子","高跟鞋","袜子"] + ']' 
			 *--实际可以固定死：
			 *--因我们设计的列是固定下来的

			 
	         *--yAxis
	*!*	         Local loyAxis 
	*!*	         Addproperty( m.loEcharts  , "yAxis" )
	*!*	         m.loyAxis = Newobject( "empty" )
	*!*	         m.loEcharts.yAxis = m.loyAxis 
	         
	         
	         *--series
	         Local loseries
	         Addproperty( m.loEcharts  , "series" )
	         m.loseries = Newobject( "empty" )
	         m.loEcharts.series = m.loseries 
	         Addproperty( m.loseries   , 'name' 	)
	         m.loseries.name = '销量'
	         Addproperty( m.loseries   , 'data' 	)
	         
	         *_vfp.SetVar('oEcharts' , m.loEcharts )


		    Local lcData
		    Text To m.lcData Textmerge Pretext  1 + 2 + 8 + 4  Noshow 
		         <<cur_demo5.衬衫>>
		        ,<<cur_demo5.羊毛衫>>
		        ,<<cur_demo5.雪纺衫>>
		        ,<<cur_demo5.裤子>>
		        ,<<cur_demo5.高跟鞋>>
		        ,<<cur_demo5.袜子>>
		    Endtext 
		    *Return '[' +  m.lcData  + ']'
		    m.loseries.data = '[' +  m.lcData  + ']'
		    
		    Return m.loEcharts
		 Else 
			Return null 
		 Endif 
     
Endfunc 