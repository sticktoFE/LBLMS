package publics;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Counter {

 

    public volatile static int count = 0;

 

    public static void inc() {

 

        //这里延迟1毫秒，使得结果明显

        try {

            Thread.sleep(1);

        } catch (InterruptedException e) {

        }

 

        count++;

    }

 

    public static void main(String[] args) {
    	/*
        //同时启动1000个线程，去进行i++计算，看看实际结果
        for (int i = 0; i < 1000; i++) {
            new Thread(new Runnable() {
                public void run() {
                    Counter.inc();
                }

            }).start();

        }
        //这里每次运行的值都有可能不同,可能为1000
        //System.out.println("运行结果:Counter.count=" + Counter.count);
         */
    	//去除HTML标记
    	/*
    	Pattern  pattern=Pattern . compile("<.+?>",  Pattern.DOTALL) ;
    	Matcher matcher=pattern.matcher("<a href=\"index.html\">主页</a>");
    	//String  string  =  matcher . replaceAll(" ") ;
    	//System.out.println(string);
    	if(matcher.find()){
    		System. out . println(matcher . group( 0 ));
    	}
    	*/
    	
    	Pattern pattern1 = Pattern.compile("(another) (test)");
        StringBuffer sb = new StringBuffer();
        String candidateString = "This is another test.";
        String replacement = "$1 AAA $2";
        Matcher m = pattern1.matcher(candidateString);
        m.find();
        m.appendReplacement(sb, replacement);
        String msg = sb.toString();
        System.out.println(msg);

    }

}