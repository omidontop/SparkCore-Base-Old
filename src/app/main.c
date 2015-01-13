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
#include "stm32f10x_conf.h"


/*******************************************************************************
** Function Name  : main()
** Description    : Initialize and start the system.
** Input          : None
** Output         : None
** Return         : None
*******************************************************************************/

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


#ifdef USE_FULL_ASSERT
/*******************************************************************************
** Function Name  : assert_failed
** Description    : Reports the name of the source file and the source line number
**                  where the assert_param error has occurred.
** Input          : - file: pointer to the source file name
**                  - line: assert_param error line source number
** Output         : None
** Return         : None
*******************************************************************************/
void assert_failed(uint8_t* file, uint32_t line)
{
	/* User can add his own implementation to report the file name and line number,
	 ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

	/* Infinite loop */
	while (1)
	{
	}
}
#endif
