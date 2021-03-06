<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   zywei 2006-1-18
			Tester:
			Content: 对象类型Tab列表
			Input Param:
	                  
			Output param:
			                
			History Log: 
			  
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "对象类型Tab配置列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders={
		{"ObjectType","对象类型"},
		{"RelationShip","关联关系描述"},
		{"SortNo","排序号"},
		{"DisplayName","显示标题名称"},
		{"RelaObjectType","主键"},
		{"ShowOnTabExpr","展现Tab表达式"},
		{"RelaExpr","展现Tab参数"},
		{"ViewExpr","展现TabUrl"},											
		{"IsInUse","是否有效"}			
	};

	sSql =  " select ObjectType,RelationShip,SortNo,DisplayName,RelaObjectType,ShowOnTabExpr, "+
	" RelaExpr,ViewExpr,getItemName('IsInUse',IsInUse) as IsInUse "+
	" from OBJECTTYPE_RELA "+			
	" order by UpdateTime desc ";

	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable="ObjectType_Rela";
	doTemp.setKey("ObjectType,RelationShip",true);
	doTemp.setHeader(sHeaders);

	//查询
 	doTemp.setColumnAttribute("ObjectType","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(200);

	//定义后续事件
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
%>
	<%
		//依次为：
			//0.是否显示
			//1.注册目标组件号(为空则自动取当前组件)
			//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.按钮文字
			//4.说明文字
			//5.事件
			//6.资源图片路径
		String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","导出EXCEL","导出EXCEL","exportAll()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	var sCurCodeNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaInfo.jsp","_self","");      
	}
	
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
        sObjectType = getItemValue(0,getRow(),"ObjectType");
        sRelationShip = getItemValue(0,getRow(),"RelationShip");
        if(typeof(sObjectType) == "undefined" || sObjectType.length == 0) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
        
        OpenPage("/Common/Configurator/ObjectManage/ObjTypeRelaInfo.jsp?ObjectType="+sObjectType+"&RelationShip="+sRelationShip,"_self","");           
	}
    
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");		
        if(typeof(sObjectType) == "undefined" || sObjectType.length == 0) 
        {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
