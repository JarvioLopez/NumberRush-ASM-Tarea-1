; ============================================================
;  NUMBER RUSH 64-bit - Elige el número MAS GRANDE
;  Version NATIVA Windows 64 bits (doble click y juega .exe)
; ------------------------------------------------------------
;  Compilar (Windows 64 siempre):
;    compilar.bat para JUGAR!
; ============================================================
BITS 64
DEFAULT REL

global start
extern GetStdHandle
extern WriteFile
extern ReadFile
extern GetTickCount
extern Beep
extern SetConsoleTitleA
extern ExitProcess
extern GetConsoleMode
extern SetConsoleMode
extern SetConsoleOutputCP
extern ReadConsoleInputA
extern FlushConsoleInputBuffer

section .data
    ; ---- Colores ANSI ----
    cClear     db 0x1B,'[2J',0x1B,'[H'
    cClear_len equ $ - cClear
    cReset     db 0x1B,'[0m'
    cReset_len equ $ - cReset
    cBold      db 0x1B,'[1m'
    cBold_len  equ $ - cBold
    cRed       db 0x1B,'[91m'
    cRed_len   equ $ - cRed
    cGreen     db 0x1B,'[92m'
    cGreen_len equ $ - cGreen
    cYellow    db 0x1B,'[93m'
    cYellow_len equ $ - cYellow
    cCyan      db 0x1B,'[96m'
    cCyan_len  equ $ - cCyan
    cWhite     db 0x1B,'[97m'
    cWhite_len equ $ - cWhite
    cGray      db 0x1B,'[90m'
    cGray_len  equ $ - cGray
    cRedB      db 0x1B,'[1m',0x1B,'[91m'
    cRedB_len  equ $ - cRedB
    cGreenB    db 0x1B,'[1m',0x1B,'[92m'
    cGreenB_len equ $ - cGreenB
    cYellowB   db 0x1B,'[1m',0x1B,'[93m'
    cYellowB_len equ $ - cYellowB
    cCyanB     db 0x1B,'[1m',0x1B,'[96m'
    cCyanB_len equ $ - cCyanB

    ; ---- Banner ----
    bannerTop  db '  +==========================================+',13,10
    bannerTop_len equ $ - bannerTop
    bannerMid1 db '  |      N U M B E R   R U S H   6 4       |',13,10
    bannerMid1_len equ $ - bannerMid1
    bannerMid2 db '  |      Elige el numero MAS GRANDE           |',13,10
    bannerMid2_len equ $ - bannerMid2

    ; ---- Intro ----
    intro1     db '  Apareceran 2 numeros aleatorios (10-99).',13,10
    intro1_len equ $ - intro1
    intro2     db '  Gana quien elija el numero MAS GRANDE.',13,10
    intro2_len equ $ - intro2
    intro3     db '  10 rondas + 3 vidas. Acierto = +10 pts.',13,10
    intro3_len equ $ - intro3

    menuJugar   db '        JUGAR'
    menuJugar_len equ $ - menuJugar
    menuSalir   db '        SALIR'
    menuSalir_len equ $ - menuSalir
    cursorMark  db 0xE2,0x96,0xBA,' '   ; ► + espacio (UTF-8)
    cursorMark_len equ $ - cursorMark
    menuHint    db '  Flechas + ENTER para elegir  (1=Jugar  2=Salir)',13,10
    menuHint_len equ $ - menuHint
    menuPad     db '          '
    menuPad_len equ $ - menuPad

    msgEmpezar   db '  Presiona ENTER para empezar...',13,10
    msgEmpezar_len equ $ - msgEmpezar

    ; ---- HUD ----
    msgRonda     db '  RONDA '
    msgRonda_len equ $ - msgRonda
    msgDe        db ' de 10   '
    msgDe_len    equ $ - msgDe
    msgPuntos    db 'PUNTOS '
    msgPuntos_len equ $ - msgPuntos
    msgVidas     db '   VIDAS '
    msgVidas_len equ $ - msgVidas

    corazon    db 0xE2,0x99,0xA5,' '   ; ♥ + espacio (UTF-8)
    corazon_len equ $ - corazon
    sinVidas   db '--'
    sinVidas_len equ $ - sinVidas

    ; ---- Tarjetas de numeros ----
    cardTop    db '    +--------+      +--------+',13,10
    cardTop_len equ $ - cardTop
    cardMidL   db '    |   '
    cardMidL_len equ $ - cardMidL
    cardMidM   db '   |      |   '
    cardMidM_len equ $ - cardMidM
    cardMidR   db '   |',13,10
    cardMidR_len equ $ - cardMidR
    cardLbl    db '     [1] IZQ            [2] DER',13,10
    cardLbl_len equ $ - cardLbl
    lblIzq     db '     [1] IZQ'
    lblIzq_len equ $ - lblIzq
    lblDer     db '            [2] DER'
    lblDer_len equ $ - lblDer
    markIzq    db '        ',0xE2,0x96,0xBA,13,10   ; ► bajo tarjeta izq
    markIzq_len equ $ - markIzq
    markDer    db '                        ',0xE2,0x96,0xBA,13,10
    markDer_len equ $ - markDer

    msgPregunta  db '  Cual es el MAS GRANDE?',13,10
    msgPregunta_len equ $ - msgPregunta
    msgHintJuego db '  Flechas para mover, ENTER para elegir (1/2 directo, q salir)',13,10
    msgHintJuego_len equ $ - msgHintJuego

    msgBien      db '  >> CORRECTO! +10 puntos.',13,10
    msgBien_len  equ $ - msgBien
    msgMal       db '  >> FALLO! Perdiste 1 vida.',13,10
    msgMal_len   equ $ - msgMal

    msgSig       db '  Presiona cualquier tecla para seguir...',13,10
    msgSig_len   equ $ - msgSig

trofeo     db '           .-=========-.',13,10
           db '          /             \',13,10
           db '     ____/    * WIN *    \____',13,10
           db '    /                         \',13,10
           db '   /                           \',13,10
           db '  |_____________________________|',13,10
           db '       \                   /',13,10
           db '        \_________________/',13,10
           db '             |       |',13,10
           db '             |       |',13,10
           db '             |_______|',13,10
           db '          .-===========-.',13,10
           db '         /_______________\',13,10
           db '        |_________________|',13,10
    trofeo_len equ $ - trofeo

calavera   db "          .-''''''''-.",13,10
           db "        .'            '. ",13,10
           db "       /    _      _    \",13,10
           db "      |    / \    / \    |",13,10
           db "      |   | X |  | X |   |",13,10
           db "      |    \_/    \_/    |",13,10
           db "      |       /\         |",13,10
           db "      |      /  \        |",13,10
           db "       \    |____|      /",13,10
           db "        \    ||||     /",13,10
           db "         \___||||___/",13,10
           db "          |  ||||  |",13,10
           db "          |__||||__|",13,10
           db "            \____/",13,10
    calavera_len equ $ - calavera

    msgGanar     db '  *** FELICIDADES! SOBREVIVISTE LAS 10 RONDAS ***',13,10
    msgGanar_len equ $ - msgGanar

    msgPerder    db '  *** GAME OVER - Sin vidas ***',13,10
    msgPerder_len equ $ - msgPerder

    msgFinalPts  db '  Puntaje final: '
    msgFinalPts_len equ $ - msgFinalPts

    msgAdios     db 13,10,'  Gracias por jugar Number Rush!',13,10
    msgAdios_len equ $ - msgAdios

    crlf         db 13,10
    crlf_len     equ $ - crlf

    consolaTitulo db 'NUMBER RUSH - Elige el mas grande',0

section .bss
    hStdOut      resq 1
    hStdIn       resq 1
    bytesWritten resd 1
    bytesRead    resd 1
    consoleMode  resd 1
    stdinMode    resd 1
    eventsRead   resd 1
    inputRecord  resb 32
    seleccion    resb 1
    inputBuf     resb 32
    numBuf       resb 32
    barBuf       resb 16
    tmpCnt       resb 1
    seed         resd 1
    rondaNum     resb 1
    vidasNum     resb 1
    puntosNum    resd 1
    num1v        resb 1
    num2v        resb 1

section .text

; ------------------------------------------------------------
; print_string: RCX = puntero, RDX = longitud
; ------------------------------------------------------------
print_string:
    mov r10, rcx          ; guardar buffer
    mov r11d, edx         ; guardar len
    sub rsp, 40
    mov rcx, [hStdOut]
    mov rdx, r10
    mov r8d, r11d
    mov r9, bytesWritten
    mov qword [rsp+32], 0
    call WriteFile
    add rsp, 40
    ret

; ------------------------------------------------------------
; print_color: RCX = puntero color, RDX = longitud color
; (atajo legible, igual que print_string)
; ------------------------------------------------------------
print_color:
    jmp print_string

; ------------------------------------------------------------
; read_line: lee hasta 32 bytes a inputBuf
; ------------------------------------------------------------
read_line:
    sub rsp, 40
    mov rcx, [hStdIn]
    lea rdx, [inputBuf]
    mov r8d, 32
    mov r9, bytesRead
    mov qword [rsp+32], 0
    call ReadFile
    add rsp, 40
    ret

; ------------------------------------------------------------
; buscar_opcion: busca 1/2/q/Q/ESC en lo leido
; devuelve AL = '1','2','q',0x1B, o 0 si no hay nada
; si bytesRead==0 (EOF) devuelve 'q' para salir limpio
; ------------------------------------------------------------
buscar_opcion:
    mov eax, [bytesRead]
    test eax, eax
    jz .bo_salir        ; EOF -> salir
    lea rcx, [inputBuf]
    mov edx, eax        ; contador
.bo_loop:
    mov al, [rcx]
    cmp al, '1'
    je .bo_ok
    cmp al, '2'
    je .bo_ok
    cmp al, 'q'
    je .bo_q
    cmp al, 'Q'
    je .bo_q
    cmp al, 0x1B
    je .bo_ok
    inc rcx
    dec edx
    jnz .bo_loop
    xor al, al          ; no se encontro nada (ENTER vacio)
    ret
.bo_q:
    mov al, 'q'
    ret
.bo_ok:
    ret                 ; AL ya tiene el caracter
.bo_salir:
    mov al, 'q'
    ret

; ------------------------------------------------------------
; print_number: EAX = numero 0..999999
; (respeta el color activo de la consola)
; ------------------------------------------------------------
print_number:
    mov r10d, eax
    lea r11, [numBuf+32]   ; fin del buffer
    mov rcx, r11           ; puntero actual (ira hacia atras)
    cmp r10d, 0
    jne .pn_div
    dec rcx
    mov byte [rcx], '0'
    jmp .pn_out
.pn_div:
    mov eax, r10d
.pn_loop:
    xor edx, edx
    mov r8d, 10
    div r8d                ; EAX=cociente EDX=resto
    dec rcx
    add dl, '0'
    mov [rcx], dl
    mov r10d, eax
    test eax, eax
    jnz .pn_loop
.pn_out:
    mov rdx, r11
    sub rdx, rcx           ; len
    sub rsp, 40
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; print_hearts: AL = vidas -> ♥♥♥ en rojo (o -- en gris)
; ------------------------------------------------------------
print_hearts:
    mov [tmpCnt], al           ; contador en memoria (r10 se pierde en calls)
    sub rsp, 40
    cmp byte [tmpCnt], 0
    je .ph_none
    lea rcx, [cRed]
    mov edx, cRed_len
    call print_string
.ph_loop:
    lea rcx, [corazon]
    mov edx, corazon_len
    call print_string
    dec byte [tmpCnt]
    jnz .ph_loop
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    jmp .ph_end
.ph_none:
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [sinVidas]
    mov edx, sinVidas_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
.ph_end:
    add rsp, 40
    ret

; ------------------------------------------------------------
; mostrar_banner (cyan + titulo amarillo)
; ------------------------------------------------------------
mostrar_banner:
    sub rsp, 40
    lea rcx, [cCyanB]
    mov edx, cCyanB_len
    call print_string
    lea rcx, [bannerTop]
    mov edx, bannerTop_len
    call print_string
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [bannerMid1]
    mov edx, bannerMid1_len
    call print_string
    lea rcx, [cWhite]
    mov edx, cWhite_len
    call print_string
    lea rcx, [bannerMid2]
    mov edx, bannerMid2_len
    call print_string
    lea rcx, [cCyanB]
    mov edx, cCyanB_len
    call print_string
    lea rcx, [bannerTop]
    mov edx, bannerTop_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; mostrar_progreso: barra [###-------] en verde
; ------------------------------------------------------------
mostrar_progreso:
    movzx eax, byte [rondaNum]  ; 1..11
    dec eax                     ; completadas 0..10
    mov r10d, eax
    lea rcx, [barBuf]
    mov byte [rcx], '['
    inc rcx
    mov edx, 0                  ; i = 0
.pb_loop:
    cmp edx, 10
    jae .pb_fin
    cmp edx, r10d
    jae .pb_vacio
    mov byte [rcx], '#'
    jmp .pb_next
.pb_vacio:
    mov byte [rcx], '-'
.pb_next:
    inc rcx
    inc edx
    jmp .pb_loop
.pb_fin:
    mov byte [rcx], ']'
    sub rsp, 40
    lea rcx, [cGreen]
    mov edx, cGreen_len
    call print_string
    lea rcx, [barBuf]
    mov edx, 12
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; mostrar_hud: banner + ronda + barra + puntos + vidas
; ------------------------------------------------------------
mostrar_hud:
    sub rsp, 40
    lea rcx, [cClear]
    mov edx, cClear_len
    call print_string
    call mostrar_banner
    ; RONDA x de 10
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgRonda]
    mov edx, msgRonda_len
    call print_string
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    movzx eax, byte [rondaNum]
    call print_number
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgDe]
    mov edx, msgDe_len
    call print_string
    call mostrar_progreso
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    ; PUNTOS
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgPuntos]
    mov edx, msgPuntos_len
    call print_string
    lea rcx, [cGreenB]
    mov edx, cGreenB_len
    call print_string
    mov eax, [puntosNum]
    call print_number
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    ; VIDAS
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgVidas]
    mov edx, msgVidas_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    mov al, [vidasNum]
    call print_hearts
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; mostrar_tarjetas: cajas con los 2 numeros
; ------------------------------------------------------------
mostrar_tarjetas:
    sub rsp, 40
    lea rcx, [cCyan]
    mov edx, cCyan_len
    call print_string
    lea rcx, [cardTop]
    mov edx, cardTop_len
    call print_string
    lea rcx, [cardMidL]
    mov edx, cardMidL_len
    call print_string
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    movzx eax, byte [num1v]
    call print_number
    lea rcx, [cCyan]
    mov edx, cCyan_len
    call print_string
    lea rcx, [cardMidM]
    mov edx, cardMidM_len
    call print_string
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    movzx eax, byte [num2v]
    call print_number
    lea rcx, [cCyan]
    mov edx, cCyan_len
    call print_string
    lea rcx, [cardMidR]
    mov edx, cardMidR_len
    call print_string
    lea rcx, [cardTop]
    mov edx, cardTop_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; mostrar_tarjetas_sel: cajas + cursor ► y etiqueta resaltada
; segun [seleccion] (0=izq, 1=der)
; ------------------------------------------------------------
mostrar_tarjetas_sel:
    sub rsp, 40
    call mostrar_tarjetas
    mov al, [seleccion]
    cmp al, 0
    je .ts_izq
    ; --- seleccionado: derecha ---
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [markDer]
    mov edx, markDer_len
    call print_string
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [lblIzq]
    mov edx, lblIzq_len
    call print_string
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [lblDer]
    mov edx, lblDer_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    jmp .ts_fin
.ts_izq:
    ; --- seleccionado: izquierda ---
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [markIzq]
    mov edx, markIzq_len
    call print_string
    lea rcx, [lblIzq]
    mov edx, lblIzq_len
    call print_string
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [lblDer]
    mov edx, lblDer_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
.ts_fin:
    add rsp, 40
    ret

mostrar_puntaje_final:
    sub rsp, 40
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [msgFinalPts]
    mov edx, msgFinalPts_len
    call print_string
    mov eax, [puntosNum]
    call print_number
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; random_10_99: devuelve AL = 10..99
; ------------------------------------------------------------
random_10_99:
    sub rsp, 40
    call GetTickCount      ; EAX = ms
    add rsp, 40
    add eax, [seed]
    add eax, 37
    mov [seed], eax
    xor edx, edx
    mov ecx, 90
    div ecx                ; EDX = resto 0..89
    mov al, dl
    add al, 10
    ret

sonido_bien:
    sub rsp, 40
    mov ecx, 880
    mov edx, 150
    call Beep
    add rsp, 40
    ret

sonido_mal:
    sub rsp, 40
    mov ecx, 220
    mov edx, 300
    call Beep
    add rsp, 40
    ret

sonido_tick:
    sub rsp, 40
    mov ecx, 660
    mov edx, 40
    call Beep
    add rsp, 40
    ret

; ------------------------------------------------------------
; limpiar_teclado: descarta teclas pendientes
; ------------------------------------------------------------
limpiar_teclado:
    sub rsp, 40
    mov rcx, [hStdIn]
    call FlushConsoleInputBuffer
    add rsp, 40
    ret

; ------------------------------------------------------------
; leer_tecla: espera tecla y devuelve AX = codigo virtual
;   0x25 IZQ  0x26 ARR  0x27 DER  0x28 ABA  0x0D ENTER
;   0x1B ESC  0x20 ESPACIO  0x31 '1'  0x32 '2'  0x51 'Q'
; Si stdin no es consola (tuberia), usa ReadFile como respaldo.
; ------------------------------------------------------------
leer_tecla:
    sub rsp, 40
.lt_loop:
    mov rcx, [hStdIn]
    lea rdx, [inputRecord]
    mov r8d, 1
    mov r9, eventsRead
    mov qword [rsp+32], 0
    call ReadConsoleInputA
    test eax, eax
    jz .lt_pipe             ; fallo = stdin redirigido
    movzx eax, word [inputRecord]   ; EventType
    cmp ax, 1
    jne .lt_loop           ; no es teclado -> ignorar
    cmp dword [inputRecord+4], 0     ; bKeyDown?
    je .lt_loop            ; tecla soltada -> ignorar
    movzx eax, word [inputRecord+10] ; wVirtualKeyCode
    jmp .lt_out
.lt_pipe:
    call read_line
    call buscar_opcion
    cmp al, '1'
    je .lt_uno
    cmp al, '2'
    je .lt_dos
    cmp al, 'q'
    je .lt_qu
    mov eax, 0x0D          ; ENTER vacio = confirmar
    jmp .lt_out
.lt_uno:
    mov eax, 0x31
    jmp .lt_out
.lt_dos:
    mov eax, 0x32
    jmp .lt_out
.lt_qu:
    mov eax, 0x51
.lt_out:
    add rsp, 40
    ret

; ------------------------------------------------------------
; dibujar_eleccion: HUD + tarjetas con cursor + pregunta
; ------------------------------------------------------------
dibujar_eleccion:
    sub rsp, 40
    call mostrar_hud
    call mostrar_tarjetas_sel
    lea rcx, [cCyanB]
    mov edx, cCyanB_len
    call print_string
    lea rcx, [msgPregunta]
    mov edx, msgPregunta_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgHintJuego]
    mov edx, msgHintJuego_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; elegir_tarjeta: selector con cursor. AL='1'/'2'/'q'
; ------------------------------------------------------------
elegir_tarjeta:
    sub rsp, 40
    call limpiar_teclado
    mov byte [seleccion], 0
    call dibujar_eleccion
.et_loop:
    call leer_tecla        ; AX = codigo
    cmp ax, 0x25           ; IZQ
    je .et_izq
    cmp ax, 0x26           ; ARR
    je .et_izq
    cmp ax, 0x27           ; DER
    je .et_der
    cmp ax, 0x28           ; ABA
    je .et_der
    cmp ax, 0x31           ; '1' directo
    je .et_uno
    cmp ax, 0x32           ; '2' directo
    je .et_dos
    cmp ax, 0x51           ; 'Q'
    je .et_q
    cmp ax, 0x1B           ; ESC
    je .et_q
    cmp ax, 0x0D           ; ENTER = confirmar
    je .et_ok
    cmp ax, 0x20           ; ESPACIO = confirmar
    je .et_ok
    jmp .et_loop
.et_izq:
    cmp byte [seleccion], 0
    je .et_loop
    mov byte [seleccion], 0
    call sonido_tick
    call dibujar_eleccion
    jmp .et_loop
.et_der:
    cmp byte [seleccion], 1
    je .et_loop
    mov byte [seleccion], 1
    call sonido_tick
    call dibujar_eleccion
    jmp .et_loop
.et_uno:
    mov byte [seleccion], 0
    mov al, '1'
    jmp .et_fin
.et_dos:
    mov byte [seleccion], 1
    mov al, '2'
    jmp .et_fin
.et_ok:
    mov al, [seleccion]
    cmp al, 0
    je .et_uno
    jmp .et_dos
.et_q:
    mov al, 'q'
.et_fin:
    add rsp, 40
    ret

; ------------------------------------------------------------
; dibujar_menu: banner + intro + opciones con cursor
; ------------------------------------------------------------
dibujar_menu:
    sub rsp, 40
    lea rcx, [cClear]
    mov edx, cClear_len
    call print_string
    call mostrar_banner
    lea rcx, [cWhite]
    mov edx, cWhite_len
    call print_string
    lea rcx, [intro1]
    mov edx, intro1_len
    call print_string
    lea rcx, [intro2]
    mov edx, intro2_len
    call print_string
    lea rcx, [cYellow]
    mov edx, cYellow_len
    call print_string
    lea rcx, [intro3]
    mov edx, intro3_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    mov al, [seleccion]
    cmp al, 0
    je .dm_jugar
    ; --- cursor en SALIR ---
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [menuPad]
    mov edx, menuPad_len
    call print_string
    lea rcx, [menuJugar]
    mov edx, menuJugar_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [cursorMark]
    mov edx, cursorMark_len
    call print_string
    lea rcx, [menuSalir]
    mov edx, menuSalir_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    jmp .dm_hint
.dm_jugar:
    ; --- cursor en JUGAR ---
    lea rcx, [cYellowB]
    mov edx, cYellowB_len
    call print_string
    lea rcx, [cursorMark]
    mov edx, cursorMark_len
    call print_string
    lea rcx, [menuJugar]
    mov edx, menuJugar_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [menuPad]
    mov edx, menuPad_len
    call print_string
    lea rcx, [menuSalir]
    mov edx, menuSalir_len
    call print_string
    lea rcx, [crlf]
    mov edx, crlf_len
    call print_string
.dm_hint:
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [menuHint]
    mov edx, menuHint_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    ret

; ------------------------------------------------------------
; menu_principal: AL='j' (jugar) o 'q' (salir)
; ------------------------------------------------------------
menu_principal:
    sub rsp, 40
    call limpiar_teclado
    mov byte [seleccion], 0
    call dibujar_menu
.mn_loop:
    call leer_tecla
    cmp ax, 0x26           ; ARR
    je .mn_arr
    cmp ax, 0x28           ; ABA
    je .mn_aba
    cmp ax, 0x25           ; IZQ
    je .mn_arr
    cmp ax, 0x27           ; DER
    je .mn_aba
    cmp ax, 0x31           ; '1' = jugar
    je .mn_jugar
    cmp ax, 0x32           ; '2' = salir
    je .mn_salir
    cmp ax, 0x51           ; 'Q'
    je .mn_salir
    cmp ax, 0x1B           ; ESC
    je .mn_salir
    cmp ax, 0x0D           ; ENTER
    je .mn_ok
    cmp ax, 0x20           ; ESPACIO
    je .mn_ok
    jmp .mn_loop
.mn_arr:
    cmp byte [seleccion], 0
    je .mn_loop
    mov byte [seleccion], 0
    call sonido_tick
    call dibujar_menu
    jmp .mn_loop
.mn_aba:
    cmp byte [seleccion], 1
    je .mn_loop
    mov byte [seleccion], 1
    call sonido_tick
    call dibujar_menu
    jmp .mn_loop
.mn_ok:
    mov al, [seleccion]
    cmp al, 0
    je .mn_jugar
    jmp .mn_salir
.mn_jugar:
    mov al, 'j'
    jmp .mn_fin
.mn_salir:
    mov al, 'q'
.mn_fin:
    add rsp, 40
    ret

; ============================================================
start:
    and rsp, -16           ; alinear stack base
    sub rsp, 8             ; dejar base en 8-mod-16 como funcion normal

    ; consola UTF-8 + titulo + handles + colores ANSI
    sub rsp, 40
    lea rcx, [consolaTitulo]
    call SetConsoleTitleA
    mov ecx, 65001
    call SetConsoleOutputCP
    mov ecx, -11
    call GetStdHandle
    mov [hStdOut], rax
    mov ecx, -10
    call GetStdHandle
    mov [hStdIn], rax
    ; activar procesamiento ANSI (ENABLE_VIRTUAL_TERMINAL_PROCESSING=4)
    mov rcx, [hStdOut]
    lea rdx, [consoleMode]
    call GetConsoleMode
    mov eax, [consoleMode]
    or eax, 4
    mov rcx, [hStdOut]
    mov edx, eax
    call SetConsoleMode
    ; teclado directo: sin linea ni eco (para flechas con ReadConsoleInputA)
    mov rcx, [hStdIn]
    lea rdx, [stdinMode]
    call GetConsoleMode
    mov eax, [stdinMode]
    and eax, 0FFFFFFF9h    ; quitar LINE_INPUT(2)+ECHO_INPUT(4)
    or eax, 1              ; mantener PROCESSED_INPUT
    mov rcx, [hStdIn]
    mov edx, eax
    call SetConsoleMode
    add rsp, 40

    ; init variables
    mov byte [rondaNum], 1
    mov byte [vidasNum], 3
    mov dword [puntosNum], 0
    mov dword [seed], 1234

    ; menu principal con cursor
    sub rsp, 40
    call menu_principal
    add rsp, 40
    cmp al, 'q'
    je salir

juego_loop:
    mov al, [rondaNum]
    cmp al, 10
    ja fin_ganar
    mov al, [vidasNum]
    cmp al, 0
    je fin_perder

    sub rsp, 40
    call mostrar_hud
    add rsp, 40

generar:
    sub rsp, 40
    call random_10_99
    mov [num1v], al
    call random_10_99
    mov [num2v], al
    add rsp, 40
    mov al, [num1v]
    cmp al, [num2v]
    je generar

    sub rsp, 40
    call elegir_tarjeta    ; dibuja HUD+tarjetas y elige con cursor
    add rsp, 40

    cmp al, 'q'
    je salir
    cmp al, '1'
    je eligio_1
    jmp eligio_2

eligio_1:
    mov al, [num1v]
    cmp al, [num2v]
    ja acierto
    jmp fallo

eligio_2:
    mov al, [num2v]
    cmp al, [num1v]
    ja acierto
    jmp fallo

acierto:
    mov eax, [puntosNum]
    add eax, 10
    mov [puntosNum], eax
    sub rsp, 40
    lea rcx, [cGreenB]
    mov edx, cGreenB_len
    call print_string
    lea rcx, [msgBien]
    mov edx, msgBien_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    call sonido_bien
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgSig]
    mov edx, msgSig_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    call read_line
    add rsp, 40
    jmp siguiente_ronda

fallo:
    dec byte [vidasNum]
    sub rsp, 40
    lea rcx, [cRedB]
    mov edx, cRedB_len
    call print_string
    lea rcx, [msgMal]
    mov edx, msgMal_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    call sonido_mal
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgSig]
    mov edx, msgSig_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    call read_line
    add rsp, 40
    jmp siguiente_ronda

siguiente_ronda:
    inc byte [rondaNum]
    jmp juego_loop

fin_ganar:
    sub rsp, 40
    lea rcx, [cClear]
    mov edx, cClear_len
    call print_string
    call mostrar_banner
    lea rcx, [cGreenB]
    mov edx, cGreenB_len
    call print_string
    lea rcx, [trofeo]
    mov edx, trofeo_len
    call print_string
    lea rcx, [msgGanar]
    mov edx, msgGanar_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    call mostrar_puntaje_final
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgAdios]
    mov edx, msgAdios_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    jmp terminar

fin_perder:
    sub rsp, 40
    lea rcx, [cClear]
    mov edx, cClear_len
    call print_string
    call mostrar_banner
    lea rcx, [cRedB]
    mov edx, cRedB_len
    call print_string
    lea rcx, [calavera]
    mov edx, calavera_len
    call print_string
    lea rcx, [msgPerder]
    mov edx, msgPerder_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    call mostrar_puntaje_final
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgAdios]
    mov edx, msgAdios_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40
    jmp terminar

salir:
    sub rsp, 40
    lea rcx, [cGray]
    mov edx, cGray_len
    call print_string
    lea rcx, [msgAdios]
    mov edx, msgAdios_len
    call print_string
    lea rcx, [cReset]
    mov edx, cReset_len
    call print_string
    add rsp, 40

terminar:
    sub rsp, 40
    xor ecx, ecx
    call ExitProcess
    add rsp, 40
    ret
