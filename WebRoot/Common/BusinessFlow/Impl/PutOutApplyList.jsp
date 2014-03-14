<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
<%
	/*
																													Author:   byhu  2004.12.6
																													Tester:
																													Content: 该页面主要处理放贷申请
																													Input Param:
																													Output param:
																													History Log: 
																														zywei 2005/07/27 重检页面 
																														zywei 2007/10/10 修改取消出账的提示语
		 */
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
<%
	String PG_TITLE = "未命名模块"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=ApplyList;Describe=主体页面;]~*/
%>
<%@include file="/Common/WorkFlow/ApplyList.jsp"%>
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

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增放贷申请;InputParam=无;OutPutParam=无;]~*/
	function newApply()
	{
		//设置合同对象
		sObjectType = "BusinessContract";		
		//待出账的合同信息
		sParaString = "ManageUserID"+","+"<%=CurUser.UserID%>"+","+"PutOutDate"+","+"<%=StringFunction.getToday()%>"+","+"Maturity"+","+"<%=StringFunction.getToday()%>";
		sReturn = setObjectValue("SelectContractOfPutOut",sParaString,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;
		//合同流水号
		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sBusinessType = sReturn[1];
		sSurplusPutOutSum = RunMethod("BusinessManage","GetPutOutSum",sObjectNo);
		if(parseFloat(sSurplusPutOutSum) <= 0) //如果合同没有可用金额，则终止出账申请
		{	
			alert(getBusinessMessage('573'));//此业务合同已没有可用金额，不能进行放贷申请！
			return;
		}
		//当业务品种为贴现业务时，需要检验是否有票据。
		if(sBusinessType =="1020010" || sBusinessType == "1020020" || sBusinessType == "1020030")
		{
			sReturn = RunMethod("BusinessManage","CheckBillInfo",sObjectNo+","+sBusinessType);
			if(sReturn == "00")
			{
				alert("没有录入相关的票据信息，请录入后再进行出账申请！");
				return;
			}
		}
		
		//进行风险智能探测
		sReturn=RunMethod("BusinessManage","CheckContractRisk",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=45;dialogHeight=40;center:yes;status:no;statusbar:no");
			//return;  //该“return”是否有效视具体业务需求而定
		}
		
		//add by lzhang 2011/04/02 对外保函增加保证类担保合同到期日控制
		if(sBusinessType == "2050040"||sBusinessType == "2050045"){//对外保函和保函增额的保证担保合同到期日超过主合同6个月以上
			sGCEndDate = RunMethod("BusinessManage","CheckMinDate",sObjectNo);//获取保证担保合同的最小到期日
			sContractEndDate = RunMethod("BusinessManage","CheckEndDate",sObjectNo);//获取业务合同六个月后的到期日
			sTermMonth = "6";//控制期限为六个月
			sTermDay = "0";
			sReturnValue = RunMethod("BusinessManage", "CheckPutOutDate", sContractEndDate + "," + sGCEndDate + "," + sTermMonth + "," + sTermDay);
			if(sReturnValue == "ok"){
				alert("对外保函和保函增额业务，主要反担保方式为保证的，\n担保合同的到期日须在业务合同到期日后6个月以上！");
				return;
			}
		}
		
		//如果贴现业务需要单张票出账时，请项目组自行编写选择票据的列表，将所选择的汇票编号赋给sBillNo
		//产品原型中是将该贴现合同项下的票据一次性出账
		var sBillNo="";
				
		//初始化放贷申请,返回出账流水号
		sReturn = RunMethod("WorkFlowEngine","InitializePutOut","<%=sObjectType%>,"+sObjectNo+","+sBusinessType+","+sBillNo+",<%=CurUser.UserID%>,<%=sApplyType%>,<%=sInitFlowNo%>,<%=sInitPhaseNo%>,<%=CurUser.OrgID%>");
		if(typeof(sReturn) == "undefined" || sReturn == "") return;

		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=PutOutApply&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
			
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function cancelApply()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
				
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
				
		if(confirm(getHtmlMessage('70')))//您真的想取消该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句			
		}
	}

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (sPhaseNo != "0010" && sPhaseNo != "3000") {
			sParamString += "&ViewID=002"
		}
		
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=提交任务;InputParam=无;OutPutParam=无;]~*/
	function doSubmit()
	{
		
		sTempSaveFlag = getItemValue(0,getRow(),"TempSaveFlag");
		if(sTempSaveFlag != '2'){
			alert("请打开放贷详情，录入出账信息！");
			return;
		}
		
		
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		
		var returnValue = RunMethod("BusinessManage","GetGuarantyContractNum",sContractSerialNo);
		if(returnValue>0){
			//add by xqli 2009/12/08,校验，必须先登记担保合同日期，再登记合同的日期
			//获取所有担保合同的最大起始日和最小到期日
			returnValue = RunMethod("BusinessManage","CheckGuarantyDate",sContractSerialNo);
			returnValue = returnValue.split('@');
			
			var sBeginDate = returnValue[0];
			var sEndDate = returnValue[1];
			
			if(typeof(sBeginDate) == "undefined" || sBeginDate == "" || typeof(sEndDate) == "undefined" || sEndDate == ""){
				alert("担保合同的起始日和到期日不能为空！");
				return ;
			}
			//合同起始日
			sPutOutDate = getItemValue(0,getRow(),"PutOutDate");
			//合同到期日
			sMaturity = getItemValue(0,getRow(),"Maturity");	
			
			if((sBeginDate > sPutOutDate) || (sEndDate < sMaturity)){
				alert("主合同的起始日不能早于担保合同的起始日！\n主合同的到期日不能晚于担保合同的到期日！\n请先取消放贷,然后重新登记合同！");
				return ;				
			}
		}
		//获得出账类型、出账流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//检查该业务是否已经提交了（解决用户打开多个界面进行重复操作而产生的错误）
		sNewPhaseNo=RunMethod("WorkFlowEngine","GetPhaseNo",sObjectType+","+sObjectNo);
		if(sNewPhaseNo != sPhaseNo) {
			alert("该放贷申请已经提交了，不能再次提交！");//该放贷申请已经提交了，不能再次提交！
			reloadSelf();
			return;
		}
		
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		
		//检查是否签署意见
		sReturn = PopPage("/Common/WorkFlow/CheckOpinionAction.jsp?SerialNo="+sTaskNo,"","dialogWidth=0;dialogHeight=0;minimize:yes");
		if(typeof(sReturn)=="undefined" || sReturn.length==0) {
			alert(getBusinessMessage('501'));//该业务未签署意见,不能提交,请先签署意见！
			return;
		}
		//进行暂存状态检查
		sReturn=RunMethod("BusinessManage","CheckSaveFlag",sObjectType+","+sObjectNo);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			alert(sReturn);
			return; 
		}
		
		//--added by wwhe 2010-01-11 for:出账之前校验该客户核心客户编号是否已得到
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sCoreSytemCustomerID = RunMethod("BusinessManage","GetCoreSytemCustomerID",sCustomerID);
		
		if(typeof(sCoreSytemCustomerID) == "undefined" || sCoreSytemCustomerID == ""|| sCoreSytemCustomerID == "null" || sCoreSytemCustomerID.length==0) {
			alert("请在客户界面点击“引入核心客户”按钮，得到核心客户编号后再进行出账提交");
			return false;
		}
		//--finished adding wwhe 2010-01-11
		//进行风险智能探测
		//added by bllou 20120314 
		sReturn=RunMethod("BusinessManage","CheckPutoutRisk",sObjectType+","+sObjectNo+",<%=CurUser.UserID%>");
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{
			sReturnValue = PopPage("/Common/WorkFlow/CheckActionView.jsp?Flag="+sReturn,"","resizable=yes;dialogWidth=30;dialogHeight=20;center:yes;status:no;statusbar:no");
			if(sReturnValue == "false")
				return;  //该“return”是否有效视具体业务需求而定
		}
		//弹出审批提交选择窗口		
		sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialog.jsp?SerialNo="+sTaskNo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(sPhaseInfo=="" || sPhaseInfo=="_CANCEL_" || typeof(sPhaseInfo)=="undefined") return;
		else if (sPhaseInfo == "Success")
		{
			alert(getHtmlMessage('18'));//提交成功！
			reloadSelf();
		}else if (sPhaseInfo == "Failure")
		{
			alert(getHtmlMessage('9'));//提交失败！
			return;
		}else
		{
			sPhaseInfo = PopPage("/Common/WorkFlow/SubmitDialogSecond.jsp?SerialNo="+sTaskNo+"&PhaseOpinion1="+sPhaseInfo,"","dialogWidth=34;dialogHeight=22;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
			//如果提交成功，则刷新页面
			if (sPhaseInfo == "Success")
			{
				alert(getHtmlMessage('18'));//提交成功！
				reloadSelf();
			}else if (sPhaseInfo == "Failure")
			{
				alert(getHtmlMessage('9'));//提交失败！
				return;
			}
		}	
	}
	
	//签署意见
	function signOpinion()
	{
		//获得申请类型、申请流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		//检查抵质押物的入库情况   add ymwu 2010-02-29
		//有无未入库抵质押物01、有02、无
		var sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		var value=popComp("PawnList1","/CreditManage/CreditPutOut/PawnList1.jsp","ContractSerialNo="+sContractSerialNo,"null","dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		//处理方式：01、不在库禁止提交02、不在库只做提示（系统管理员可以在："系统管理---基础配置---代码管理---代码目录--A.管理控制--管理--代码列表---详情---项目号" 进行维护）
		var sColName = "ItemNo";
		var sTableName = "CODE_LIBRARY";
		var sWhereClause = "String@CodeNo@CheckArchive";
		var sReturn = RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('@');
			if(typeof(value)==="undefined"&&"01"===sReturn[1]){
				return;
			}
		}
		
		//获取任务流水号
		sTaskNo=RunMethod("WorkFlowEngine","GetUnfinishedTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo+","+"<%=CurUser.UserID%>");
		if(typeof(sTaskNo)=="undefined" || sTaskNo.length==0) {
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}
		sCompID = "SignTaskOpinion";
		sCompURL = "/Common/WorkFlow/SignTaskOpinionInfo.jsp";
		popComp(sCompID,sCompURL,"TaskNo="+sTaskNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	
	/*~[Describe=查看意见详情;InputParam=无;OutPutParam=无;]~*/
	function viewOpinions()
	{
		//获得出账类型、出账流水号、流程编号、阶段编号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = getItemValue(0,getRow(),"PhaseNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","FlowNo="+sFlowNo+"&PhaseNo=0010&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}

	/*~[Describe=归档;InputParam=无;OutPutParam=无;]~*/
	function archive(){
		//获得出账类型、出账流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('56'))) //您真的想将该信息归档吗？
		{
			//归档操作
			sReturn=RunMethod("BusinessManage","ArchiveBusiness",sObjectNo+","+"<%=StringFunction.getToday()%>"+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {				
				alert(getHtmlMessage('60'));//归档失败！
				return;			
			}else
			{
				reloadSelf();	
				alert(getHtmlMessage('57'));//归档成功！
			}			
		}
	}

	/*~[Describe=取消归档;InputParam=无;OutPutParam=无;]~*/
	function cancelarch(){
		//获得出账类型、出账流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('58'))) //您真的想将该信息归档取消吗？
		{
			//取消归档操作
			sReturn=RunMethod("BusinessManage","CancelArchiveBusiness",sObjectNo+",BUSINESS_PUTOUT");
			if(typeof(sReturn)=="undefined" || sReturn.length==0) {					
				alert(getHtmlMessage('61'));//取消归档失败！
				return;
			}else
			{
				reloadSelf();
				alert(getHtmlMessage('59'));//取消归档成功！
			}
		}
	}
	
	//收回
	function takeBack()
	{
		//所收回任务的流水号
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sFlowNo = getItemValue(0,getRow(),"FlowNo");
		sPhaseNo = "<%=sInitPhaseNo%>";	
		//获取任务流水号
		sTaskNo = RunMethod("WorkFlowEngine","GetTaskNo",sObjectType+","+sObjectNo+","+sFlowNo+","+sPhaseNo);
		if (typeof(sTaskNo) != "undefined" && sTaskNo.length > 0)
		{
			if(confirm(getBusinessMessage('498'))) //确认收回该笔业务吗？
			{
				sRetValue = PopPage("/Common/WorkFlow/TakeBackTaskAction.jsp?SerialNo="+sTaskNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				reloadSelf();
			}
		}else
		{
			alert(getBusinessMessage('500'));//该申请所对应的流程任务不存在，请核对！
			return;
		}				
	}
	
	
	/*~[Describe=打印出账通知书;InputParam=无;OutPutParam=无;]~*/
	function print(){
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sContractSerialNo = getItemValue(0,getRow(),"ContractSerialNo");
		sExchangeType = getItemValue(0,getRow(),"ExchangeType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		sReturn = PopPage("/FormatDoc/PutOut/"+sExchangeType+".jsp?ObjectNo="+sObjectNo+"&ContractSerialNo="+sContractSerialNo,"","");	
	}
	/*~[Describe=发送放款信息至核心;InputParam=无;OutPutParam=无;]~*/
	function sendInfo(){
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm("确认要发送放款信息至核心吗？")){
			sReturnMessage = RunMethod("BusinessManage","DoExchange",sObjectNo+",send");
				alert(sReturnMessage);
			reloadSelf();
		}
		return;
	}
	
	//--added by wwhe 2010-01-13 for:退回至待提交阶段
	function backFirst()
	{
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if(sBusinessType=="2010"){
			alert("银承业务不能退回！");
			return;
		}

		if(!confirm("确认退回出账申请阶段吗？")){
			return ;
		}
		sExchangeState = getItemValue(0,getRow(),"ExchangeState");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(sExchangeState == "1"){//--已下柜
			alert("该笔信息已出账成功，不能退回！");
		}else{
			sReturnValue = RunMethod("BusinessManage","BackFirstPutOutApply",sObjectNo);
			if(sReturnValue == "true"){
				alert("退回成功！");
				reloadSelf();
			}else
				alert("退回失败，请重新操作！");
		}
	}
	//--finished adding wwhe 2010-01-13
	
	//--added by wwhe 2010-02-01 for:修改出账信息
	function changeList()
	{
		sExchangeState = getItemValue(0,getRow(),"ExchangeState");
		if(sExchangeState == "1"){//--已下柜
			alert("该笔信息已出账成功，不能修改！");
			return false;
		}
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sContractNo = getItemValue(0,getRow(),"ContractSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sContractNo = getItemValue(0,getRow(),"ContractSerialNo");
		
		sReturnValue = 	PopComp("ChangeView","/Common/WorkFlow/ChangeView.jsp","ObjectNo="+sObjectNo+"&ContractNo="+sContractNo+"&BusinessType="+sBusinessType,"");
		reloadSelf();
	}
	//--finished adding wwhe 2010-02-01
	
	 /*added by hywu 2008.12.17 查询业务目前审批人*/
	function selectUserName()
	{
	    //获得申请流水号
			sObjectNo = getItemValue(0,getRow(),"ObjectNo");		
			if(typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
			{
				alert(getHtmlMessage('1'));//请选择一条信息！
				return;
			}
			sObjectType = "<%=sObjectType%>";	
			
			sParaString = "ObjectNo,"+sObjectNo+",ObjectType,"+sObjectType;
			setObjectValue("selectUserName",sParaString,"",0,0,"");
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
<script language=javascript>
	
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