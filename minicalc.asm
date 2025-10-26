org 100h  
  
.model small  
.data  
.code  
  
jmp start       ; jump    
msg0:    db      ,0dh,0ah, "---------MiniCalculator 8086----------" ,0dh,0ah,'$'   
                                                                                                                
msg:     db      0dh,0ah, "1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide", 0dh,0ah,"5-Factorial",0dh,0ah,"6-Exponential", 0Dh,0Ah, '$'   
msg1:    db      0dh,0ah, "Enter a number between 1,6 if you want any calculation ::",0Dh,0Ah,'$'  
msg2:    db      0dh,0ah,"Enter First No : $"  
msg3:    db      0dh,0ah,"Enter Second No : $"  
msg4:    db      0dh,0ah,"Choice Error....please Enter any key which is in range (1-6)" , 0Dh,0Ah," $"   
msg5:    db      0dh,0ah,"Result : $"   
msg6:    db      0dh,0ah ,'Thank you for using the calculator! Press any key... ', 0Dh,0Ah, '$'  
msg_error: db 0dh,0ah, "Invalid input! Please enter a valid number.", 0Dh,0Ah, '$'  
msg_again: db 0dh,0ah, "Do you want to perform another operation? (Y/N): $"  
  
start:  mov ah,9  
        mov dx, offset msg0   
        int 21h  
                                             
        mov ah,9  
        mov dx, offset msg   
        int 21h  
          
        mov ah,9                   ; Prompt user for selection  
        mov dx, offset msg1  
        int 21h   
          
        mov ah,0                         
        int 16h    
        cmp al,31h    
        je Addition  
        cmp al,32h  
        je Multiply  
        cmp al,33h  
        je Subtract  
        cmp al,34h  
        je Divide  
        cmp al,35h  
        je Factorial  
        cmp al,36h  
        je Exponential  
        mov ah,09h  
        mov dx, offset msg4  
        int 21h  
        mov ah,0  
        int 16h  
        jmp start   
          
Addition:   mov ah,09h    
            mov dx, offset msg2    
            int 21h  
            mov cx,0   
            call InputNo    
            push dx  
            mov ah,9  
            mov dx, offset msg3  
            int 21h   
            mov cx,0  
            call InputNo  
            pop bx  
            add dx,bx  
            push dx   
            mov ah,9  
            mov dx, offset msg5  
            int 21h  
            mov cx,10000  
            pop dx  
            call View   
            jmp AfterTask  
              
InputNo:    mov ah,0  
            int 16h   
            mov dx,0    
            mov bx,1   
            cmp al,0dh   
            je FormNo   
            cmp al,30h  
            jl InvalidInput  
            cmp al,39h  
            jg InvalidInput  
            sub ax,30h   
            call ViewNo   
            mov ah,0  
            push ax    
            inc cx     
            jmp InputNo   
  
InvalidInput:  ; Handle invalid input case  
            mov ah,9  
            mov dx, offset msg_error ; Display error message  
            int 21h  
            jmp InputNo              ; Retry input  
              
FormNo:     pop ax    
            push dx        
            mul bx  
            pop dx  
            add dx,ax  
            mov ax,bx         
            mov bx,10  
            push dx  
            mul bx  
            pop dx  
            mov bx,ax  
            dec cx  
            cmp cx,0  
            jne FormNo  
            ret     
  
View:  mov ax,dx  
       mov dx,0  
       div cx   
       call ViewNo  
       mov bx,dx   
       mov dx,0  
       mov ax,cx   
       mov cx,10  
       div cx  
       mov dx,bx   
       mov cx,ax  
       cmp ax,0  
       jne View  
       ret  
  
ViewNo:    push ax  
           push dx   
           mov dx,ax   
           add dl,30h   
           mov ah,2  
           int 21h  
           pop dx    
           pop ax  
           ret  
         
exit:   mov dx,offset msg6  
        mov ah, 09h  
        int 21h    
        mov ah, 0  
        int 16h  
        ret  
  
AfterTask:  ; Ask the user if they want to perform another operation  
        mov ah,9  
        mov dx, offset msg_again  
        int 21h  
        mov ah,0  
        int 16h  
        cmp al,'Y'     ; If 'Y', return to main menu  
        je start  
        cmp al,'N'     ; If 'N', exit  
        je exit  
        jmp AfterTask  ; If invalid input, ask again  
  
Multiply:   mov ah,09h  
            mov dx, offset msg2  
            int 21h  
            mov cx,0  
            call InputNo  
            push dx  
            mov ah,9  
            mov dx, offset msg3  
            int 21h   
            mov cx,0  
            call InputNo  
            pop bx  
            mov ax,dx  
            mul bx   
            mov dx,ax  
            push dx   
            mov ah,9  
            mov dx, offset msg5  
            int 21h  
            mov cx,10000  
            pop dx  
            call View   
            jmp AfterTask   
  
Subtract:   mov ah,09h  
            mov dx, offset msg2  
            int 21h  
            mov cx,0  
            call InputNo  
            push dx  
            mov ah,9  
            mov dx, offset msg3  
            int 21h   
            mov cx,0  
            call InputNo  
            pop bx  
            sub bx,dx  
            mov dx,bx  
            push dx   
            mov ah,9  
            mov dx, offset msg5  
            int 21h  
            mov cx,10000  
            pop dx  
            call View   
            jmp AfterTask  
      
Divide:     mov ah,09h  
            mov dx, offset msg2  
            int 21h  
            mov cx,0  
            call InputNo  
            push dx  
            mov ah,9  
            mov dx, offset msg3  
            int 21h   
            mov cx,0  
            call InputNo  
            pop bx  
            mov ax,bx  
            mov cx,dx  
            mov dx,0  
            mov bx,0  
            div cx  
            mov bx,dx  
            mov dx,ax  
            push bx   
            push dx   
            mov ah,9  
            mov dx, offset msg5  
            int 21h  
            mov cx,10000  
            pop dx  
            call View  
            pop bx  
            cmp bx,0  
            je exit   
            jmp exit  
  
Factorial:  mov ah,09h  
            mov dx, offset msg2  
            int 21h  
            mov cx,0  
            call InputNo  
            mov cx,dx  
            mov ax,1  
FactorialLoop:  
            cmp cx,0  
            je FactorialDone  
            mul cx  
            dec cx  
            jmp FactorialLoop  
FactorialDone:  
            push ax  
            mov ah,9  
            mov dx, offset msg5  
            int 21h  
            mov cx,10000  
            pop dx  
            call View  
            jmp AfterTask  
  
Exponential:   
    mov ah,09h  
    mov dx, offset msg2  
    int 21h  
    mov cx,0  
    call InputNo  
    push dx               ; Base  
    mov ah,9  
    mov dx, offset msg3  
    int 21h  
    mov cx,0  
    call InputNo  
    pop bx                ; Base stored in BX  
    mov cx, dx            ; Exponent stored in CX  
    mov ax, 1             ; Initialize result (AX will hold the result)  
  
ExponentiationLoop:  
    cmp cx, 0             ; If exponent is zero, we are done  
    je ExponentialDone  
    mul bx                ; Multiply result (AX) by the base (BX)  
    dec cx                ; Decrement the exponent (CX)  
    jmp ExponentiationLoop  
  
ExponentialDone:  
    push ax               ; Push the result  
    mov ah,9  
    mov dx, offset msg5  
    int 21h  
    mov cx,10000  
    pop dx  
    call View  
    jmp AfterTask  
  
ret