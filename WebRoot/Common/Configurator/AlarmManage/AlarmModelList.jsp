<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   zxu 2005-06-01
			Tester:
			Content: 预警模型列表
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
		String PG_TITLE = "预警模型列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	String sSortNo; //排序编号
	
    //获得页面参数	
	String sAlarmModelID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelID"));
    if (sAlarmModelID == null) 
        sAlarmModelID = "";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String[][] sHeaders = {
		{"AlarmModelNo","预警模型编号"},
		{"AlarmModelType","预警模型类型"},
		{"AlarmModelName","预警模型名称"},
		{"AlarmDescribe","预警模型描述"},
		{"CheckScript","校验脚本"}
	};
	
	sSql =  "select "+
	"AlarmModelNo,"+
	"getItemName('AlarmModelType',AlarmModelType) as AlarmModelType,"+
	"AlarmModelName,"+
	"AlarmDescribe,"+
	"CheckScript"+
		" from Alarm_MODEL where 1=1 order by AlarmModelNo";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "Alarm_MODEL";
	doTemp.setKey("AlarmModelNo",true);
	doTemp.setHeader(sHeaders);
	
	doTemp.setHTMLStyle("AlarmModelNo"," style={width:60px} ");
	doTemp.setHTMLStyle("AlarmModelName,AlarmDescribe"," style={width:180px} ");
	doTemp.setHTMLStyle("CheckScript"," style={width:300px} ");
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	
	//查询
 	doTemp.setColumnAttribute("AlarmModelNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(sAlarmModelID !=null && !sAlarmModelID.equals(""))
	{
		doTemp.WhereClause+=" And AlarmModelNo='"+sAlarmModelID+"'";
	}
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";

    ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
    dwTemp.setPageSize(200);
    
	//定义后续事件
	dwTemp.setEvent("BeforeDelete","!Configurator.DelAlarmModel(#AlarmModelNo)");
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
    for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
    CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
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
			// Del by wuxiong 2005-02-22 因返回在TreeView中会有错误 {"true","","Button","返回","返回","doReturn('N')",sResourcesPath}
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
	var sCurModelNo=""; //记录当前所选择行的代码号

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		sReturn=popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","AlarmModelID=<%=sAlarmModelID%>","");
		//修改数据后刷新列表
		reloadSelf();
	}
	
    /*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		sAlarmModelID = getItemValue(0,getRow(),"AlarmModelNo");
        if(typeof(sAlarmModelID)=="undefined" || sAlarmModelID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
	    }
        sReturn=popComp("AlarmModelInfo","/Common/Configurator/AlarmManage/AlarmModelInfo.jsp","AlarmModelID="+sAlarmModelID,"");
        //修改数据后刷新列表
	    reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sAlarmModelID = getItemValue(0,getRow(),"AlarmModelNo");
        if(typeof(sAlarmModelID)=="undefined" || sAlarmModelID.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
        	return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}
	

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"AlarmModelNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
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
	var bHighlightFirst = true;//自动选中第一条记录
	my_load(2,0,'myiframe0');
	hideFilterArea();
    
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
