<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="com.amarsoft.impl.jsbank_als.CheckGuarantyEnterpriseLimit,com.lmt.app.lending.bizlets.*"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: FMWu 2004-12-17
			Tester:
			Describe: 检查意见是否签署，一般在任务提交前检查
			Input Param:
		SerialNo:任务流水号
			Output Param:
			HistoryLog:zywei 2005/08/01
		
		 */
	%>
<%
	/*~END~*/
%> 
<%!/**
		 * 
		 * @param CreditAggreement
		 * @return
		 * @throws Exception
		 */
		private static boolean getRight(Transaction Sqlca,String CreditAggreement) throws Exception{
			boolean bFlag = false;
			String sSql = "";
			ASResultSet rs = null;
			String sIndustryType1 = "";//特殊客户类型
			try{
				sSql =  " select IndustryType1 from ENT_INFO  where CustomerID in " +
						"( select CustomerID from BUSINESS_CONTRACT  where SerialNo = '"+CreditAggreement+"') ";
				System.out.println("sSql    "+sSql);
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()){
					sIndustryType1 = rs.getString("IndustryType1");
				}
				rs.getStatement().close();
				if(sIndustryType1 == null) sIndustryType1 = "";
		
				//判断特殊客户类型是否为晋钢通
				if(sIndustryType1.equals("8")){
					bFlag = true;
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return bFlag;
		}%>
<%
	//获取参数
		String sApplyType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ApplyType")));
		String sOrgID = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("OrgID")));
		String sCustomerType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerType")));
		String sCreditAggreement = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CreditAggreement")));
		String sBusinessSubType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessSubType")));
		String sIsJGT = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsJGT")));
		//定义变量
		String sSql = "",sPhaseOpinion = "",sMessage="true",sCustomerID="",sBusinessType = "";
		String sFlowNo = "";
		
		//判断是否为支行权限 2011-5-4
		if(sIsJGT.equals("1")&&getRight(Sqlca,sCreditAggreement)&&sApplyType.equals("DependentApply")){
	//满足支行权限
	sFlowNo= "CreditNormalFlow3";
		}else if(sOrgID.equals("14")){
		if(sApplyType.equals("PutOutApply")){
			sFlowNo = "MicroPutOutFlow";
		}else{
			sFlowNo = "CreditMicroFlow";
		}
		}else if(sCustomerType.equals("03")){
		sFlowNo= "CreditRetailFlow";
		}else if((sOrgID.equals("01")&&(sCreditAggreement == null||sCreditAggreement.trim().equals(""))||sOrgID.equals("02"))&&sApplyType.equals("DependentApply")){//总行营业部或者中小企业专营中心
		sFlowNo= "CreditNormalFlow";
		}else if((sCreditAggreement == null||sCreditAggreement.trim().equals(""))&&sApplyType.equals("DependentApply")){//单笔业务（特别授信）
		sFlowNo= "CreditNormalFlow1";
		}else{
	sFlowNo = DataConvert.toString(Sqlca.getString("select Attribute2 from CODE_LIBRARY where CodeNo = 'ApplyType' and ItemNo = '"+sApplyType+"'"));
		}
		//如果申请一笔新发生的业务或只是申请额度，且在BUSINESS_TYPE中指定了审批流程,则从之中取得审批流程编号和初始阶段编号，并覆盖掉已经取得的默认值；
		sSql = " select Attribute9 from Business_Apply BA,Business_Type BT "+
		" where BA.BusinessType=BT.TypeNo"+
		" and BA.SerialNo='sObjectNo') ";
%>

<script language=javascript>
	self.returnValue = "<%=sFlowNo%>";
	self.close();	
</script>
<%@ include file="/IncludeEnd.jsp"%>
