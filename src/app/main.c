/*******************************************************************************
** Name: main.c
** Description: CMSIS-RTOS 'main' function file.
**
********************************************************************************
**
**	Copyright (C) 2015 by Omid Manikhi.
**
*******************************************************************************/

#define osObjectsPublic                     // define objects in main module
#include "osObjects.h"                      // RTOS object definitions

/*
** main: initialize and start the system
*/

int main (void) {
	
	/*
	** Initialize CMSIS-RTOS.
	*/

	osKernelInitialize ();

	/*
	** TODO: Initialize the peripherals and threads here.
	**
	** create 'thread' functions that start executing,
	** example: tid_name = osThreadCreate (osThread(name), NULL);
	*/


	/*
	** Start the thread execution.
	*/

	osKernelStart ();

	while( 1 );

	return 0;
}
