<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:     cwzhan 2005-1-4
			Tester:
			Content:    ����ģ����ͼ
			Input Param:
	                  
			Output param:
			                
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "����ģ����ͼ"; // ��������ڱ��� <title> PG_TITLE </title>
		String PG_CONTENT_TITLE = "&nbsp;&nbsp;����ģ����ͼ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
		String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
		String PG_LEFT_WIDTH = "200";//Ĭ�ϵ�treeview����
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View02;Describe=�����������ȡ����;]~*/
%>
	<%
		//�������
		
		//����������	
		String sModelNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		String sViewID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ViewID"));
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=View03;Describe=������ͼ;]~*/
%>
	<%
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"����Ŀ¼","right");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

		//������ͼ�ṹ
		String sSqlTreeView = "from CODE_LIBRARY where CodeNo='EvaluateCatalogView' and IsInUse='1' ";
		sSqlTreeView += "and (RelativeCode like '%"+sViewID+"%' or RelativeCode='All') ";//��ͼfilter

		tviTemp.initWithSql("SortNo","ItemName","ItemName","","",sSqlTreeView,"Order By SortNo",Sqlca);
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=View04;Describe=����ҳ��]~*/
%>
	<%@include file="/Resources/CodeParts/View04.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View05;]~*/
%>
	<script language=javascript> 

	function openChildComp(sCompID,sURL,sParameterString){
		sParaStringTmp = "";
		sLastChar=sParameterString.substring(sParameterString.length-1);
		if(sLastChar=="&") sParaStringTmp=sParameterString;
		else sParaStringTmp=sParameterString+"&";

		sParaStringTmp += "ToInheritObj=y&OpenerFunctionName="+getCurTVItem().name;
		OpenComp(sCompID,sURL,sParaStringTmp,"right");
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick()
	{
		var sCurItemID = getCurTVItem().id;
		var sCurItemname = getCurTVItem().name;

		if(sCurItemID=="0010")
		{
			openChildComp("EvaluateCatalogInfo","/Common/Configurator/EvaluateManage/EvaluateCatalogInfo.jsp","ModelNo=<%=sModelNo%>");
			
		}else if(sCurItemID=="0020")
		{
			openChildComp("EvaluateModelList","/Common/Configurator/EvaluateManage/EvaluateModelList.jsp","ModelNo=<%=sModelNo%>");

		}else if(sCurItemID=="0030")    //����
		{
			closeAndReturn();
		}
		setTitle(getCurTVItem().name);
	}



	//����������ı���
	function setTitle(sTitle)
	{
		document.all("table0").cells(0).innerHTML="<font class=pt9white>&nbsp;&nbsp;"+sTitle+"&nbsp;&nbsp;</font>";
	}	
	
	
	function startMenu() 
	{
		<%=tviTemp.generateHTMLTreeView()%>
	}
	
	function closeAndReturn()
	{
		parent.reloadOpener();
		parent.close();
	}
	</script> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=View06;Describe=��ҳ��װ��ʱִ��,��ʼ��]~*/
%>
	<script language="JavaScript">
	startMenu();
	expandNode('root');
	expandNode('10');
	selectItemByName("������Ϣ");
	</script>
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>