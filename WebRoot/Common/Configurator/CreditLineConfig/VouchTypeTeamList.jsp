<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: zywei 2005-11-29 
			Tester:
			Content: ������ʽ������Ϣ�б�
			Input Param:
			
			Output param:
			
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "������ʽ������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>

<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][]={ 
				{"CLTeamID","������ʽ������"},
			    {"CLTeamName","������ʽ��������"},
			    {"CLTeamContentName","������ʽ��������"},
			    {"CLTeamLimit","������ʽ������������"},
			    {"CLTeamRelaObj","������ʽ�����������"},
			    {"IsInUse","�Ƿ���Ч"}
			  };
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sSql = " select CLTeamID,CLTeamName,CLTeamContentID,CLTeamContentName, "+
	              " CLTeamLimit,CLTeamRelaObj,getItemName('IsInUse',IsInUse) as IsInUse "+	             
	              " from CL_TEAM "+
	              " where CLTeamType = 'VouchTypeTeam' ";
	//����Sql�������ݶ���DataObject              
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ���
	doTemp.setHeader(sHeaders);
	//���ñ���������
	doTemp.UpdateTable="CL_TEAM";
	doTemp.setKey("CLTeamID",true);
	doTemp.setAlign("IsInUse","2");
	//����������
	doTemp.setVisible("CLTeamContentID",false);
	
	doTemp.setHTMLStyle("CLTeamContentName","style={width:300px}");
	doTemp.setHTMLStyle("IsInUse","style={width:60px}");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);	
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));	
	//out.println(doTemp.SourceSql); //������仰����datawindow
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
	<%
		//����Ϊ��
			//0.�Ƿ���ʾ
			//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
			//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.��ť����
			//4.˵������
			//5.�¼�
			//6.��ԴͼƬ·��
		String sButtons[][] = {
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}		
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/CreditLineConfig/VouchTypeTeamInfo.jsp","_self","");
		
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCLTeamID = getItemValue(0,getRow(),"CLTeamID");
		
		if (typeof(sCLTeamID)=="undefined" || sCLTeamID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sCLTeamID=getItemValue(0,getRow(),"CLTeamID");
		if (typeof(sCLTeamID)=="undefined" || sCLTeamID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		OpenPage("/Common/Configurator/CreditLineConfig/VouchTypeTeamInfo.jsp?CLTeamID="+sCLTeamID,"_self","");
	}
	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>