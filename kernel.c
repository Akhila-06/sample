void main(void) {
    char* VGA_BUFFER = (char*) 0xb8000;
 
    char* msg = "Hello, World!";
    
    
    
    for(int i=0; msg[i]!='\0'; i++){
        VGA_BUFFER[i * 2] = msg[i];     
        VGA_BUFFER[i * 2 + 1] = 0x0A;  
	

    }
    
    
    while(1){}
}
