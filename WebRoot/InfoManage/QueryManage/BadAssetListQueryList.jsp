<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: 申请信息快速查询
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：申请信息快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "不良资产查询"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql
	String sComponentName = "";//--组件名称
	String PG_CONTENT_TITLE = "";//--题头
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;不良资产查询&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"CustomerName","客户名称"},
							{"PutoutOrgName","放贷机构"},
							{"ContractSum","合同金额"},
							{"ContractBalance","合同余额"},	
							{"BusinessType","业务品种"},
							{"BusinessTypeName","业务品种"},
							{"VouchType","担保方式"},
							{"VouchTypeName","担保方式"},
							{"BeginDate","合同起始日"},
							{"EndDate","合同到期日"},
							{"IsoverLawTerm","是否超过诉讼时效"},
							{"HarvestSumCash","最终收回额（现金）"},
							{"HarvestSumAsset","最终收回额（抵债资产）"},
							{"LossSum","最终形成损失额"},
							{"IsoverLawTermName","是否超过诉讼时效"},
							{"ManageUserName","管理人"}
							}; 
	sSql =	" select CustomerName,PutoutOrgName,ContractSum,ContractBalance-Bad_Asset.HarvestSum as ContractBalance,"+
			" BusinessType,getItemName('BadAssetBusinessType',BusinessType) as BusinessTypeName,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
			" BeginDate,EndDate,IsoverLawTerm,getItemName('YesNo',IsoverLawTerm) as IsoverLawTermName,"+
			" case when Harvest_Record.HarvestType = '01' then Harvest_Record.HarvestSum else 0 end as HarvestSumCash,"+
			" case when Harvest_Record.HarvestType <> '01' then Harvest_Record.HarvestSum else 0 end as HarvestSumAsset,"+
			" ContractBalance-Bad_Asset.HarvestSum as LossSum,ManageUserName"+
			" from Bad_Asset ,Harvest_Record  where Bad_Asset.SerialNo=Harvest_Record.ObjectNo";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置对齐方式
	doTemp.setAlign("ContractSum,ContractBalance,HarvestSumCash,HarvestSumAsset,LossSum","3");
	doTemp.setType("ContractSum,ContractBalance,HarvestSumCash,HarvestSumAsset,LossSum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("ContractSum,ContractBalance,HarvestSumCash,HarvestSumAsset,LossSum","2");
	doTemp.setVisible("BusinessType,VouchType,IsoverLawTerm",false);
	//生成查询框
	
	doTemp.setDDDWCode("IsoverLawTerm","YesNo");
	doTemp.setDDDWCode("BusinessType","BadAssetBusinessType");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from code_library where codeno='VouchType' and length(itemno)=3");	
	
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","PutoutOrgName","");
	doTemp.setFilter(Sqlca,"3","IsoverLawTerm","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","BusinessType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","VouchType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","ManageUserName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页 

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		//{"true","","Button","详细信息","详细信息","viewAndEdit()",sResourcesPath},
		//{"true","","Button","查看意见详情","查看意见详情","viewOpinions()",sResourcesPath},
		//{"true","","Button","查看调查报告","查看调查报告","viewReport()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得业务流水号
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}else
		{
			openObject("CreditApply",sSerialNo,"002");
		}
	}	
    
    /*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=查看调查报告;InputParam=无;OutPutParam=无;]~*/
	function viewReport()
	{
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("调查报告还未填写，请先填写调查报告再查看！");
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			alert("调查报告还未生成，请先生成调查报告再查看！");
			return;  
		}
		
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
