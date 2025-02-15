	@ECHO OFF
	cd /d %~dp0
	"C:\Windows\Microsoft.NET\Framework\v4.0.30319\RegAsm.exe" /u "WebView2.dll" /tlb "WebView2.tlb"
	PAUSE
	CLS