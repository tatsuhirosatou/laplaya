Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	
        ; variables hongo
        deltax db -1
	deltay db 1
	xpos db 2
	ypos db 2
        rebotes db 5
	dummy db ? ; Se utiliza esta variable para no modificar el numero de rebotes (se necesita saber el numero de rebotes para cuando el programa deje de borrar)
	borrar db 3
        ;Selecciona cual background va a dibujar el hongo
	backgroundSelect1 db 0
	
 
        ; variables flor
        deltax2 db 1
        deltay2 db 1
        xpos2 db 30
        ypos2 db 10
        rebotes2 db 5
        dummy2 db ?
        borrar2 db 3
        ;Selecciona cual background va a dibujar la flor
	backgroundSelect2 db 0
        
        ; delay
        delay dw 0009h
        
        ;mapa de borron
	erasePixel db 4000 dup(0)
        ;paso intermedio para escritura de video
        render db 4000 dup(0)
	;mapa del segundo background
	bowserCastle db 4000 dup(22h)
	
	;variable intermedia para verificar que no se copie donde se borro
	onlyErase db 4000 dup(0)

	
	

        ;colores
	red db 44h
	white db 0ffh
	blue db 11h
	green db 22h
	brown db 66h
	yellow db 0eeh
.code

;Esta subrutina mueve un pixel del objecto por una cantidad deltax y deltay
moveOb macro deltax, deltay, xpos, ypos, borrar, dummy, rebotes, height, widthh, bgType
	push ax
	push bx
	push cx
	
	mov cl, height
	mov ch, widthh
	moveD deltay, ypos
	
	;Aqui se debe verificar si se salio de la parte inferior o superior de la pantalla
	;checkCoordinatesnew xpos, ypos, 6, 4; 6 y 3 son el ancho y el largo de la imagen
	checkPixel deltay, ypos, 25, height, borrar, dummy, rebotes, bgType
	
	moveD deltax, xpos
	;Aqui se deber verificar si se salio de la parte derecha o izquierda de la pantalla
	checkPixel deltax, xpos, 79, widthh, borrar, dummy, rebotes, bgType
	pop cx
	pop bx
	pop ax
endm

;Especifica que pixeles de video se tienen que borrar. Lo hace guardando esta informacion en una variable tipo array (Creado por Jaime el 14 de octubre de 2009)
setErasePixels macro borrar, muneco, bgType
        local dontDoAnything, noSetPixel, finished, writeBack2
        cmp borrar, 3; Si esta en el estado 3, el estado de flotar, simplemente sal de la subrutina. 
	je dontDoAnything

	push ax; Guardar a ax
	push cx
	    
        mov ah, white; Guardar valores originales de white y red 
        mov al, red
	mov ch, green
	
     
	cmp borrar, 1
        jnz noSetPixel
        cmp bgType, 1
	je writeBack2
        mov white, 0; Poner 0 el red y white para cuando se escriba el hongo en el mapa de borrar lo que alla es un hongo compuesto de 0s. 
        mov red, 0
	mov green, 0
     
	muneco 1; Escribir el hongo que consiste de 0s al mapa de borrar. 
        
	jmp finished
        	
	noSetPixel:
	
	
	mov white,1; Poner 1 el red y white para cuando se escriba el hongo en el mapa de borrar lo que alla es un hongo compuesto de 1s. 
        mov red, 1
	mov green, 1
	muneco 1; Escribir el hongo que consiste de 1s al mapa de borrar. 
	jmp finished
	
	writeBack2:
	mov white, 2
	mov red, 2
	mov green, 2
	muneco 1
        
        finished:
        mov white, ah; Restaurar white y red
        mov red, al
	mov green, ch

	pop cx
	pop ax
        dontDoAnything:

endm



;Esta subrutina dibuja el objeto que va a rebotar en la pantalla utilizando las variables xpos y ypos como referencia(Creado por Jaime el 15 de octubre de 2009)

mushroom macro location
	local supRed
        local infRed
        local whitePart

	push ax
	push bx
	push cx
	push dx
	
	mov bx, 0
	mov dh, ypos
	mov dl, xpos
	push dx
	add xpos, 1
	
	mov cx, 4
	supRed:
		colorpixel ypos, xpos, red, location
		add xpos, 1
	loop supRed
	add ypos, 1
	
	pop dx
	mov xpos, dl
	push dx
	mov cx, 6
	
	infRed:
		colorpixel ypos, xpos, red, location
		add xpos, 1
	loop infRed
	add ypos, 1
	
	pop dx
	mov xpos, dl
	push dx
	add xpos, 1
	mov cx, 4
	whitePart:
		colorpixel ypos, xpos, white, location
		add xpos, 1
	loop whitePart
	
	pop dx
	mov xpos, dl
	mov ypos, dh
	
	pop dx
	pop cx
	pop bx
	pop ax

endm

                                                                     
                                                                     
                                                                     
                                             
;Este macro dibuja una flor
flower macro location
local fwhite
local swhite
local twhite
local yello
local hoja
local verde

push ax
push bx
push cx
push dx

mov bx, 0
mov dh, ypos2
mov dl, xpos2
push dx
add xpos2, 1

mov cx, 3
fwhite:
colorpixel ypos2, xpos2, white, location
add xpos2, 1
loop fwhite
add ypos2, 1

pop dx
mov xpos2, dl
push dx
mov cx, 5

swhite:
colorpixel ypos2, xpos2, white, location
add xpos2, 1
loop swhite

;---yello---
pop dx
mov xpos2, dl
add xpos2, 1
push dx
mov cx, 3
yello:
colorpixel ypos2, xpos2, red, location
add xpos2, 1
loop yello


add ypos2,1

pop dx

mov xpos2, dl
push dx
add xpos2, 1
mov cx, 3

twhite:
colorpixel ypos2, xpos2, white, location
add xpos2, 1
loop twhite

pop dx





add ypos2, 1
mov xpos2, dl
;add xpos2,1
push dx
mov cx, 3

hoja:
colorpixel ypos2, xpos2, green, location
add xpos2, 2;
loop hoja
pop dx

add ypos2, 1
mov xpos2, dl
add xpos2,1
push dx
mov cx, 3

verde:
colorpixel ypos2, xpos2, green, location
add xpos2, 1
loop verde
pop dx


mov xpos2, dl
mov ypos2, dh

pop dx
pop cx
pop bx
pop ax

endm
;Necesita las coordenadas en dx, dh es la fila y dl es la columna(creado por Jaime 15 de octubre de 2009)
cloud macro
	local paintingMidCloud
	local paintingMid
	local paintingSupCloud
	local paintingInfCloud
	
	push ax
	push cx
	push dx
	mov cx, 6
	paintingSupCloud:
		colorPixel dh, dl, white, 2
		inc dl
	loop paintingSupCloud
	
	pop dx
	sub dl, 2
	add dh, 1
	push dx
	mov cx, 2
	
	paintingMidCloud:
		push cx
		mov cx, 10
		paintingMid:
			colorPixel dh, dl, white, 2
			inc dl
		loop paintingMid
		mov al, dh
		pop cx
		pop dx
		push dx
		inc al
		mov dh, al	
	loop paintingMidCloud
	
	pop dx
	add dl, 2
	add dh, 2
	push dx
	mov cx, 6
	paintingInfCloud:
		colorPixel dh, dl, white, 2
		inc dl
	loop paintingInfCloud
	pop dx
	pop cx
	pop ax
endm

;Dibuja un bloque marron (Creado por Jaime 16 de octubre de 2009)
block macro
local paintingBlock
local painting

push ax
push cx
push dx

mov cx, 2
paintingBlock:
	push cx
	mov cx, 4
	painting:
		colorPixel dh, dl, brown, 2
		inc dl
	loop painting
	mov al, dh
	pop cx
	pop dx
	push dx
	inc al
	mov dh, al	
loop paintingBlock

pop dx
pop cx
pop ax
endm


bush macro
local paintingBushInf
local paintingBushMid
local paintingBushSup
push ax
push cx
push dx

mov cx, 7
paintingBushInf:
	colorPixel dh, dl, green, 2
	inc dl
loop paintingBushInf

pop dx
push dx

sub dh, 1
add dl, 1
mov cx, 5

paintingBushMid:
	colorPixel dh, dl, green, 2
	inc dl
loop paintingBushMid

pop dx
push dx

sub dh, 2
add dl, 2
mov cx, 3
paintingBushSup:
	colorPixel dh, dl, green, 2
	inc dl
loop paintingBushSup

pop dx
pop cx
pop ax
endm


;Macro que determina la localizacion de un desplazamiento utilizando las filas y columnas y devolviendo el valor en el registro bx(Creado por Jaime el 13 de octubre de 2009)
coordenadas macro fila, columna
	push ax
	mov al, fila
	mov ah, 0
	mov bl, 160
	mul bl
	
	mov bx, ax
	add bl, columna
	adc bh, 0
	add bl, columna
	adc bh, 0
	pop ax
endm

;Macro que actualiza la posicion del objeto utilizando como parametros el cambio en direccion y la posicion actual(Creado por Jaime el 13 de octubre de 2009)
moveD macro delta, pos
	push ax
	mov al, delta
	mov ah, 0
	mov bl, pos
	add bl, al
	mov pos, bl
	pop ax
endm

;Macro que verifica si el objeto debe comenzar a borrar la imagen(Creado por Jaime el 14 de octubre de 2009)
setErase macro borrar, dummy, rebotes, bgType
        ; Borrar
        ; Estado 3 = No hacer nada, flotar
        ; Estado 1 = Escribir el background
        ; Estado 0 = Borrar el background
	local noSetErase
        local writing
        local normal     

        push ax; Guardar a ax

        cmp borrar, 3; En el estado 3 no hacer nada
        jnz normal; Verificar si borrar esta en el estado 0 o 1
		
        sub dummy,1; Disminuir dummy
        jnz noSetErase; Si dummy no es cero salir del macro
		
        mov al, rebotes; Si se llega a cero pasar rebotes a al para restaurar dummy
        mov dummy, al; Restaurar dummy al numero de rebotes
        add dummy, 1; Añadirle 1 a dummy porque se le va a restar uno ahora aunque no halla chocado
        mov borrar, 0; Setear borrar al estado 0, el de borrar. 

        normal:

        cmp borrar, 1; Verificar si esta en el estado 1
        je writing; Escribir el background
		
	sub dummy, 1; Disminuir dummy
	jnz noSetErase; Si no es cero salir del macro
	
        mov al, rebotes; Si es cero restuarar dummy y setear borrar al estado 1
        mov dummy, al
	mov borrar,1
        xor bgType,01h; Alternar bakgroundSelect
        
        jmp noSetErase; Salir del macro
	
	writing: 
        sub dummy, 1; Disminuir dummy
        jnz noSetErase; Salir del macro si no es cero
		
        mov al, rebotes; ; Si es cero restaurar dummy y pasar al estado 3
        mov dummy, al
        mov borrar, 3     
        
	noSetErase:
        pop ax
endm

;Macro que utiliza como parametros la fila, columna y el color en el que se va a dibujar un pixel en video
colorPixel macro fila, columna, color, memoria
        ;Memoria 1 = Mapa de donde se va a borrar
        ;Memoria 2 = Memoria render, la memoria intermedia que despues se copia a la memoria de video
        ;Memoria 3 = Memoria de video
		;Memoria 4 = Memoria del segundo background

	local escribirABorron
        local escribirARender
        local escribirAVideo
        local terminado
		local escribirABackground2
		local erasePix
		
	push ax
	push bx
	push cx
	
	mov cx, memoria; Guardar a cx el numero de memoria a donde se va a escribir
	coordenadas fila, columna; Buscar las coordenadas
	mov ah, color; Guardar el color que se va a escribir
	mov al, 0
        cmp cx, 1
        je escribirABorron
        cmp cx, 2
        je escribirARender
        cmp cx, 3
        je escribirAVideo
		cmp cx, 4
		je escribirABackground2
		

        escribirABorron: 
		call writeToBorron
        jmp terminado 

        escribirARender:
		call writeToRender
		jmp terminado

	escribirAVideo: 
		call writeToVideo
        jmp terminado
		
		escribirABackground2:
		call writeToBack2
		jmp terminado
	

        terminado:
	pop cx
	pop bx
	pop ax
endm


;Macro que determina si el objeto se salio de la pantalla y le cambia la direccion para arreglarlo. (Creado por Jaime 24 de octubre de 2009)
checkPixel macro delta, pos, border, lengthh, borrar, dummy, rebotes, bgType

  local outBorder
  local boundaryChecked
  
  push ax
  mov al, border
  mov ah, lengthh
  
  sub al, ah ;Esta resta se hace con el proposito de verificar hasta que punto relativo puede moverse el objeto
  
  cmp pos, 0
  jl outBorder;if pos is negative
  cmp pos, al
  jg outBorder; if pos is bigger 
  jmp boundaryChecked
  
  
  outBorder:
    changeDelta delta, pos, borrar, dummy, rebotes, bgType
    
  boundaryChecked:
  pop ax

endm

;Macro que cambia direccion a la que se mueve el objeto. (Creado por Jaime 24 de octubre de 2009)
changeDelta macro delta, pos, borrar, dummy, rebotes, bgType
	neg delta
	moveD delta, pos
	setErase borrar, dummy, rebotes, bgType
endm


;Programa simple que simula el movimiento de un objeto en una pantalla de video, usa deltax y deltay para determinar cuanto se mueve el objeto(Creado por Jaime el 13 de octubre de 2009)
main proc
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 1000

	mov al, rebotes
	mov dummy, al

        mov al, rebotes2
        mov dummy2, al
	
	again:
	setErasePixels borrar, mushroom, backgroundSelect1
        setErasePixels borrar2, flower, backgroundSelect2
	moveOb deltax, deltay, xpos, ypos, borrar, dummy, rebotes, 3, 5, backgroundSelect1 ;Actualiza las variables posx y posy para que el objeto se dibuje en una parte diferente
        moveOb deltax2, deltay2, xpos2, ypos2, borrar2, dummy2, rebotes2, 5, 4, backgroundSelect2
        
        call background; Dibjar background en "render"
        call eraser; borrar lo que alla que borrar
        mushroom 2; escribir hongo en "render"
        flower 2; escribir flower en "render"
               
        call doRender; copiar render a memoria de video
	
	
	call sleep
	
	loop jumpFarther
	jmp finishMain
	
	jumpfarther:
	jmp again
	
	finishMain:
	mov ax, 4c00h
	int 21h
main endp

doRender proc
         push ax; Guardar los registros
         push bx
         push cx

         mov cx, 2000; Repeat for all of video memeroy
         
         ; Move data from render to video memory
         renderLoop:    
	 mov al, render[bx]; move data from bx to ax
	 inc bx
	 mov ah, render[bx]
	 dec bx
         mov es:[bx], ax; write to video memory
         inc bx; increment memory index
         inc bx
         loop renderLoop
         
	 pop cx
         pop bx
         pop ax
	 ret
doRender endp

;Esta subrutina manipula la velocidad a la que va a correr el programa utilizando la variable delay(Creado por Jaime el 13 de octubre de 2009)
sleep proc
	push cx
	
	mov cx, delay
	sleepingag:
		push cx
		mov cx, 0afffh
		sleeping:
		loop sleeping
		pop cx
	loop sleepingag
	
	pop cx
	ret
sleep endp

;Verifica si el objeto se salio de la pantalla y si esto ocurre, cambia la direccion a la que se va a mover

;Borra la parte de la pantalla que se debe borrar luego de que el objeto rebota varias veces en la pantalla (Creado por Jaime el 14 de octubre de 2009)
eraser proc
	push ax
	push cx
	push bx
	
	mov cx, 2000
	mov bx, 0
	checkErase:
		cmp erasePixel[bx], 1 ; Verifica si se debe borrar el pixel apuntado por bx
		jnz CheckifDrawBack2 ;If el pixel no es cero, vuelve a iterar
		mov ax, 0h
		mov render[bx], al
		inc bx
		mov render[bx], ah
		dec bx
		jmp doNothing
		
		CheckifDrawBack2:
		cmp erasePixel[bx], 2
		jnz doNothing
		mov al, bowserCastle[bx]
		mov render[bx], al
		inc bx
		mov al, bowserCastle[bx]
		mov render[bx], al
		dec bx
		
		doNothing:
		inc bx
		inc bx
	loop checkErase
	
	pop bx
	pop cx
	pop ax
	ret
eraser endp


background proc
	push ax
	push bx
	push cx
	push dx
	
	mov bx, 0
	mov cx, 1600
	paintingSky:
		mov ah, blue
		mov al, 0
		mov render[bx], al
		inc bx
		mov render[bx], ah
		inc bx
	loop paintingSky
	
	mov cx, 400
	paintingGround:
		mov ah, brown
		mov al, 0
		mov render[bx], al
		inc bx
		mov render[bx], ah
		inc bx
	loop paintingGround
	
	mov dl, 71
	mov dh, 14
	push dx
	mov cx, 3
	paintingSupPipe:
		push cx
		mov cx, 9
		paintingSup:
			colorPixel dh, dl, green, 2
			inc dl
		loop paintingSup
		mov al, dh
		pop cx
		pop dx
		push dx
		inc al
		mov dh, al
	loop paintingSupPipe
	
	pop dx
	mov dl, 73
	mov dh, 17
	push dx
	mov cx, 3

	paintingInfPipe:
		push cx
		mov cx, 7
		paintingInf:
			colorPixel dh, dl, green, 2
			inc dl
		loop paintingInf
		mov al, dh
		pop cx
		pop dx
		push dx
		inc al
		mov dh, al
	loop paintingInfPipe
	
	mov dh, 0
	mov dl, 7
	cloud
		
	mov dh, 0
	mov dl, 65
	cloud

	mov dh, 12
	mov dl, 12
	block
		
	mov cx, 3
	mov dh, 12
	mov dl, 30
	paintingBlocks:
		block
		add dl, 6
	loop paintingBlocks
	
	mov dh, 6
	mov dl, 36
	block
	
	
	mov dh, 19
	mov dl, 5
	bush
	
	mov dh, 19
	mov dl, 60
	bush
		
	
	pop dx
	pop dx
	pop cx
	pop bx
	pop ax
	ret
background endp

writeToBorron proc

	cmp ah, 1 ;Si es uno se borra, por lo tanto se debe cambiar el pixel independientemente del background que se utilice
	je erasePix		
		
	cmp erasePixel[bx], 1 ;Si el pixel en el que se va a escribir es uno, es que este espacio ya se borro y se le puede escribir encima con cualquiera de los dos backgrounds
	je erasePix
	jmp endWriteBorr
		
	erasePix:
	mov erasePixel[bx], ah; Escribir en la coordenada bx el color ah en la mapa de borron
	inc bx
	mov erasePixel[bx], ah; Repetir para el proximo byte
    endWriteBorr:
ret
writeToBorron endp


writeToRender proc

	mov render[bx], al; Escribir en la coordenada bx 0
	inc bx
	mov render[bx], ah; Escribir en el proximo byte el color ah

ret
writeToRender endp


writeToVideo proc
	escribirAVideo: mov es:[bx], ax; Pasar el byte entero a la memoria de video
ret
writeToVideo endp

writeToBack2 proc
	mov bowserCastle, al
	mov bowserCastle, ah
	ret
writeToBack2 endp




		


end main
	