<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: 显示授信业务信息
		Input Param:
            ObjectNo:代号
            InspectType:报告类型
                010	贷款用途报告
				020	贷款检查报告
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "显示授信业务信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//获得组件参数	
	String sSerialNo   = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	String sObjectType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")));
	String sReportDate = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate")));
    String sCurrentItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurrentItemNo")));
	%>
<%/*~END~*/%>     


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sPurposeInspectItems = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[20][3];
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab
		//获取
		sSql = "select RelativeCode from Code_Library where CodeNo ='SynthesisManage' and ItemNo='"+sCurrentItemNo+"'";
		sPurposeInspectItems = Sqlca.getString(sSql);
		String[]aPurposeInspectItems=sPurposeInspectItems.split("@");
		for(int i=0;i<aPurposeInspectItems.length;i++){
			String []aItemName = aPurposeInspectItems[i].split(":");
			sAddStringArray = new String[] {"",aItemName[0],"doTabAction('"+aItemName[1]+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
		}
		//设定标题
		sTitle = "贷款用途报告";

		//根据定义组生成 tab
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));
		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";
	%>
</script>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript>
  	function doTabAction(ssOpenUrl)
  	{	
  	  	var sOpenUrl=ssOpenUrl;
  	    sOpenUrl=sOpenUrl.replace(/~/g,"\""); 
  		sOpenUrl=sOpenUrl.replace(/#TargetJSP/g,"<%=sCurrentItemNo.substring(0,sCurrentItemNo.length()-3)%>");  
  		sOpenUrl=sOpenUrl.replace("#ReportDate","<%=sReportDate%>");
  		sOpenUrl=sOpenUrl.replace("#ObjectType","<%=sObjectType%>");
  		sOpenUrl=sOpenUrl.replace("#SerialNo","<%=sSerialNo%>");
		eval(sOpenUrl);
		return true;
  	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language=javascript>
	//参数依次为： tab的ID,tab定义数组,默认显示第几项,目标单元格
	hc_drawTabToTable("tab_DeskTopInfo",tabstrip,<%=initTab%>,document.all('<%=sTabID%>'));
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>