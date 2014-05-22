package com.lmt.baseapp.Import.base;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * @author Administrator
 * 
 */
public class ObjRow {
	protected int columnTCount = 0;//������
	protected ArrayList<ObjColumn> columns = new ArrayList<ObjColumn>();
	protected String[][] aReplaceBWithAInValue = null;//�ֶ�ֵ�е�A��Ҫ��B�滻 Ʃ��[['A','B'],['C','D']]
	//��ʼ��metadata
	public ObjRow(String configNo,String Key,ASUser curUser,Transaction Sqlca) throws Exception {
		this.columns.clear();
		//����ģ�嶨��
		ASResultSet rs=Sqlca.getASResultSet("select ItemDescribe,Attribute1,Attribute2,Attribute3 from Code_Library where CodeNo='"+configNo+"' and IsInUse='1'");
		while(rs.next()){
			this.addColumn(rs.getString(1),rs.getString(2),rs.getString(3),"1".equals(rs.getString(4))?true:false);
		}
		//Ĭ�϶�������ֶ�
		this.addColumn("ConfigNo", "���ú�","String",true,false);//��¼ExcelҪ�غ�����Ҫ�ض�Ӧ��ϵ��������Ϣ�ţ�ͬʱ��ʶͬһ���������ݣ����ࣩ
		this.addColumn("Key", "����","String",true,false);//��ʶͬһ���������ݽ�һ�����֣�С�ࣩ��Ʃ��ͬһ�ֱ����Ĳ�ͬ�ڴΣ��Ͱ�ReportDate������
		this.addColumn("ImportNo", "������","String",true,false);//��Ҫ��Ϊ����������֮�䣨�ڴ���+С���ǰ���µ����º���ǰ���ε����֣�
		this.addColumn("ImportIndex", "�������к�","String",true,false);//��¼����������
		this.addColumn("ImportTime", "����ʱ��","String",true,false);//��¼����ʱ��
		this.addColumn("UserID", "������","String",true,false);
		//���ֶ�ֵ�������ַ�������ʽ
		this.setaReplaceBWithAInValue(new String[][] { { "��", "" },{ "\\$", "" }, { ",", "" }, { "\"", "" },{ "��������", "" },{ "�������йɷ����޹�˾", "" }});

		//����Щֵ��㶨ֵ
		this.setString("ConfigNo",configNo);
		this.setString("Key",Key);
		
		SimpleDateFormat sdf=new SimpleDateFormat("'N'yyyyMMdd");
		this.setString("ImportNo",sdf.format(new Date())+"000000");
		this.setString("UserID",curUser.UserID);
		//��ʼ�������(����Ҫ��������ݿ�������ʽ)
		//this.setValueToCode(this.Sqlca);
	}
	public String[][] getaReplaceBWithAInValue() {
		return aReplaceBWithAInValue;
	}

	public void setaReplaceBWithAInValue(String[][] aReplaceBWithAInValue) {
		this.aReplaceBWithAInValue = aReplaceBWithAInValue;
	}

	public int getColumnTCount() {
		return this.columnTCount;
	}
	public void setColumnTCount(int columnTCount) {
		this.columnTCount = columnTCount;
	}
	public void setColumnTCount() {
		this.columnTCount = this.columns.size();
	}
	public ArrayList<ObjColumn> getColumns() {
		return columns;
	}

	public void setColumns(ArrayList<ObjColumn> columns) {
		this.columns = columns;
	}

	public ObjColumn getColumnObjWIF(int index) {
		for (ObjColumn sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public ObjColumn getColumnObjWI(int index) {
		for (ObjColumn sC : this.columns) {
			int iTemp = sC.getIndex();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public ObjColumn getHead(int index) {
		for (ObjColumn sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public String getHeadName(int index) {
		return this.getHead(index).getColumnHeadName();
	}
	public String getHeadName(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnHeadName();
		}
		return null;
	}
	public void setString(int indexInFile, String columnValue) {
		String sTemp = "";
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],aReplaceBWithAInValue[i][1]);
			}
			sC.setSColumnValue(sTemp.trim());
		}
	}
	public void setDouble(int indexInFile, Double columnValue) {
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			sC.setDColumnValue(columnValue);
		}
	}
	public void setString(String column, String columnValue) {
		String sTemp = "";
		if (column==null||column.equals("")) {
			return;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],aReplaceBWithAInValue[i][1]);
			}
			sC.setSColumnValue(sTemp.trim());
		}
	}
	public void setDouble(String column, double columnValue) {
		if (column==null||column.equals("")) {
			return;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setDColumnValue(columnValue);
		}
	}
	public String getString(int index) {
		ObjColumn sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}
	public Double getDouble(int index) {
		ObjColumn sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getDColumnValue();
		}
		return null;
	}
	public ObjColumn getColumnObj(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		for (ObjColumn sC : this.columns) {
			if (sC.containsColumnName(column)) {
				return sC;
			}
		}
		return null;
	}
	public String getColumnTypeWIF(int indexInFile) {
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			return sC.getColumnType();
		}
		return null;
	}
	public String getColumnType(int index) {
		ObjColumn sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getColumnType();
		}
		return null;
	}
	public ObjColumn getColumnObjWH(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		for (ObjColumn sC : this.columns) {
			if (sC.containsHeadName(head)) {
				return sC;
			}
		}
		return null;
	}

	public String getStringWH(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}

	public String getColumnName(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getColumnName();
		}
		return null;
	}
	public String getString(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}
	public Double getDouble(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getDColumnValue();
		}
		return null;
	}

	public HashMap<String, String> getValueCode(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnValueToCode();
		}
		return null;
	}

	public void setValueCode(String column, HashMap<String, String> valueToCode) {
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setColumnValueToCode(valueToCode);
		}
	}

	public String getCodeWH(String head) {
		String sDisplayValue = "";
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			HashMap<String, String> valueToCode = sC.getColumnValueToCode();
			sDisplayValue = this.getStringWH(head);
			if (valueToCode.containsKey(sDisplayValue)) {
				return valueToCode.get(sDisplayValue);
			}
		}
		return sDisplayValue;
	}

	public String getCode(String column) {
		String sDisplayValue = "";
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			HashMap<String, String> valueToCode = sC.getColumnValueToCode();
			sDisplayValue = this.getString(column);
			if (valueToCode.containsKey(sDisplayValue)) {
				return valueToCode.get(sDisplayValue);
			}
		}
		return sDisplayValue;
	}

	/**
	 * 
	 * @param EHTCcolumn
	 * @return false �Ѵ��� ��û������ true ������
	 */
	public boolean addColumn(ObjColumn EHTCcolumn) {
		String sNewColumn = EHTCcolumn.getColumnName();
		if (this.containsColumn(sNewColumn)) {
			System.out.println(sNewColumn + "�ֶ��Ѵ��ڣ��������ӱ��ֶζ���");
			return false;
		}
		String sNewHeadColumn = EHTCcolumn.getColumnHeadName();
		if (this.containsHead(sNewHeadColumn)) {
			System.out.println(sNewHeadColumn + "�����ֶ��Ѵ��ڣ��������ӱ��ֶζ��󣡣�");
			return false;
		}
		this.columns.add(EHTCcolumn);
		this.columnTCount++;
		return true;
	}
	public void addColumn(String columnName, String headName, int indexInFile) {
		ObjColumn eh = new ObjColumn(columnName, "String",headName, indexInFile,this.columnTCount,false,false);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName,String columnType,boolean outFileColumn,boolean primaryKey) {
		ObjColumn eh = new ObjColumn(columnName,columnType,headName,-1,this.columnTCount,outFileColumn,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName,String columnType,boolean primaryKey) {
		ObjColumn eh = new ObjColumn(columnName,columnType,headName,-1,this.columnTCount,false,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName) {
		ObjColumn eh = new ObjColumn(columnName,"String",headName,-1,this.columnTCount,false,false);
		this.addColumn(eh);
	}
	public boolean containsIndexInFile(int indexInFile) {
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			return true;
		}
		return false;
	}
	public boolean containsColumn(String column) {
		if (column == null || "".equals(column)) {
			return false;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return true;
		}
		return false;
	}

	public boolean containsHead(String head) {
		if (head == null || "".equals(head)) {
			return false;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return true;
		}
		return false;
	}

	public int getColumnIndexWH(String head) {
		if (head == null || "".equals(head)) {
			return 0;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getIndexInFile();
		}
		return 0;
	}
	public int getColumnIndex(String column) {
		if (column == null || "".equals(column)) {
			return 0;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getIndexInFile();
		}
		return 0;
	}

	public void setColumnIndexWH(String head, int index) {
		if (head == null || "".equals(head)) {
			return;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			sC.setIndexInFile(index);
		}
	}

	public void setIndexWithColumn(String column, int index) {
		if (column == null || "".equals(column)) {
			return;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setIndexInFile(index);
		}
	}

	protected Exception toException(String message, Exception e) {
		e.printStackTrace();
		return new Exception(message);
	}
}