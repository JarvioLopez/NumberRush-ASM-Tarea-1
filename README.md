# Number Rush 64-bit - Tarea de Programación en Ensamblador

## Descripción General
Number Rush es una tarea académica desarrollada completamente en lenguaje ensamblador NASM para la arquitectura x86-64 de Windows. El objetivo de la tarea es aplicar conceptos de programación de bajo nivel creando un juego interactivo donde el jugador debe identificar el número más grande entre dos opciones aleatorias.

## Objetivos de la Tarea
- Aplicar conceptos de programación de bajo nivel en un ejercicio práctico
- Implementar manipulación directa de memoria y registros
- Utilizar la API de Windows para E/S y gestión de consola
- Desarrollar una interfaz interactiva con colores y animaciones
- Manejar eventos de teclado en tiempo real

## Características Técnicas

### Lenguaje y Herramientas
- **Lenguaje**: Ensamblador NASM (Netwide Assembler)
- **Arquitectura**: x86-64 (Windows 64-bit)
- **Enlazador**: GoLink
- **API**: Win32 API (kernel32.dll)

### Funcionalidades Principales
- **Sistema de menú interactivo**: Navegación con cursor mediante flechas del teclado
- **Generación de números aleatorios**: Algoritmo pseudo-aleatorio basado en GetTickCount
- **Sistema de vidas y puntuación**: 3 vidas iniciales, +10 puntos por acierto
- **Feedback visual y sonoro**: Colores ANSI y sonidos Beep de Windows
- **Arte ASCII**: Representaciones gráficas de trofeo (victoria) y calavera (derrota)
- **10 rondas de juego**: Progresión con barra de progreso visual

### Aspectos Técnicos Destacados
- **Manejo de stack**: Alineación de 16 bytes para llamadas a API de Windows
- **Programación de bajo nivel**: Manipulación directa de registros (RAX, RCX, RDX, etc.)
- **Conversión numérica**: Algoritmo de división sucesiva para convertir enteros a strings
- **Gestión de consola**: Modos de entrada/salida, habilitación de secuencias ANSI
- **Control de flujo**: Bucles, condicionales y subrutinas estructuradas

## Código y Estructura
El código está organizado en:
- **Section .data**: Cadenas de texto, colores ANSI, arte ASCII
- **Section .bss**: Variables no inicializadas (handles, buffers, contadores)
- **Section .text**: Código ejecutable con funciones modularizadas

### Funciones principales
- `print_string`: E/S básica a consola
- `leer_tecla`: Captura de eventos de teclado
- `random_10_99`: Generación de números aleatorios
- `mostrar_hud`: Renderizado de interfaz de usuario
- `elegir_tarjeta`: Lógica de selección interactiva

## Cómo Compilar y Ejecutar

### Requisitos
- Windows 64-bit
- NASM (incluido en carpeta `tools/nasm/`)
- GoLink (incluido en carpeta `tools/golink/`)

### Instrucciones
1. Abrir `compilar.bat` (doble click)
2. El script compilará el código y generará `NumberRush.exe`
3. El juego se abrirá automáticamente

### Controles del Juego
- **Flechas**: Mover cursor
- **ENTER**: Seleccionar opción
- **1**: Seleccionar izquierda directamente
- **2**: Seleccionar derecha directamente
- **Q / ESC**: Salir del juego

## Resultados
El proyecto demuestra el dominio de conceptos fundamentales de arquitectura de computadores:
- Gestión de memoria y stack
- Llamadas al sistema operativo
- Programación procedimental en bajo nivel
- Optimización de recursos (sin dependencias externas)

El ejecutable final ocupa solo **8,192 bytes**, demostrando la eficiencia del código ensamblador.

## Archivos de la Tarea
- `NumberRush.asm`: Código fuente en ensamblador
- `compilar.bat`: Script de compilación
- `LEEME.txt`: Instrucciones básicas
- `tools/`: Herramientas de compilación (NASM, GoLink)
- `NumberRush.exe`: Ejecutable final (generado al compilar)

## Licencia
Tarea educativa desarrollada para fines académicos.
