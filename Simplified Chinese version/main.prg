If _vfp.StartMode <> 0 Then 
   Erase ( Addbs( Getenv("TEMP") ) + "*.fxp" )
Endif 
   
Do Form ���������.scx
Read Events
 
 