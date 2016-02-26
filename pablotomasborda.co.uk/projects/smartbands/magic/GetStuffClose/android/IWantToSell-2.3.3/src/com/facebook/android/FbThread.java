package com.facebook.android;

import java.io.IOException;
import java.net.MalformedURLException;

import android.os.Bundle;

public class FbThread extends Thread{
	
	public String url;
	public String method;
	public Bundle params;
	public String res;
	
	public FbThread(String url, String method, Bundle params){
		this.url = url;
		this.method = method;
		this.params = params;
		this.res = null;
	
	}

	public void run(){
	try {
		
			res = Util.openUrl(url, method, params);
		

	} catch (MalformedURLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}	}
	
	public String res(){
		return this.res;
	}
	


}
