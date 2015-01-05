/*******************************************************************************
*
* Name: config.h
* Description: a header file containing various configurations of the
* 	components as well as the application itself.
*
********************************************************************************
*
* 	Copyright (C) 2015 by Omid Manikhi
*
*******************************************************************************/

#ifndef __CONFIG_H
#define __CONFIG_H

#ifdef __cplusplus
 extern "C" {
#endif

/*
** Specify the entry point of the application i.e the main() function.
*/
#define __START				main

/*
** Specify the Stack Size.
*/
#define __STACK_SIZE		2048

/*
** Specify the Heap Size.
*/
#define __HEAP_SIZE			4096

#ifdef __cplusplus
}
#endif

#endif /* __CONFIG_H */
