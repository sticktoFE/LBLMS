package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class DBRiskReportHandler{
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
		/*
		//1������ظ��ͻ�-----��ͬsheetͬһ�ͻ��ظ�ʱ��importNo��ͬ  ��һ��sheet���ظ�ͬһ�ͻ�ʱ��importNo��ͬ��importIndex��ͬ ��
		sSql="delete from Batch_Import BI1 where ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
					" and ~s�ͻ���ϸ@�ͻ�����e~  in "+
						"(select BI2.~s�ͻ���ϸ@�ͻ�����e~ from Batch_Import BI2"+
						" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)"+
					" and ImportNo||ImportIndex not in "+
						"(select max(ImportNo||ImportIndex) from Batch_Import BI2 "+
						" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		sSql="delete from Batch_Import_Interim BI1 where ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
				" and ~s�ͻ���ϸ@�ͻ�����e~  in "+
					"(select BI2.~s�ͻ���ϸ@�ͻ�����e~ from Batch_Import_Interim BI2"+
					" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)"+
				" and ImportNo||ImportIndex not in "+
					"(select max(ImportNo||ImportIndex) from Batch_Import_Interim BI2 "+
					" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s�ͻ���ϸ@�ͻ�����e~ having count(1)>1)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
	}
	/**
	 * ������ά�Ȳ��뵽��������
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//��ǰ�����·ݵ�ǰ������
		boolean isSeason=false;
		String last2month="";
		String last1month="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%06")||StringFunction.isLike(sKey, "%09")||StringFunction.isLike(sKey, "%12")){
			last2month=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			last1month=StringFunction.getRelativeAccountMonth(sKey,"month", -1);
			isSeason=true;
		}
		//1�������߻��ܵ���������
		String sCSql="select OneKey," +
					" Case when ConfigName='������ϸ' then ~s������ϸ@�ͻ�����e~ else ~s�����ϸ@�ͻ�����e~ end CustomerName, " +
					" Case when ConfigName='������ϸ' then ~s������ϸ@��������e~ else ~s�����ϸ@��������e~ end ManageDepartFlag, " +
					" Case when ConfigName='������ϸ' then nvl(~s������ϸ@���e~,0) else nvl(~s�����ϸ@���(Ԫ)e~,0) end BusinessSum, " +
					" Case when ConfigName='������ϸ' then nvl(~s������ϸ@ִ������(%)e~,0) else nvl(~s�����ϸ@ִ��������(%)e~,0) end BusinessRate, " +
					" Case when ConfigName='������ϸ' then ~s������ϸ@�����ʼ��e~ else ~s�����ϸ@�����ʼ��e~ end PutOutDate, " +
					" Case when ConfigName='������ϸ' then nvl(~s������ϸ@���e~,0) else nvl(~s�����ϸ@���(Ԫ)e~,0) end Balance " +
					" from Batch_Import_Interim"+
					" where ConfigName in('������ϸ','�����ϸ') and OneKey='"+sKey+"'"+
					" and case when ConfigName='������ϸ' then ~s������ϸ@ҵ��Ʒ��e~ else '' end <>'����ί�д���'" +
					" and case when ConfigName='������ϸ' then ~s������ϸ@ҵ��Ʒ��e~ else '' end <>'����ס�����������'" +
					//" and case when ConfigName='������ϸ' then nvl(~s������ϸ@���e~,0) else nvl(~s�����ϸ@���(Ԫ)e~,0) end >0"+
					sWhere;
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"',OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when PutOutDate like '"+sKey+"%' then BusinessSum end)/10000,2),"+//����Ͷ�Ž��
				(isSeason==true?"round(sum(case when PutOutDate like '"+last2month+"%' or PutOutDate like '"+last1month+"%' or PutOutDate like '"+sKey+"%' then BusinessSum end)/10000,2)":"0")+","+//����Ǽ���ĩ�����㰴��Ͷ�Ž��
				"round(case when sum(BusinessSum)<>0 then sum(BusinessSum*BusinessRate)/sum(BusinessSum) else 0 end,2), "+//��Ȩ����
				"round(sum(Balance)/10000,2) as Balance, "+
				"count(distinct CustomerName),'"+StringFunction.getTodayNow()+"'"+
				"from ("+sCSql+")tab"+
				" group by OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction,InputTime)"+
 				"( "+
 				sSql+
 				")");
	}
	//����С�� �ϼ� ��������Ƚ�ֵ
	public static void afterProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1���������ά�ȵ�С��
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'С��',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'�ܼ�',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0 "+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3��ռ�ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
		 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSumSeasonRatio,"+
		 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='�ܼ�'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
					"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension and nvl(tab1.DimensionValue,'')=nvl(tab2.DimensionValue,''))tab3"+
			" where tab.Dimension=tab3.Dimension and nvl(tab.DimensionValue,'')=nvl(tab3.DimensionValue,'')";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
	}
}