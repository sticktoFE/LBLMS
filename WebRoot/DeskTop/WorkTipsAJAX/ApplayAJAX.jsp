<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//�����꣬sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	WhereCase=	" from BUSINESS_APPLY BA, FLOW_TASK FT "+
		" where BA.SerialNo = FT.ObjectNo "+
		" and FT.ObjectType='CreditApply' "+
		" and FT.UserID='"+CurUser.UserID+"' "+
		" and (FT.EndTime is null "+
		" or FT.EndTime = '') "+
		" and (FT.PhaseAction is null "+
		" or FT.PhaseAction = '') ";
	
	if(sFlag.equals("0"))
	{
		sSql = 	" select count(BA.SerialNo) ";
		sSql = sSql+ WhereCase;	
		rsTips = Sqlca.getResultSet(sSql);
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay);
	}
	else if(sFlag.equals("1"))
	{
		sSql= 	" select getBusinessName(BA.BusinessType)||'&nbsp;['||BA.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
		" BA.BusinessSum,FT.ApplyType,FT.BeginTime,FT.PhaseName,FT.PhaseNo,FT.PhaseType ";
		sSql = sSql+ WhereCase;	
	
	rsTips = Sqlca.getResultSet(sSql);
	while(rsTips.next())
	{
	if (rsTips.getString(4).substring(0,10).equals(StringFunction.getToday()))
		sTipsFlag="&nbsp;&nbsp;";
	else
		sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='�ù�����������ѳ���1��'>&nbsp;";
%>
                      	<tr>
         <%
         	if(rsTips.getString(6).equals("0010") || rsTips.getString(6).equals("3000"))
                               	{//������δ�ύ�򷢻ز�������
         %>
                      	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=<%=rsTips.getString(3)%>&PhaseType=<%=rsTips.getString(7)%>&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
         <%
         	}else
                              	{//���������
         %>
                     		<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApproveMain','/Common/WorkFlow/ApproveMain.jsp','ApproveType=ApproveCreditApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
         <%
         	}
         %>
                     		<td align="right" valign="bottom"><%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                     	<br/></tr>
		<%
			}
			}
			rsTips.getStatement().close();
		%>
<%@ include file="/IncludeEndAJAX.jsp"%>