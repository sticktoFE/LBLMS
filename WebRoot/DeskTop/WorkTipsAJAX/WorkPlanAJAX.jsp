<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//�����꣬sFlag ="1"
	String sFlag = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag")));   
	String sSql;
	ASResultSet rs=null;
	String sWorkBrief="",WhereCase="";
	int countPlan=0;
	WhereCase=	" from WORK_RECORD W where W.PromptBeginDate <= '"+StringFunction.getToday()+"' "+
						" and (W.PromptEndDate >= '"+StringFunction.getToday()+"') "+				
						" and (W.ActualFinishDate is null or W.ActualFinishDate='') "+
						" and W.OperateUserID = '"+CurUser.UserID+"'  ";
	if(sFlag.equals("0")){
		sSql = 	" select count(SerialNo) ";
		sSql = sSql+ WhereCase;	
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())  countPlan = rs.getInt(1);
		out.println(countPlan);
	}else if(sFlag.equals("1")){
		sSql = 	" select W.SerialNo,GetItemName('WorkType',WorkType)  as WorkType,"+
					"W.WorkBrief,W.PlanFinishDate,W.ActualFinishDate,"+
					"getOrgName(W.OperateOrgID) as OrgName,getUserName(W.OperateUserID) as UserName,"+
					"Importance,Urgency ";
		sSql = sSql+ WhereCase;	
		rs = Sqlca.getResultSet(sSql);
		int iWorks=1;
		while(rs.next()){
			sWorkBrief = DataConvert.toString(rs.getString("WorkBrief"));
%>
  	    		<tr>
                    <td align="left" title="<%=sWorkBrief%>" >
	                     <%
	                     	String sImportance = DataConvert.toString(rs.getString("Importance"));
	                  		//������Ҫ�ԣ�01��һ�㣻02����Ҫ��03���ǳ���Ҫ��
	                     	if(!sImportance.equals("01")){
	                     %>
	                       <img  width=12 height=12 src="<%=sResourcesPath%>/alarm/icon4.gif">
	                     <%
	                     	}else{
	                     %>
	                       &nbsp;&nbsp;
	                     <%
	                     	}
	                     %>
	                    <a href="javascript:popComp('WorkRecordInfo','/DeskTop/WorkRecordInfo.jsp','SerialNo=<%=rs.getString("SerialNo")%>','dialogwidth:640px;dialogheight:480;')">
	 					<%=iWorks%>
	 					<%=". ["+DataConvert.toString(rs.getString("WorkType"))+"]"%>&nbsp;
						<%
							if(sWorkBrief.length()>10) 
								sWorkBrief = sWorkBrief.substring(0,10)+"...";
								out.println(sWorkBrief);
						%>
                       	</a>
                     </td>
                 <br/>
                 </tr>
				<%
					iWorks++;
						}
				}
				rs.getStatement().close();
				%>
<%@ include file="/IncludeEndAJAX.jsp"%>