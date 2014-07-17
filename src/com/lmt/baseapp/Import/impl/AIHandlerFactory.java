package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.Import.base.EntranceImpl;
import com.lmt.baseapp.Import.base.ExcelBigEntrance;
import com.lmt.baseapp.Import.base.ExcelEntrance;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public class AIHandlerFactory{
	public static void beforeHandle(String sFiles,String sFileType,String Handler,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca)throws Exception{
		if("01".equals(sFileType)){//小型excel
			//导入文件到原始表，始终保持原滋原味
	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih=new ExcelEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih_Iterim=new ExcelEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("03".equals(sFileType)){//大型Excel
			//导入文件到原始表，始终保持原滋原味
	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}
			 	//更新配置号和报表日期
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
	}
	public static void handle(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//先导入到数据库
		AIHandlerFactory.beforeHandle(sFiles, sFileType,HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		//对数据进行初步加工
		if("Customer".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.customerHandle(sConfigNo, sOneKey, Sqlca);
		}else if("Contract".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.contractHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("Duebill".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillR".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillRHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("OperationReport".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.operationReportHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}
	}
	/**
	 * 客户信息导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void customerHandle(String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AICustomerHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//先清空目标表 
		/*Sqlca.executeSQL("Delete from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	String groupBy="case when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '保证+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '保证+抵质押' "+
	 			"when ~s合同明细@其他担保方式e~ = '保证' then '单一保证' "+
	 			"when ~s合同明细@其他担保方式e~ like '%信用%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '信用+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '信用' then '单一信用' "+
	 			"when ~s合同明细@其他担保方式e~ = '抵押' then '单一抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '质押' then '单一质押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '抵押+质押' "+
	 			"else '其他担保' end";
	 	AfterImportCustomerHandler.process(sConfigNo, sOneKey, Sqlca,"混合担保方式",groupBy);
	 	//4、加工后，进行合计，横向纵向分析
	 	AfterImportCustomerHandler.afterProcess(sConfigNo, sOneKey, Sqlca);
	 	*/
	}
	/**
	 * 合同导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void contractHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIContractHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//先清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	String groupBy="case when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '保证+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '保证+抵质押' "+
	 			"when ~s合同明细@其他担保方式e~ = '保证' then '单一保证' "+
	 			"when ~s合同明细@其他担保方式e~ like '%信用%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '信用+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '信用' then '单一信用' "+
	 			"when ~s合同明细@其他担保方式e~ = '抵押' then '单一抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '质押' then '单一质押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '抵押+质押' "+
	 			"else '其他担保' end";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"混合担保方式",groupBy);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIContractHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIDuebillHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		
		AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"归属条线","~s借据明细@归属条线e~","");
 		String groupBy="case "+
 				"when ~s借据明细@经营类型(新)e~ like '%煤炭开采%' or ~s借据明细@经营类型(新)e~ like '%煤炭洗选%' then '煤炭' "+
 				"when ~s借据明细@经营类型(新)e~ like '%焦碳%' then '焦碳' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '%制造业%' or ~s借据明细@经营类型(新)e~ like '%一般加工%' then '制造业' "+//制造业—
 				"when ~s借据明细@经营类型(新)e~ like '%批发零售%' then '批发零售' "+//批发零售—
 				"when ~s借据明细@经营类型(新)e~ like '%钢铁%' then '钢铁' "+
 				"when ~s借据明细@经营类型(新)e~ like '%化工化肥%' then '化工化肥' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%房地产%' then '房地产' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%建筑施工%' then '建筑施工' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%铁矿开采%' then '铁矿开采' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%农林牧副渔%' then '农林牧副渔' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%政府平台%' then '政府平台' "+
				"when ~s借据明细@经营类型(新)e~ like '%钢贸户%' or ~s借据明细@经营类型(新)e~ like '%钢材销售%' then '钢贸户' "+
				"when ~s借据明细@经营类型(新)e~ like '%医药制造%' then '医药制造' "+
				"when ~s借据明细@经营类型(新)e~ like '%燃气生产和供应%' then '燃气生产和供应' "+
				"when ~s借据明细@经营类型(新)e~ like '%汽车维修及销售%' then '汽车维修及销售' "+
				"when ~s借据明细@经营类型(新)e~ like '%电力%' then '电力' "+
				"when ~s借据明细@经营类型(新)e~ like '%住宿餐饮%' then '住宿餐饮' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%交通运输%' then '交通运输' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%医院学校%' then '医院学校' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%信息技术%' then '信息技术' "+
	 			"when ~s借据明细@经营类型(新)e~ like '%文化娱乐%' then '文化娱乐' "+
				"when ~s借据明细@经营类型(新)e~ like '%有色冶炼%' then '有色冶炼' "+
	 			"else '其他' end";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"经营类型(新)",groupBy,"");
	 	
	 	groupBy="case when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=6  then '1M6]' "+
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=12 then '2M(6-12]' "+
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=36 then '3M(12-36]' "+
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=60 then '4M(36-60]' "+
	 						"else '5M(60' end,~s借据明细@业务品种e~";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"期限业务品种",groupBy,"");
	 	
	 	groupBy="case when ~s借据明细@主要担保方式e~ like '保证-%' then '保证' "+
	 			"when ~s借据明细@主要担保方式e~ like '抵押-%' then '抵押' "+
	 			"when ~s借据明细@主要担保方式e~ = '信用' then '信用' "+
	 			"when ~s借据明细@主要担保方式e~ like '%质押-%' or ~s借据明细@主要担保方式e~='保证金' then '质押' "+
	 			"else '其他' end";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"单一担保方式",groupBy,"");
	 	//groupBy="case when case when ~s借据明细@主要担保方式e~='软抵押'  then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=6 end then 六个月以下 "+
			//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=12 end then 十二个月以下"+
			//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=36 end then 三十六个月以下"+
			//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=60 end then 六十个月以下"+
			//		"else case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=6 end then 六十个月以上 end,~s借据明细@业务品种e~";
	 	//AfterImport.process(sConfigNo, sOneKey, Sqlca,"混合担保方式",groupBy);
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"企业规模","~s借据明细@企业规模e~","");
	 	
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"业务品种","~s借据明细@业务品种e~","");
	 	
	 	groupBy="case when ~s借据明细@国家地区e~ like '%太原市%' then '太原市' "+
	 			"when ~s借据明细@国家地区e~ like '%吕梁市%' then '吕梁市' "+
	 			"when ~s借据明细@国家地区e~ like '%晋中市%' then '晋中市' "+
	 			"when ~s借据明细@国家地区e~ like '%朔州市%' then '朔州市' "+
	 			"when ~s借据明细@国家地区e~ like '%临汾市%' then '临汾市' "+
	 			"when ~s借据明细@国家地区e~ like '%长治市%' then '长治市' "+
	 			"when ~s借据明细@国家地区e~ like '%运城市%' then '运城市' "+
	 			"when ~s借据明细@国家地区e~ like '%忻州市%' then '忻州市' "+
	 			"when ~s借据明细@国家地区e~ like '%大同市%' then '大同市' "+
	 			"when ~s借据明细@国家地区e~ like '%晋城市%' then '晋城市' "+
	 			"when ~s借据明细@国家地区e~ like '%阳泉市%' then '阳泉市' "+
	 			"when ~s借据明细@国家地区e~ like '%石家庄市%' then '石家庄市' "+
	 			"when ~s借据明细@国家地区e~ like '%武汉市%' then '武汉市' "+
	 			"when ~s借据明细@国家地区e~ like '%佛山市%' then '佛山市' "+
	 			"else '其他地区' end";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"地区分类",groupBy,"");
	 	
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"机构分类","~s借据明细@直属行名称e~","");
	 	//贷款金额区间
	 	groupBy="case when ~s借据明细@余额(元)e~ >=500000000 then '5亿以上（含5亿）' "+
	 			"when ~s借据明细@余额(元)e~ >=300000000 then '3亿至5亿（含3亿）' "+
	 			"when ~s借据明细@余额(元)e~ >=200000000 then '2亿至3亿（含2亿）' "+
	 			"when ~s借据明细@余额(元)e~ >=100000000 then '1亿至2亿（含1亿）' "+
	 			"when ~s借据明细@余额(元)e~ >=50000000 then '5000万至1亿（含5000万）' "+
	 			"else '5000万以下' end";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"贷款余额区间",groupBy,"");
	 	
	 	
	 	//4、加工后，进行合计，横向纵向分析
	 	AIDuebillHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 零售借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillRHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIDuebillRetailHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
 		String groupBy="case "+
		 				" when ~s个人明细@归属条线e~ ='个人条线' or ~s个人明细@归属条线e~ = '微小条线' or ~s个人明细@归属条线e~ = '零售条线' then '零售条线'"+
		 				" when ~s个人明细@归属条线e~ = '小企业条线' then '小企业条线' "+
		 				" else '其他条线' end";
 		AIDuebillRetailHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"归属条线",groupBy,"and (~s个人明细@业务品种e~<>'个人委托贷款' and ~s个人明细@业务品种e~<>'个人住房公积金贷款')");
	 	//4、加工后，进行合计，横向纵向分析
 		AIDuebillRetailHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 月度经营报告处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void operationReportHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIOperationReportHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//先清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	AIOperationReportHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIOperationReportHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
}