<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: 审查审批工作台_Main
			Input Param:
		ApproveType：审批类型
			—ApproveCreditApply/授信业务审查审批
			—ApproveApprovalApply/最终审批意见复核	
			—ApprovePutOutApply/出账申请复核
			Output param: 
			      
			History Log: 2005.08.03 jbye    重新修改流程审查相关信息
			 			 2005.08.05 zywei   重检页面
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;未命名模块&nbsp;&nbsp;"; //默认的内容区标题
		String PG_CONTNET_TEXT = "请点击左侧列表";//默认的内容区文字
		String PG_LEFT_WIDTH = "200";//默认的treeview宽度
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/
%>
	<%
		//定义变量：查询结果集
		ASResultSet rs = null;
		//定义变量：SQL语句、当前工作、已完成工作
		String sSql = "",sFolderUnfinished = "",sFolderfinished = "";
		//定义变量：阶段编号、阶段名称、工作数、工作数显示标签、文件夹标记
		String sPhaseNo = "",sPhaseName = "",sWorkCount = "",sPageShow = "",sFolderSign= "" ;
		//定义变量：流程编号、阶段类型、组件编号、组件名称
		String sFlowNo = "",sPhaseType = "",sCompID = "",sCompName = "";
		//定义变量：审批类型名称、流程对象类型
		String sItemName = "",sObjectType = "";
		//定义变量：树型菜单页数
		int iLeaf = 1,i = 0;
		//获得组件参数：审批类型
		String sApproveType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ApproveType"));
		//将空值转换成空字符串
		if(sObjectType == null) sObjectType = "";
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义树图;]~*/
%>
	<%
		//根据申请类型从代码表Code_Library中获得审批类型名称、审批模型编号、流程对象类型、组件编号、组件名称
		sSql = 	" select ItemName,Attribute2,ItemAttribute,Attribute7,Attribute8 "+
		" from Code_Library "+
		" where CodeNo = 'ApproveType'"+
		" and ItemNo ='"+sApproveType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sItemName = DataConvert.toString(rs.getString("ItemName"));
			sFlowNo = DataConvert.toString(rs.getString("Attribute2"));
			sObjectType = DataConvert.toString(rs.getString("ItemAttribute"));
			sCompID = DataConvert.toString(rs.getString("Attribute7"));
			sCompName = DataConvert.toString(rs.getString("Attribute8"));
			//设置窗口标题
			PG_TITLE = sItemName;
			PG_CONTENT_TITLE = "&nbsp;&nbsp;"+PG_TITLE+"&nbsp;&nbsp;";
		}else{
			throw new Exception("没有找到相应的审批类型定义（CODE_LIBRARY.ApproveType:"+sApproveType+"）！");
		}	
		rs.getStatement().close();
		//把FlowNo拆开，为了加上单引号,
		//因为在“未完成”和“已完成”两项中，可以显示针对当前用户的所有流程的工作情况
		String sTempFlowNo = "(";
		StringTokenizer st = new StringTokenizer(sFlowNo,",");
		while(st.hasMoreTokens()){
			sTempFlowNo += "'"+ st.nextToken()+"',";
		}
		sTempFlowNo = sTempFlowNo.substring(0,sTempFlowNo.length()-1)+")";
		//out.println(sTempFlowNo);
		//1、初始化树图
		HTMLTreeView tviTemp = new HTMLTreeView(Sqlca,CurComp,sServletURL,PG_TITLE,"right");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		String sSql0 = 	" select FlowNo,PhaseType,PhaseNo,PhaseName,Count(SerialNo) as WorkCount "+
				" from FLOW_TASK "+
				" where ObjectType = '"+sObjectType+"'"+
				" and FlowNo in "+sTempFlowNo+" "+
				" and PhaseNo not in ('0010','3000')"+
				" and UserID = '"+CurUser.UserID+"'";
		String sGO = " Group by FlowNo,PhaseType,PhaseNo,PhaseName "+
			" Order by FlowNo,PhaseNo ";
		//2、设置当前用户对于该类对象的当前工作菜单项
		sFolderUnfinished = tviTemp.insertFolder("root","当前工作","",i++);
		//从流程任务表FLOW_TASK中查询出当前用户的待审查审批工作信息
		sSql = sSql0+" and (nvl(EndTime,'')='' or EndTime =' ')"+sGO;
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()){	
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));			 
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName")); 
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			if(sWorkCount.equals(""))
		sPageShow  = sPhaseName+" 0 件";	
			else
		sPageShow  = sPhaseName+" "+sWorkCount+" 件";						 
			tviTemp.insertPage(sFolderUnfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"N\")",iLeaf++);
		}
		rs.getStatement().close();
		//4、设置当前用户对于该类对象的已完成工作菜单项
		sFolderfinished = tviTemp.insertFolder("root","已完成工作","",i++);
		sSql = sSql0+" and (nvl(EndTime,'') <> '' or EndTime <> ' ')"+sGO;
		rs = Sqlca.getASResultSet(sSql);
		rs.beforeFirst();
		while (rs.next()){		 
			sFlowNo  =	 DataConvert.toString(rs.getString("FlowNo"));
			sPhaseType = DataConvert.toString(rs.getString("PhaseType"));
			sPhaseNo = DataConvert.toString(rs.getString("PhaseNo"));  		  
			sPhaseName = DataConvert.toString(rs.getString("PhaseName"));  
			sWorkCount = DataConvert.toString(rs.getString("WorkCount"));  
			if(sWorkCount.equals(""))
		sPageShow  = sPhaseName+" 0 件";	
			else
		sPageShow  = sPhaseName+" "+sWorkCount+" 件";		
			tviTemp.insertPage(sFolderfinished,sPageShow,"javascript:top.openPhase(\""+ sApproveType +"\",\""+ sPhaseType +"\",\""+sFlowNo+"\",\""+sPhaseNo+"\",\"Y\")",iLeaf++);
		}
		rs.getStatement().close();
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Main04.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/
%>
	<script language=javascript> 
	
	/*~[Describe=treeview单击选中事件;InputParam=无;OutPutParam=无;]~*/
	function openPhase(sApproveType,sPhaseType,sFlowNo,sPhaseNo,sFinishFlag)
	{
		//打开对应的审批界面
		OpenComp("<%=sCompID%>","<%=sCompName%>","ApproveType="+sApproveType+"&FlowNo="+sFlowNo+"&PhaseType="+sPhaseType+"&PhaseNo="+sPhaseNo+"&FinishFlag="+sFinishFlag,"right","");
		setTitle(getCurTVItem().name);
	}
    
	/*~[Describe=置右面详情的标题;InputParam=sTitle:标题;OutPutParam=无;]~*/
	function setTitle(sTitle)
	{
		//document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
		
	/*~[Describe=生成treeview;InputParam=无;OutPutParam=无;]~*/
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>;
	}
	
	</script> 
<%
 	/*~END~*/
 %>


<%
	/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/
%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	selectItem('2');
	expandNode('<%=sFolderUnfinished%>');

	</script>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>
